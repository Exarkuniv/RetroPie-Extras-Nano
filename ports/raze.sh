#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="raze-system"
rp_module_desc="Raze System - Build engine port"
rp_module_licence="GPL3 https://raw.githubusercontent.com/drfrag666/gzdoom/master/LICENSE"
rp_module_repo="git https://github.com/Exarkuniv/gzdoom-Pi.git master"
rp_module_section="prt"
rp_module_flags=""

function depends_raze-system() {
     getDepends g++ make cmake libsdl2-dev git zlib1g-dev libbz2-dev libjpeg-dev libfluidsynth-dev libgme-dev libopenal-dev libmpg123-dev libsndfile1-dev libgtk-3-dev timidity nasm libgl1-mesa-dev tar libsdl1.2-dev libglew-dev libvpx-dev libvulkan-dev

}

function sources_raze-system() {
    gitPullOrClone "$md_build" https://github.com/ZDoom/Raze.git master 85b6c19
}

function build_raze-system() {
       if [ ! -f "/usr/lib/arm-linux-gnueabihf/libzmusic.so" ]; then
	gitPullOrClone "$md_build/zmusic" https://github.com/coelckers/ZMusic.git
    cd $md_build/zmusic
    mkdir build
    cd build
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr 
    make
    make install
    rm -r $md_build/zmusic

    fi

    mkdir $md_build/build
    cd $md_build/build
    Tag="$(git tag -l | grep -v 9999 | grep -E '^g[0-9]+([.][0-9]+)*$' |
    sed 's/^g//' | sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4 |
    tail -n 1 | sed 's/^/g/')" &&
    git checkout --detach refs/tags/$Tag
    c="$(lscpu -p | grep -v '#' | sort -u -t , -k 2,4 | wc -l)" ; [ "$c" -eq 0 ] && c=1
    rm -f output_sdl/liboutput_sdl.so &&
    if [ -d ../fmodapi44464linux ]; then
    f="-DFMOD_LIBRARY=../fmodapi44464linux/api/lib/libfmodex${a}-4.44.64.so \
    -DFMOD_INCLUDE_DIR=../fmodapi44464linux/api/inc"; else
    f='-UFMOD_LIBRARY -UFMOD_INCLUDE_DIR'; fi &&
    cmake .. -DCMAKE_BUILD_TYPE=Release $f &&
    make -j4

}

function install_raze-system() {
    md_ret_files=(
        'build/raze'
        'build/rase.pk3'
	'build/soundfonts'
        'README.md'
    )
}

function configure_gzdoom-system() {
    mkRomDir "build"
    mkUserDir "$home/.config"
    setConfigRoot ""
    addEmulator 1 "raze" "doom" "$md_inst/raze"
    addSystem "doom" "DOOM" ".pk3 .wad"

    moveConfigDir "$home/.config/raze" "$md_conf_root/raze"

    [[ "$md_mode" == "remove" ]] && return

}