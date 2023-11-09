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

rp_module_id="lbreakout2"
rp_module_desc="lbreakout2 - Open Source Breakout game"
rp_module_licence="GPL2 https://sourceforge.net/p/lgames/code/HEAD/tree/trunk/lbreakout2/COPYING"
rp_module_section="prt"
rp_module_flags="!odroid-n2"

function install_bin_lbreakout2() {
      aptInstall lbreakout2
	  
    if isPlatform "odroid-n2"; then
	/home/aresuser/ARES-Setup/fixmali.sh
    elif isPlatform "rockpro64"; then
    /usr/lib/arm-linux-gnueabihf/install_mali.sh
	fi
	
}

function configure_lbreakout2() {
    mkRomDir "ports"
    moveConfigFile "$home/.lgames/lbreakout2.conf" "$md_conf_root/lbreakout2/lbreakout2.conf"
	local binary="XINIT:/usr/games/lbreakout2"
	if ! isPlatform "rpi"; then
    addPort "$md_id" "lbreakout2" "lbreakout2 - Open Source Breakout game" "$binary"
	else addPort "$md_id" "lbreakout2" "lbreakout2 - Open Source Breakout game" "/usr/games/lbreakout2"
	fi
}
