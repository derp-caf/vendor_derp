include vendor/derp/config/BoardConfigKernel.mk

ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
include vendor/derp/config/BoardConfigQcom.mk
endif

include vendor/derp/config/BoardConfigSoong.mk

include vendor/derp/config/BoardConfigKernel.mk

# Disable qmi EAP-SIM security
DISABLE_EAP_PROXY := true
