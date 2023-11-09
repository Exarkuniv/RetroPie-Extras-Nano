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

rp_module_id="lgeneral"
rp_module_desc="lgeneral - Open Source strategy game"
rp_module_licence="GPL2 https://sourceforge.net/p/lgames/code/HEAD/tree/trunk/lgeneral/COPYING"
rp_module_section="prt"
rp_module_flags="!odroid-n2"

function install_bin_lgeneral() {
     aptInstall lgeneral
	 
	 if isPlatform "odroid-n2"; then
	/home/aresuser/ARES-Setup/fixmali.sh
    elif isPlatform "rockpro64"; then
    /usr/lib/arm-linux-gnueabihf/install_mali.sh
	fi
}

function configure_lgeneral() {
    mkRomDir "ports"
    moveConfigFile "$home/.lgames/lgeneral.conf" "$md_conf_root/lgeneral/lgeneral.conf"
	local binary="XINIT:/usr/games/lgeneral"
    addPort "$md_id" "lgeneral" "lgeneral - Open Source strategy game" "$binary"
}
