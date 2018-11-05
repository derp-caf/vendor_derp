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

# Telephony packages
PRODUCT_PACKAGES += \
    messaging \
    CellBroadcastReceiver \
    Stk \
    telephony-ext

PRODUCT_BOOT_JARS += \
    telephony-ext

#RCS
PRODUCT_PACKAGES += \
    rcs_service_aidl \
    rcs_service_aidl.xml \
    rcs_service_aidl_static \
    rcs_service_api \
    rcs_service_api.xml

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


# include definitions for SDCLANG
include vendor/derp/build/sdclang/sdclang.mk

ifndef DERP_BUILD_TYPE
ifeq ($(DERP_RELEASE),true)
    BUILD_DEVICE=$(shell echo "$(TARGET_PRODUCT)" | cut -d'_' -f 2,3)
    FOUND = $(shell curl -s https://raw.githubusercontent.com/Derp-CAF/vendor_derp/p/derp.devices)
    GOT_DEVICE =  $(filter $(BUILD_DEVICE), $(FOUND))
    ifeq ($(GOT_DEVICE),$(BUILD_DEVICE))
    IS_OFFICIAL=true
    DERP_BUILD_TYPE := OFFICIAL
    DERP_POSTFIX := -$(shell date +"%Y%m%d")
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


# Changelog
ifeq ($(DERP_RELEASE),true)
PRODUCT_COPY_FILES +=  \
    vendor/derp/prebuilt/common/etc/Changelog.txt:system/etc/Changelog.txt
else
GENERATE_CHANGELOG := true
endif

# Derp-CAF versions.
CAF_REVISION := LA.UM.7.2.r1-05500-sdm660.0
DERP_VERSION_FLAVOUR = NASTY
DERP_VERSION_CODENAME := 1.0
PLATFORM_VERSION_FLAVOUR := Pie

# Set all versions
DERP_VERSION := DerpCAF-v$(DERP_VERSION_CODENAME)-$(DERP_VERSION_FLAVOUR)-$(PLATFORM_VERSION_FLAVOUR)-$(DERP_BUILD_TYPE)$(DERP_POSTFIX)
DERP_MOD_VERSION := DerpCAF-v$(DERP_VERSION_CODENAME)-$(DERP_VERSION_FLAVOUR)-$(PLATFORM_VERSION_FLAVOUR)-$(DERP_BUILD)-$(DERP_BUILD_TYPE)$(DERP_POSTFIX)
CUSTOM_FINGERPRINT := Derp-CAF/$(PLATFORM_VERSION)/$(DERP_VERSION_CODENAME)-$(DERP_VERSION_FLAVOUR)/$(TARGET_PRODUCT)/$(shell date +%Y%m%d-%H:%M)

# TCP Connection Management
PRODUCT_PACKAGES += tcmiface
PRODUCT_BOOT_JARS += tcmiface

# Overlays
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/derp/overlay/*
DEVICE_PACKAGE_OVERLAYS += vendor/derp/overlay/*

# Default notification/alarm sounds
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.config.ringtone=The_big_adventure.ogg \
    ro.config.notification_sound=Ping.ogg \
    ro.config.alarm_alert=Spokes.ogg

#Derp additions
PRODUCT_PACKAGES += \
    Turbo \
    SnapdragonGallery \
    SnapdragonMusic \
    LatinIME \
    OmniJaws \
    OmniStyle \
    LiveWallpapersPicker \
    SoundPickerPrebuilt \
    MusicFX

# QS tile styles
PRODUCT_PACKAGES += \
    QStileCircleTrim \
    QStileDefault \
    QStileDualToneCircle \
    QStileSquircleTrim \
    QStileAttemptMountain \
    QStileCircleDualTone \
    QStileCircleGradient \
    QStileDottedCircle \
    QStileNinja \
    QStilePokesign \
    QStileWavey

# SubstratumSignature Package
PRODUCT_COPY_FILES += \
     vendor/derp/prebuilt/common/app/SubstratumSignature.apk:system/priv-app/SubstratumSignature/SubstratumSignature.apk

# Permissions
PRODUCT_COPY_FILES += \
    vendor/derp/prebuilt/common/etc/permissions/privapp-permissions-turbo.xml:system/etc/permissions/privapp-permissions-turbo.xml

# Sysconfig
PRODUCT_COPY_FILES += \
    vendor/derp/prebuilt/common/etc/sysconfig/turbo.xml:system/etc/sysconfig/turbo.xml

# Omni Poor Man Themes
PRODUCT_PACKAGES += \
    DocumentsUITheme \
    DialerTheme \
    TelecommTheme

PRODUCT_PACKAGES += \
    NotificationsXtended \
    NotificationsBlack \
    NotificationsDark \
    NotificationsLight \
    NotificationsPrimary
PRODUCT_PACKAGES += \
    AccentSluttyPink \
    AccentPixel \
    AccentGoldenShower \
    AccentDeepOrange \
    AccentMisticBrown \
    AccentOmni \
    AccentWhite \
    AccentTeal \
    AccentFromHell \
    AccentBlueMonday \
    AccentSmokingGreen \
    AccentDeadRed \
    AccentRottenOrange \
    AccentDeepPurple \
    AccentBlackMagic \
    AccentCandyRed \
    AccentExtendedGreen \
    AccentJadeGreen \
    AccentPaleBlue \
    AccentPaleRed \
    AccentObfusBleu \
    AccentNotImpPurple \
    AccentHolillusion \
    AccentMoveMint \
    AccentFootprintPurple \
    AccentBubblegumPink \
    AccentFrenchBleu \
    AccentManiaAmber \
    AccentSeasideMint \
    AccentDreamyPurple \
    AccentSpookedPurple \
    AccentHeirloomBleu \
    AccentTruFilPink \
    AccentWarmthOrange \
    AccentColdBleu \
    AccentDiffDayGreen \
    AccentDuskPurple \
    AccentBurningRed \
    AccentHazedPink \
    AccentColdYellow \
    AccentNewHouseOrange \
    AccentIllusionsPurple

PRODUCT_PACKAGES += \
    PrimaryAlmostBlack \
    PrimaryBlack \
    PrimaryXtended \
    PrimaryXtendedClear \
    PrimaryEyeSoother \
    PrimaryOmni \
    PrimaryWhite \
    PrimaryColdWhite \
    PrimaryWarmWhite \
    PrimaryDarkBlue

#font stuff
PRODUCT_COPY_FILES += \
    vendor/derp/prebuilt/fonts/gobold/Gobold.ttf:system/fonts/Gobold.ttf \
    vendor/derp/prebuilt/fonts/gobold/Gobold-Italic.ttf:system/fonts/Gobold-Italic.ttf \
    vendor/derp/prebuilt/fonts/gobold/GoboldBold.ttf:system/fonts/GoboldBold.ttf \
    vendor/derp/prebuilt/fonts/gobold/GoboldBold-Italic.ttf:system/fonts/GoboldBold-Italic.ttf \
    vendor/derp/prebuilt/fonts/gobold/GoboldThinLight.ttf:system/fonts/GoboldThinLight.ttf \
    vendor/derp/prebuilt/fonts/gobold/GoboldThinLight-Italic.ttf:system/fonts/GoboldThinLight-Italic.ttf \
    vendor/derp/prebuilt/fonts/gobold/GoboldThinLight-Italic.ttf:system/fonts/GoboldThinLight-Italic.ttf \
    vendor/derp/prebuilt/fonts/roadrage/road_rage.ttf:system/fonts/RoadRage-Regular.ttf \
    vendor/derp/prebuilt/fonts/snowstorm/snowstorm.ttf:system/fonts/Snowstorm-Regular.ttf \
    vendor/derp/prebuilt/fonts/vcrosd/vcr_osd_mono.ttf:system/fonts/ThemeableFont-Regular.ttf \
    vendor/derp/prebuilt/fonts/vcrosd/vcr_osd_mono.ttf:system/fonts/ThemeableFont-Regular.ttf \
    vendor/derp/prebuilt/fonts/Shamshung/Shamshung.ttf:system/fonts/Shamshung.ttf \
    vendor/derp/fonts/GoogleSans-Regular.ttf:system/fonts/GoogleSans-Regular.ttf \
    vendor/derp/fonts/GoogleSans-Medium.ttf:system/fonts/GoogleSans-Medium.ttf \
    vendor/derp/fonts/GoogleSans-MediumItalic.ttf:system/fonts/GoogleSans-MediumItalic.ttf \
    vendor/derp/fonts/GoogleSans-Italic.ttf:system/fonts/GoogleSans-Italic.ttf \
    vendor/derp/fonts/GoogleSans-Bold.ttf:system/fonts/GoogleSans-Bold.ttf \
    vendor/derp/fonts/GoogleSans-BoldItalic.ttf:system/fonts/GoogleSans-BoldItalic.ttf


