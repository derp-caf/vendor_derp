# Copyright (C) 2017 Unlegacy-Android
# Copyright (C) 2017 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# -----------------------------------------------------------------

# Derp-CAF OTA update package
DERP_TARGET_PACKAGE := $(PRODUCT_OUT)/$(DERP_MOD_VERSION).zip

# Shell color defs:
CL_RED="\033[31m"
CL_GRN="\033[32m"
CL_YLW="\033[33m"
CL_BLU="\033[34m"
CL_MAG="\033[35m"
CL_CYN="\033[36m"
CL_RST="\033[0m"

.PHONY: bacon
derp: bacon
bacon: $(INTERNAL_OTA_PACKAGE_TARGET)
	$(hide) ln -f $(INTERNAL_OTA_PACKAGE_TARGET) $(DERP_TARGET_PACKAGE)
	$(hide) $(MD5SUM) $(DERP_TARGET_PACKAGE) | sed "s|$(PRODUCT_OUT)/||" > $(DERP_TARGET_PACKAGE).md5sum
	 @echo "Package Complete: $(INTERNAL_BACON_TARGET)" >&2
	 @echo -e ${CL_RST}"                                                                      "${CL_RST}
	 @echo -e ${CL_RED}"                                                                      "${CL_RED}
	 @echo -e ${CL_RED}"  ▓█████▄ ▓█████  ██▀███   ██▓███   ▄████▄   ▄▄▄        █████▒        "${CL_RED}
	 @echo -e ${CL_RED}"  ▒██▀ ██▌▓█   ▀ ▓██ ▒ ██▒▓██░  ██▒▒██▀ ▀█  ▒████▄    ▓██             "${CL_RED}
	 @echo -e ${CL_RED}"  ░██   █▌▒███   ▓██ ░▄█ ▒▓██░ ██▓▒▒▓█    ▄ ▒██  ▀█▄  ▒████           "${CL_RED}
	 @echo -e ${CL_RED}"  ░▓█▄   ▌▒▓█  ▄ ▒██▀▀█▄  ▒██▄█▓▒ ▒▒▓▓▄ ▄██▒░██▄▄▄▄██ ░▓█▒            "${CL_RED}
	 @echo -e ${CL_RED}"  ░▒████▓ ░▒████▒░██▓ ▒██▒▒██▒ ░  ░▒ ▓███▀ ░ ▓█   ▓██▒░▒█░            "${CL_RED}
	 @echo -e ${CL_RED}"   ▒▒▓  ▒ ░░ ▒░ ░░ ▒▓ ░▒▓░▒▓▒░ ░  ░░ ░▒ ▒  ░ ▒▒   ▓▒█░ ▒ ░            "${CL_RED}
	 @echo -e ${CL_RED}"   ░ ▒  ▒  ░ ░  ░  ░▒ ░ ▒░░▒ ░       ░  ▒     ▒   ▒▒ ░ ░              "${CL_RED}
	 @echo -e ${CL_RED}"   ░ ░  ░    ░     ░░   ░ ░░       ░          ░   ▒    ░ ░            "${CL_RED}
	 @echo -e ${CL_RST}"                                                                      "${CL_RST}
	 @echo -e ${CL_RST}"                                                                      "${CL_RST}
	 @echo -e ${CL_RST}"           Build completed! Now derp your phone and enjoy!!           "${CL_RST}
	 @echo -e ${CL_RST}"                                                                      "${CL_RST}
	 @echo -e ${CL_RED}"======================================================================"${CL_RED}
	 @echo -e ${CL_RST}"  $(INTERNAL_BACON_TARGET)                                            "${CL_RST}
	 @echo "Zip: $(DERP_TARGET_PACKAGE)"
	 @echo -e ${CL_BLD}${CL_YLW}"Size:"${CL_YLW}" `du -sh $(INTERNAL_BACON_TARGET) | awk '{print $$1}' `"${CL_RST}
	 @echo -e ${CL_RED}"======================================================================"${CL_RED}
	 @echo -e ${CL_RST}"                                                                      "${CL_RST}
