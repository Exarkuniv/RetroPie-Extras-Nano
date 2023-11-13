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

rp_module_id="lr-yabause"
rp_module_desc="Sega Saturn emu - Yabause (optimised) port for libretro"
rp_module_help="ROM Extensions: .iso .bin .zip\n\nCopy your Sega Saturn roms to $romdir/saturn\n\nCopy the required BIOS file saturn_bios.bin to $biosdir"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/yabause/master/yabause/COPYING"
rp_module_section="lr"
rp_module_flags="!all"

function sources_lr-yabause() {
    gitPullOrClone "$md_build" https://github.com/libretro/yabause.git
}

function build_lr-yabause() {
    cd yabause/src/libretro
    make clean
    if isPlatform "neon"; then
        make platform=armvneonhardfloat
    else
        make
    fi
    md_ret_require="$md_build/yabause/src/libretro/yabause_libretro.so"
}

function install_lr-yabause() {
    md_ret_files=(
        'yabause/src/libretro/yabause_libretro.so'
        'yabause/COPYING'
        'yabause/ChangeLog'
        'yabause/AUTHORS'
        'yabause/README'
    )
}

function configure_lr-yabause() {
    mkRomDir "saturn"
    ensureSystemretroconfig "saturn"

    addEmulator 0 "$md_id" "saturn" "$md_inst/yabause_libretro.so"
    addSystem "saturn"
	
}
