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

rp_module_id="freeciv"
rp_module_desc="freeciv - Open Source Civilization game"
rp_module_licence="GPL2 https://raw.githubusercontent.com/freeciv/freeciv/master/COPYING"
rp_module_section="prt"
rp_module_flags="!all"

function depends_freeciv() {
    # Using xorg/xinit fixes issue where game couldn't get past opening menu screen.
    getDepends xorg freeciv-sound-standard
}

function install_bin_freeciv() {
    
    aptInstall freeciv-client-sdl
	
	if isPlatform "odroid-n2"; then
	/home/aresuser/ARES-Setup/fixmali.sh
    elif isPlatform "rockpro64"; then
    /usr/lib/arm-linux-gnueabihf/install_mali.sh
	fi
}

function configure_freeciv() {
    mkRomDir "ports"
    moveConfigDir "$home/.freeciv" "$md_conf_root/freeciv"
    moveConfigFile "$home/.freeciv-client-rc-2.4" "$md_conf_root/freeciv"
	local binary="XINIT:/usr/games/freeciv-sdl2"
	if ! isPlatform "rpi"; then
    addPort "$md_id" "freeciv" "Freeciv" "$binary"
	else addPort "$md_id" "freeciv" "Freeciv" "/usr/games/freeciv-sdl2"
	fi
}
