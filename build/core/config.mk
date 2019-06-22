# Rules for MTK targets
include $(TOPDIR)vendor/derp/build/core/qcom_target.mk

# We modify several neverallows, so let the build proceed
ifneq ($(TARGET_BUILD_VARIANT),user)
SELINUX_IGNORE_NEVERALLOWS := true
endif

# Rules for QCOM targets
include $(TOPDIR)vendor/derp/build/core/qcom_target.mk
include $(TOPDIR)vendor/derp/build/core/qcom_utils.mk
>>>>>>> fdc1d40... build: Reorganize inclusion of QCOM macros
