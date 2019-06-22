# Include board/platform macros
include vendor/derp/build/core/utils.mk

# Include vendor platform definitions
include vendor/derp/build/core/vendor/*.mk

# We modify several neverallows, so let the build proceed
ifneq ($(TARGET_BUILD_VARIANT),user)
SELINUX_IGNORE_NEVERALLOWS := true
endif

# Rules for QCOM targets
include $(TOPDIR)vendor/derp/build/core/qcom_target.mk
