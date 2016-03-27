#!/bin/bash
# Copyright (c) 2015 Mattia "AntaresOne" D'Alleva
# SBSS - Simple Build/Sync Script

CPU=$[$(nproc)+1]
ID=$(cat build/core/build_id.mk | grep "BUILD_ID=.*" | cut -d'=' -f2-)
PLATFORM=$(cat build/core/version_defaults.mk | grep "PLATFORM_VERSION :=*" | cut -d'=' -f2-)

BUILD() {
    echo
    echo "Building..."
    . build/envsetup.sh
    ./vendor/jdc/get-prebuilts
    brunch cm_ferrari-userdebug
    return
}
SYNC() {
    echo
    echo "Syncing repositories..."
    repo sync
    echo
    echo "Source code synced. Starting to build..."
    BUILD
}
READY() {
    if [ "$OPTION" = "1" ]; then
        LOG=NULL
        BUILD
    elif [ "$OPTION" = "2" ]; then
        BUILD
    else
        SYNC
fi
}
PROCEED() {
    # Missing space in $PLATFORM is not a typo
    echo "Android version:$PLATFORM"
    echo "Build ID: $ID"
    echo
    echo "What would you like to do?"
    echo
    echo "1 - Build"
    echo "2 - Build and save a log"
    echo "3 - Sync and build"
    echo
    echo "Type 1, 2 or 3 and press enter:"
    read OPTION
    READY
}
echo "$(tput setaf 4)"
echo "*****************************************************************"
echo "*                                                               *"
echo "*   Welcome to the $(tput setaf 7)Simple Build & Sync Script$(tput sgr0) $(tput setaf 4)for AOSP by JDCTeam *"
echo "*                                                               *"
echo "*****************************************************************"
echo "$(tput sgr0)"
PROCEED
