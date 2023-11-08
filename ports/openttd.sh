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

rp_module_id="openttd"
rp_module_desc="Open Source Simulator Based On Transport Tycoon Deluxe"
rp_module_licence="GPL2 https://git.openttd.org/?p=trunk.git;a=blob_plain;f=COPYING;hb=HEAD"
rp_module_section="prt"
rp_module_flags="dispmanx"

function _update_hook_openttd() {
    # to show as installed in retropie-setup 4.x
    hasPackage openttd && mkdir -p "$md_inst"
}

function install_bin_openttd() {
    aptInstall openttd
	
	if isPlatform "odroid-n2"; then
	/home/aresuser/ARES-Setup/fixmali.sh
    elif isPlatform "rockpro64"; then
    /usr/lib/arm-linux-gnueabihf/install_mali.sh
	fi
}

function remove_openttd() {
    aptRemove openttd
	
	if isPlatform "odroid-n2"; then
	/home/aresuser/ARES-Setup/fixmali.sh
    elif isPlatform "rockpro64"; then
    /usr/lib/arm-linux-gnueabihf/install_mali.sh
	fi
}

function configure_openttd() {
    if isPlatform "odroid-n2"; then
	addPort "$md_id" "openttd" "OpenTTD" "XINIT:openttd"
	else addPort "$md_id" "openttd" "OpenTTD" "openttd"
	fi
	
    [[ "$md_mode" == "remove" ]] && return

    setDispmanx "$md_id" 1

    local dir
    for dir in .config .local/share; do
        moveConfigDir "$home/$dir/openttd" "$md_conf_root/openttd"
    done

    moveConfigDir "$home/.local/openttd" "$md_conf_root/openttd"
}
