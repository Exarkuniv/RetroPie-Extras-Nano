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

rp_module_id="pingus"
rp_module_desc="Pingus - Open source Lemmings clone"
rp_module_licence="GPL3 https://raw.githubusercontent.com/Pingus/pingus/master/COPYING"
rp_module_section="prt"
rp_module_flags="!x86"

function install_bin_pingus() {
    aptInstall pingus pingus-data
	
	if isPlatform "odroid-n2"; then
	/home/aresuser/ARES-Setup/fixmali.sh
    elif isPlatform "rockpro64"; then
    /usr/lib/arm-linux-gnueabihf/install_mali.sh
	fi
}

function configure_pingus() {
    mkRomDir "ports"

    moveConfigDir "$home/.pingus" "$md_conf_root/$md_id"
	local binary="pingus"
	if ! isPlatform "rpi"; then
	 addPort "$md_id" "pingus" "Pingus" "$binary"
	else
    addPort "$md_id" "pingus" "Pingus" "pingus"
	fi
}
