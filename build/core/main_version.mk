# Derp sprcific build properties
ADDITIONAL_BUILD_PROPERTIES += \
    BUILD_DISPLAY_ID=$(BUILD_ID) \
    derp.ota.version=$(DERP_MOD_VERSION) \
    ro.caf.revision=$(CAF_REVISION) \
    ro.derp.buildtype=$(DERP_BUILD_TYPE) \
    ro.derp.flavour=$(DERP_VERSION_FLAVOUR) \
    ro.derp.version=$(DERP_VERSION_CODENAME)-$(DERP_VERSION_FLAVOUR) \
    ro.derp.fingerprint=$(CUSTOM_FINGERPRINT) \
    ro.modversion=$(DERP_MOD_VERSION)

