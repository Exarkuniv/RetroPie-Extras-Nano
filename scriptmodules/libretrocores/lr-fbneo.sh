#!/usr/bin/env bash

# This file is part of ARES by The RetroArena
#
# ARES is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/Retro-Arena/RetroArena-Setup/master/LICENSE.md
#
# Core script functionality is based upon The RetroPie Project https://retropie.org.uk Script Modules
#

rp_module_id="lr-fbneo"
rp_module_desc="Arcade emu - FinalBurn Neo v0.2.97.44 port for libretro"
rp_module_help="ROM Extension: .zip\n\nCopy your roms to\n$romdir/fbneo or\n$romdir/neogeo or\n$romdir/arcade\n\nFor NeoGeo games the neogeo.zip BIOS is required and must be placed in the same directory as your roms."
rp_module_licence="NONCOM https://raw.githubusercontent.com/libretro/FBNeo/master/src/license.txt"
rp_module_section="lr"

function _update_hook_lr-fbneo() {
    # move from old location and update emulators.cfg
    renameModule "lr-fba-next" "lr-fbalpha"
    renameModule "lr-fbalpha" "lr-fbneo"
}

function sources_lr-fbneo() {
    gitPullOrClone "$md_build" https://github.com/libretro/FBNeo.git
}

function build_lr-fbneo() {
    cd src/burner/libretro
    local params=()
    isPlatform "arm" && params+=(USE_CYCLONE=1)
    isPlatform "neon" && params+=(HAVE_NEON=1)
    isPlatform "x86" && isPlatform "64bit" && params+=(USE_X64_DRC=1)
    make clean
    make "${params[@]}"
    md_ret_require="$md_build/src/burner/libretro/fbneo_libretro.so"
}

function install_lr-fbneo() {
    md_ret_files=(
        'fba.chm'
        'src/burner/libretro/fbneo_libretro.so'
        'gamelist.txt'
        'whatsnew.html'
        'metadata'
        'dats'
    )
}

function configure_lr-fbneo() {
    # Create samples directory
    mkUserDir "$biosdir/fbneo"
    mkUserDir "$biosdir/fbneo/samples"
    
    # copy hiscore.dat
    cp "$md_inst/metadata/hiscore.dat" "$biosdir/fbneo/"
    chown $user:$user "$biosdir/fbneo/hiscore.dat"

    # Set core options
    setRetroArchCoreOption "fbneo-diagnostic-input" "Hold Start"

    local def=1
    isPlatform "armv6" && def=0
    cp "$md_inst/fbneo_libretro.so" "/home/aresuser/.config/retroarch/cores"
}