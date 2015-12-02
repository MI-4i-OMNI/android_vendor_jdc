## JDC G4 configuration

# Changelog
PRODUCT_COPY_FILES += \
    vendor/jdc/Changelog.md:system/etc/Changelog.md

# Custom format script
PRODUCT_COPY_FILES += \
    vendor/jdc/prebuilt/common/bin/format.sh:install/bin/format.sh

# Custom init script
PRODUCT_COPY_FILES += \
    vendor/jdc/prebuilt/common/etc/init.jdcteam.rc:root/init.jdcteam.rc

# eMMC trim
PRODUCT_COPY_FILES += \
    vendor/jdc/prebuilt/common/bin/emmc_trim:system/bin/emmc_trim

# LEDify
PRODUCT_COPY_FILES += \
    vendor/jdc/prebuilt/common/bin/ledify:system/bin/ledify

# Overlays
PRODUCT_PACKAGE_OVERLAYS += vendor/jdc/overlay/common

# Packages
PRODUCT_PACKAGES += \
    SunBeam

# Prebuilt Toolbox
PRODUCT_COPY_FILES += \
    vendor/jdc/proprietary/Toolbox.apk:system/priv-app/Toolbox/Toolbox.apk
