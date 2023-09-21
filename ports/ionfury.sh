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

rp_module_id="ionfury"
rp_module_desc="Ion Fury - commercial FPS game based on eduke32 source port"
rp_module_licence="GPL2 http://svn.eduke32.com/eduke32/package/common/gpl-2.0.txt"
rp_module_section="prt"
rp_module_flags=""

function depends_ionfury() {
    depends_eduke32
	
	if isPlatform "odroid-n2"; then
	/home/aresuser/ARES-Setup/fixmali.sh
    elif isPlatform "rockpro64"; then
    /usr/lib/arm-linux-gnueabihf/install_mali.sh
	fi
}

function sources_ionfury() {
    # patches are also shared with eduke32, so avoid duplication
    md_data="$(dirname $md_data)/eduke32" sources_eduke32
}

function build_ionfury() {
    build_eduke32
}

function install_ionfury() {
    install_eduke32
}

function configure_ionfury() {
    configure_eduke32
}
