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

rp_module_id="micropolis"
rp_module_desc="Micropolis - Open Source City Building Game"
rp_module_licence="GPL https://raw.githubusercontent.com/SimHacker/micropolis/wiki/License.md"
rp_module_section="prt"
rp_module_flags="!odroid-n2"

function depends_micropolis() {
    ! isPlatform "x11" getDepends xorg matchbox
}

function install_bin_micropolis() {
    aptInstall micropolis
	
	if isPlatform "odroid-n2"; then
	/home/aresuser/ARES-Setup/fixmali.sh
    elif isPlatform "rockpro64"; then
    /usr/lib/arm-linux-gnueabihf/install_mali.sh
	fi
	
}

function remove_micropolis() {
    aptRemove micropolis*
	
	if isPlatform "odroid-n2"; then
	/home/aresuser/ARES-Setup/fixmali.sh
    elif isPlatform "rockpro64"; then
    /usr/lib/arm-linux-gnueabihf/install_mali.sh
	fi
}

function configure_micropolis() {
    local binary="/usr/games/micropolis"
    ! isPlatform "x11" && binary="XINIT:$md_inst/micropolis.sh"

    addPort "$md_id" "micropolis" "Micropolis" "$binary"


    mkdir -p "$md_inst"
    cat >"$md_inst/micropolis.sh" << _EOF_
#!/bin/bash
xset -dpms s off s noblank
matchbox-window-manager &
/usr/games/micropolis
_EOF_
    chmod +x "$md_inst/micropolis.sh"
}
