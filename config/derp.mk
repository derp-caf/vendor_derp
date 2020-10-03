PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    keyguard.no_require_sim=true \
    ro.com.google.clientidbase=android-google \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false \
    ro.setupwizard.rotation_locked=true


# RecueParty? No thanks.
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.sys.enable_rescue=false

# Show SELinux status on About Settings
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.build.selinux=1

# Mark as eligible for Google Assistant
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.opa.eligible_device=true

ifneq ($(TARGET_BUILD_VARIANT),user)
# Thank you, please drive thru!
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.sys.dun.override=0
endif

# enable ADB authentication if not on eng build
ifeq ($(TARGET_BUILD_VARIANT),eng)
# Disable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=0
else
# Enable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

# Tethering - allow without requiring a provisioning app
# (for devices that check this)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    net.tethering.noprovisioning=true

# Media
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    media.recorder.show_manufacturer_and_model=true

ifeq ($(BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE),)
  PRODUCT_DEFAULT_PROPERTY_OVERRIDES  += \
    ro.device.cache_dir=/data/cache
else
  PRODUCT_DEFAULT_PROPERTY_OVERRIDES  += \
    ro.device.cache_dir=/cache
endif

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/derp/prebuilt/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/derp/prebuilt/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/derp/prebuilt/bin/blacklist:system/addon.d/blacklist \
    vendor/derp/prebuilt/bin/whitelist:system/addon.d/whitelist \
    vendor/derp/prebuilt/common/bin/clean_cache.sh:system/bin/clean_cache.sh


ifeq ($(AB_OTA_UPDATER),true)
PRODUCT_COPY_FILES += \
    vendor/derp/prebuilt/bin/backuptool_ab.sh:system/bin/backuptool_ab.sh \
    vendor/derp/prebuilt/bin/backuptool_ab.functions:system/bin/backuptool_ab.functions \
    vendor/derp/prebuilt/bin/backuptool_postinstall.sh:system/bin/backuptool_postinstall.sh
endif

# Dialer fix
PRODUCT_COPY_FILES +=  \
    vendor/derp/prebuilt/etc/sysconfig/dialer_experience.xml:system/etc/sysconfig/dialer_experience.xml

# init.d support
PRODUCT_COPY_FILES += \
    vendor/derp/prebuilt/bin/sysinit:system/bin/sysinit \
    vendor/derp/prebuilt/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/derp/prebuilt/etc/init.d/90userinit:system/etc/init.d/90userinit

# Copy all Derp-CAF-specific init rc files
$(foreach f,$(wildcard vendor/derp/prebuilt/etc/init/*.rc),\
$(eval PRODUCT_COPY_FILES += $(f):system/etc/init/$(notdir $f)))

# Bring in camera effects
PRODUCT_COPY_FILES +=  \
    vendor/derp/prebuilt/media/LMprec_508.emd:system/media/LMprec_508.emd \
    vendor/derp/prebuilt/media/PFFprec_600.emd:system/media/PFFprec_600.emd

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

# Misc packages
PRODUCT_PACKAGES += \
    libemoji \
    libsepol \
    e2fsck \
    bash \
    powertop \
    fibmap.f2fs \
    gdbserver \
    micro_bench \
    oprofiled \
    sqlite3 \
    strace \
    Terminal \
    libbthost_if \
    WallpaperPicker

# Filesystems tools
PRODUCT_PACKAGES += \
    fsck.exfat \
    fsck.ntfs \
    mke2fs \
    mkfs.exfat \
    mkfs.ntfs \
    mount.ntfs

# Include librsjni explicitly to workaround GMS issue
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full \
    librsjni

# World APN list
PRODUCT_COPY_FILES += \
     vendor/derp/prebuilt/etc/apns-conf.xml:system/etc/apns-conf.xml

# Proprietary latinime libs needed for Keyboard swyping
ifneq ($(filter arm64,$(TARGET_ARCH)),)
PRODUCT_COPY_FILES += \
    vendor/derp/prebuilt/lib/libjni_latinime.so:system/lib/libjni_latinime.so \
    vendor/derp/prebuilt/lib/libjni_latinimegoogle.so:system/lib/libjni_latinimegoogle.so
else
PRODUCT_COPY_FILES += \
    vendor/derp/prebuilt/lib64/libjni_latinime.so:system/lib64/libjni_latinime.so \
    vendor/derp/prebuilt/lib64/libjni_latinimegoogle.so:system/lib64/libjni_latinimegoogle.so
endif


ifndef DERP_BUILD_TYPE
    BUILD_DEVICE=$(shell echo "$(TARGET_PRODUCT)" | cut -d'_' -f 2,3)
ifeq ($(DERP_RELEASE),true)
    FOUND = $(shell /usr/bin/curl -s https://raw.githubusercontent.com/Derp-CAF/vendor_derp/r11/derp.devices)
    GOT_DEVICE =  $(filter $(BUILD_DEVICE), $(FOUND))
    ifeq ($(GOT_DEVICE),$(BUILD_DEVICE))
    IS_OFFICIAL=true
    DERP_BUILD_TYPE := OFFICIAL
    DERP_POSTFIX := -$(shell date +"%Y%m%d-%H%M")
    endif
    ifneq ($(IS_OFFICIAL), true)
       DERP_RELEASE=false
       DERP_BUILD_TYPE := UNOFFICIAL
       DERP_POSTFIX := -$(shell date +"%Y%m%d-%H%M")
       $(error Your Device is not official "$(FOUND)")
    endif
else
    DERP_BUILD_TYPE := UNOFFICIAL
    DERP_POSTFIX := -$(shell date +"%Y%m%d-%H%M")
endif
endif


# Derp-CAF versions.
CAF_REVISION := LA.UM.9.2.r1-00900-SDMxx0.0
DERP_VERSION_FLAVOUR = ALPHA
DERP_VERSION_CODENAME := 0.05
PLATFORM_VERSION_FLAVOUR := R

# Set all versions
DERP_VERSION := DerpCAF-v$(DERP_VERSION_CODENAME)-$(DERP_VERSION_FLAVOUR)-$(PLATFORM_VERSION_FLAVOUR)-$(DERP_BUILD_TYPE)$(DERP_POSTFIX)
DERP_MOD_VERSION := DerpCAF-v$(DERP_VERSION_CODENAME)-$(DERP_VERSION_FLAVOUR)-$(PLATFORM_VERSION_FLAVOUR)-$(DERP_BUILD)-$(DERP_BUILD_TYPE)$(DERP_POSTFIX)
CUSTOM_FINGERPRINT := Derp-CAF/$(PLATFORM_VERSION)/$(DERP_VERSION_CODENAME)-$(DERP_VERSION_FLAVOUR)/$(TARGET_PRODUCT)/$(shell date +%Y%m%d-%H:%M)

# Overlays
PRODUCT_PACKAGE_OVERLAYS += \
	vendor/derp/overlay/common

# Default notification/alarm sounds
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.config.ringtone=The_big_adventure.ogg \
    ro.config.notification_sound=Ping.ogg \
    ro.config.alarm_alert=Spokes.ogg

#Derp additions
PRODUCT_PACKAGES += \
    SnapdragonGallery \
    LatinIME \
    MusicFX


ifneq ($(HOST_OS),linux)
ifneq ($(sdclang_already_warned),true)
$(warning **********************************************)
$(warning * SDCLANG is not supported on non-linux hosts.)
$(warning **********************************************)
sdclang_already_warned := true
endif
else
# include definitions for SDCLANG
include vendor/derp/sdclang/sdclang.mk
endif

#BootAnimation
$(call inherit-product, vendor/derp/config/bootanimation.mk)

#Telephony
$(call inherit-product, vendor/derp/config/telephony.mk)

