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

rp_module_id="minecraft"
rp_module_desc="Minecraft - Pi Edition"
rp_module_licence="PROP"
rp_module_section="prt"
rp_module_flags="!all videocore"

function depends_minecraft() {
     getDepends xorg matchbox-window-manager
	
}

function install_bin_minecraft() {
    [[ -f "$md_inst/minecraft-pi" ]] && rm -rf "$md_inst/"*
    aptInstall minecraft-pi
	
	if isPlatform "odroid-n2"; then
	/home/aresuser/ARES-Setup/fixmali.sh
    elif isPlatform "rockpro64"; then
    /usr/lib/arm-linux-gnueabihf/install_mali.sh
	fi
}

function remove_minecraft() {
    aptRemove minecraft-pi
	
	if isPlatform "odroid-n2"; then
	/home/aresuser/ARES-Setup/fixmali.sh
    elif isPlatform "rockpro64"; then
    /usr/lib/arm-linux-gnueabihf/install_mali.sh
	fi
}

function configure_minecraft() {
    addPort "$md_id" "minecraft" "Minecraft" "XINIT:$md_inst/Minecraft.sh"

    cat >"$md_inst/Minecraft.sh" << _EOF_
#!/bin/bash
xset -dpms s off s noblank
matchbox-window-manager &
/usr/bin/minecraft-pi
_EOF_
    chmod +x "$md_inst/Minecraft.sh"
}
