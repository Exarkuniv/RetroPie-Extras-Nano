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

rp_module_id="heboris"
rp_module_desc="HeborisC7EX - Tetris The Grand Master Clone"
rp_module_help="To get mp3 audio working, you will need to change the music type from MIDI to MP3 in the Heboris options menu."
rp_module_section="prt"
rp_module_flags="!odroid-n2"

function depends_heboris() {
    getDepends libsdl1.2-dev libsdl-mixer1.2-dev libsdl-image1.2-dev libgl1-mesa-dev
	
	if isPlatform "odroid-n2"; then
	/home/aresuser/ARES-Setup/fixmali.sh
    elif isPlatform "rockpro64"; then
    /usr/lib/arm-linux-gnueabihf/install_mali.sh
	fi
	
}

function sources_heboris() {
    gitPullOrClone "$md_build" https://github.com/zerojay/HeborisC7EX.git
}

function build_heboris() {
    make
    md_ret_require="$md_build/heboris"
}

function install_heboris() {
    md_ret_files=(
          'heboris'
          'res'
          'replay'
          'config'
          'heboris.ini'
          'heboris.txt'
    )
}

function configure_heboris() {
    chown $user:$user "$md_inst/heboris"
	if  isPlatform "odroid-xu"; then
	addPort "$md_id" "heboris" "HeborisC7EX - Tetris The Grand Master Clone" "pushd $md_inst; xinit ./heboris; popd"
	else addPort "$md_id" "heboris" "HeborisC7EX - Tetris The Grand Master Clone" "pushd $md_inst; ./heboris; popd"
	fi
}
