TARGET_BOOT_ANIMATION_RES ?= undefined

ifeq ($(TARGET_BOOT_ANIMATION_RES),1280)
     PRODUCT_COPY_FILES += vendor/derp/prebuilt/media/Derp-1280.zip:system/media/bootanimation.zip
else ifeq ($(TARGET_BOOT_ANIMATION_RES),1920)
     PRODUCT_COPY_FILES += vendor/derp/prebuilt/media/Derp-1920.zip:system/media/bootanimation.zip
else ifeq ($(TARGET_BOOT_ANIMATION_RES),2160)
     PRODUCT_COPY_FILES += vendor/derp/prebuilt/media/Derp-2160.zip:system/media/bootanimation.zip
else ifeq ($(TARGET_BOOT_ANIMATION_RES),2560)
     PRODUCT_COPY_FILES += vendor/derp/prebuilt/media/Derp-2560.zip:system/media/bootanimation.zip
else ifeq ($(TARGET_BOOT_ANIMATION_RES),undefined)
     $(warning Target bootanimation res is undefined, using 720p bootanimation )
     PRODUCT_COPY_FILES += vendor/derp/prebuilt/media/Derp-1280.zip:system/media/bootanimation.zip
else
     $(warning Defined bootanimation res is wrong, using 720p bootanimation )
     PRODUCT_COPY_FILES += vendor/derp/prebuilt/media/Derp-1280.zip:system/media/bootanimation.zip
endif
