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

rp_module_id="xrick"
rp_module_desc="xrick - Port of Rick Dangerous"
																		   
rp_module_licence="GPL https://raw.githubusercontent.com/HerbFargus/xrick/master/README"
rp_module_section="prt"
rp_module_flags="!odroid-n2"

function depends_xrick() {
    getDepends libsdl1.2-dev libsdl-mixer1.2-dev libsdl-image1.2-dev zlib1g
	
	if isPlatform "odroid-n2"; then
	/home/aresuser/ARES-Setup/fixmali.sh
    elif isPlatform "rockpro64"; then
    /usr/lib/arm-linux-gnueabihf/install_mali.sh
	fi
}

function sources_xrick() {
    gitPullOrClone "$md_build" https://github.com/RetroPie/xrick.git
}

function build_xrick() {
    make clean
    make
    md_ret_require="$md_build/xrick"
}

function install_xrick() {
    md_ret_files=(
        'README'
        'xrick'
    )
}

function configure_xrick() {
    if  isPlatform "odroid-xu"; then
	addPort "$md_id" "xrick" "XRick" "XINIT:$md_inst/xrick.sh -fullscreen" "$romdir/ports/xrick/data.zip"
	else addPort "$md_id" "xrick" "XRick" "$md_inst/xrick.sh -fullscreen" "$romdir/ports/xrick/data.zip"
	fi

    [[ "$md_mode" == "remove" ]] && return

    isPlatform "kms" && setDispmanx "$md_id" 1

    ln -sf "$romdir/ports/xrick/data.zip" "$md_inst/data.zip"

    local file="$md_inst/xrick.sh"
    cat >"$file" << _EOF_
#!/bin/bash
pushd "$md_inst"
./xrick "\$@"
popd
_EOF_
    chmod +x "$file"
}
