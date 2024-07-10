#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="gzdoom-system"
rp_module_desc="GZDoom System - Yes the real GZDoom on Pi, running in GLES"
rp_module_licence="GPL3 https://raw.githubusercontent.com/drfrag666/gzdoom/master/LICENSE"
rp_module_repo="git https://github.com/Exarkuniv/gzdoom-Pi.git master"
rp_module_section="prt"
rp_module_flags=""

function _get_version_gzdoom-system() {
    # default GZDoom version
    local gzdoom_version="g4.12.2"

    # 32 bit is no longer supported since g4.8.1
    isPlatform "32bit" && gzdoom_version="g4.8.0"
    echo $gzdoom_version
}

function depends_gzdoom-system() {
    local depends=(
        cmake libfluidsynth-dev libsdl2-dev libmpg123-dev libsndfile1-dev libbz2-dev
        libopenal-dev libjpeg-dev libgl1-mesa-dev libasound2-dev libmpg123-dev libsndfile1-dev
        libvpx-dev libwebp-dev pkg-config
        zlib1g-dev)
    getDepends "${depends[@]}"
}

function sources_gzdoom-system() {
    gitPullOrClone
    # add 'ZMusic' repo
    cd "$md_build"
    gitPullOrClone zmusic https://github.com/ZDoom/ZMusic
    # workaround for Ubuntu 20.04 older vpx/wepm dev libraries
    sed -i 's/IMPORTED_TARGET libw/IMPORTED_TARGET GLOBAL libw/' CMakeLists.txt
    # lzma assumes hardware crc support on arm which breaks when building on armv7
    isPlatform "armv7" && applyPatch "$md_data/lzma_armv7_crc.diff"
}

function build_gzdoom-system() {
    mkdir -p release

    # build 'ZMusic' first
    pushd zmusic
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$md_build/release/zmusic" .
    make
    make install
    popd

    cd release
    local params=(-DCMAKE_INSTALL_PREFIX="$md_inst" -DPK3_QUIET_ZIPDIR=ON -DCMAKE_BUILD_TYPE=Release -DDYN_OPENAL=ON -DCMAKE_PREFIX_PATH="$md_build/release/zmusic")
    ! hasFlag "vulkan" && params+=(-DHAVE_VULKAN=OFF)

    cmake "${params[@]}" ..
    make
    md_ret_require="$md_build/release/$md_id"
}

function install_gzdoom-system() {
    md_ret_files=(
        'release/brightmaps.pk3'
        'release/gzdoom'
        'release/gzdoom.pk3'
        'release/lights.pk3'
        'release/game_support.pk3'
        'release/game_widescreen_gfx.pk3'
        'release/soundfonts'
        "release/zmusic/lib/libzmusic.so.1"
        "release/zmusic/lib/libzmusic.so.1.1.13"
        'README.md'
    )
}

function add_games_gzdoom-system() {
    local params=("-fullscreen")
    local launcher_prefix="DOOMWADDIR=$romdir/ports/doom"

    # FluidSynth is too memory/CPU intensive, use OPL emulation for MIDI
    if isPlatform "arm"; then
        params+=("+set snd_mididevice -3")
    fi
    # when using the 32bit version on GLES platforms, pre-set the renderer
    if isPlatform "32bit" && hasFlag "gles"; then
        params+=("+set vid_preferbackend 2")
    fi

    if isPlatform "kms"; then
        params+=("-width %XRES%" "-height %YRES%")
    fi

    _add_games_lr-prboom "$launcher_prefix $md_inst/$md_id -iwad %ROM% ${params[*]}"
}

function configure_gzdoom-system() {
    mkUserDir "$home/.config"
    setConfigRoot ""
    addEmulator 1 "gzdoom" "doom" "$md_inst/gzdoom -iwad %ROM%"
    addSystem "doom" "DOOM" ".pk3 .wad"

    moveConfigDir "$home/.config/gzdoom" "$md_conf_root/gzdoom"

    [[ "$md_mode" == "install" ]] && add_games_gzdoom-system
    [[ "$md_mode" == "remove" ]] && return

}
