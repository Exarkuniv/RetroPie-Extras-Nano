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

rp_module_id="openblok"
rp_module_desc="OpenBlok: A Block Dropping Game"
rp_module_licence="GPL3 https://raw.githubusercontent.com/mmatyas/openblok/master/LICENSE.md"
rp_module_section="prt"
rp_module_flags=""

function depends_openblok() {
    getDepends cmake libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev libsdl2-ttf-dev
	
	if isPlatform "odroid-n2"; then
	/home/aresuser/ARES-Setup/fixmali.sh
    elif isPlatform "rockpro64"; then
    /usr/lib/arm-linux-gnueabihf/install_mali.sh
	fi
	
}

function sources_openblok() {
    gitPullOrClone "$md_build" https://github.com/mmatyas/openblok.git
}

function build_openblok() {
    cmake -DCMAKE_BUILD_TYPE=Release -DINSTALL_PORTABLE=ON -DCMAKE_INSTALL_PREFIX="$md_inst" -DENABLE_MP3=OFF
    make
    md_ret_require="$md_build/src/openblok"
}

function install_openblok() {
    make install/strip
}

function configure_openblok() {
    moveConfigDir "$home/.local/share/openblok" "$md_conf_root/openblok"
    addPort "$md_id" "openblok" "OpenBlok" "$md_inst/openblok"
}
