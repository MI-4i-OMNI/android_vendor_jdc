#! /bin/bash

#      _____  __________      
#  __ / / _ \/ ___/_  _/__ ___ ___ _
# / // / // / /__  / // -_) _ `/  ' \ 
# \___/____/\___/ /_/ \__/\_,_/_/_/_/ 
#
# Copyright 2015 Matt "Kryten2k35" Booth
# Copyright 2015 JDCTeam
# Contact: kryten2k35@ultimarom.com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


TEAM_NAME="JDCTeam"
TARGET=ferrari
VARIANT=userdebug
CM_VER=13
FILENAME=OptimizedCM-"$CM_VER"-"$(date +%Y%m%d)"-"$TARGET"
PREBUILTS=vendor/jdc/proprietary

buildROM () { 
    if [ ! -d $PREBUILTS ]; then
	# Download Toolbox
	./vendor/jdc/get-prebuilts
    fi
    ## Start the build
    echo "Building";
    CPU_NUM=$[$(nproc)+1]
    time schedtool -B -n 1 -e ionice -n 1 make otapackage -j"$CPU_NUM" "$@"
}

repoSync(){
    ## Sync the repo
    echo "Syncing repositories"
    reposync

    if [ "$1" == "2" ]; then 
        echo "Upstream merging"
        ## local manifest location
        ROOMSER=.repo/local_manifests/local_manifest.xml
        # Lines to loop over
        CHECK=$(cat ${ROOMSER} | grep -e "<remove-project" | cut -d= -f3 | sed 's/revision//1' | sed 's/\"//g' | sed 's|/>||g')
        
        ## Upstream merging for forked repos
        while read -r line; do
            echo "Upstream merging for $line"
            cd  "$line"
            UPSTREAM=$(sed -n '1p' UPSTREAM)
            BRANCH=$(sed -n '2p' UPSTREAM)
            ORIGIN=$(sed -n '3p' UPSTREAM)
            PUSH_BRANCH=
            git pull https://www.github.com/"$UPSTREAM" "$BRANCH"
            git push "$ORIGIN" HEAD:opt-"$BRANCH"
            croot
        done <<< "$CHECK"
    fi
}

makeclean(){
    ## Fully wipe, including compiler cache
    echo "Cleaning ccache"
    ccache -C
    echo "Cleaning out folder"
    make clean
    ## Clean Alucard cache, including its compiler cache
    if [ "$aluclean" == "true" ]; then
	cd "$ALU_DIR"
	./$ALU_CLEAN
	croot
    fi
}

echo " "
echo " "
echo -e "\e[1;91mWelcome to the $TEAM_NAME build script"
echo -e "\e[0m "
echo "Setting up build environment..."
. build/envsetup.sh > /dev/null
echo "Setting build target $TARGET""..."
lunch cm_"$TARGET"-"$VARIANT" > /dev/null
echo " "
echo " "
echo -e "\e[1;91mPlease make your selections carefully"
echo -e "\e[0m "
echo " "
echo "Do you wish to build, sync or clean?"
select build in "Build ROM" "Sync" "Sync and upstream merge" "Build Alucard Kernel" "Repack ROM" "Make Clean" "Make Clean (inc ccache)" "Make Clean All (inc ccache+Alucard)" "Push and flash" "Build ROM, Kernel and Repackage" "Exit"; do
    case $build in
        "Build ROM" ) buildROM; anythingElse; break;;
        "Sync" ) repoSync 1; anythingElse; break;;
        "Sync and upstream merge" ) repoSync 2; anythingElse; break;;
        "Repack ROM" ) repackRom; anythingElse; break;;
        "Make Clean" ) make clean; anythingElse; break;;
        "Make Clean (inc ccache)" ) makeclean; anythingElse; break;;
	"Exit" ) exit 0; break;;
    esac
done

exit 0
