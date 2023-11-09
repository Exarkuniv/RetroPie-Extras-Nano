#!/usr/bin/env bash

# This file is part of RetroPie-Extra, a supplement to RetroPie.
# For more information, please visit:
#
# https://github.com/RetroPie/RetroPie-Setup
# https://github.com/Exarkuniv/RetroPie-Extra
#
# See the LICENSE file distributed with this source and at
# https://raw.githubusercontent.com/Exarkuniv/RetroPie-Extra/master/LICENSE
#

rp_module_id="tfe"
rp_module_desc="The Force Engine (TFE)"
rp_module_licence="GPL https://raw.githubusercontent.com/Xenoveritas/abuse/master/COPYING"
rp_module_section="prt"
rp_module_flags=""

function depends_tfe() {
    getDepends cmake libdevil-dev librtaudio-dev librtmidi-dev libglew-dev libsdl2-2.0-0 libsdl2-dev libsdl2-image-dev
	
    gitPullOrClone "$md_build/sdl" https://github.com/libsdl-org/SDL.git main

	cd $md_build/sdl
	cmake -S . -B build
	cmake --build build
	cmake --install build

	rm -r $md_build/sdl
}

function sources_tfe() {
      gitPullOrClone "$md_build" https://github.com/luciusDXL/TheForceEngine.git "master"

}

function build_tfe() {
    mkdir -p $md_inst
    mkdir tfe-build
    cd tfe-build
    cmake -S /$md_build/ -DDISABLE_SYSMIDI=ON
    make
    md_ret_require=($md_build/tfe-build/theforceengine)
}

function install_tfe() {
    cd tfe-build
    make install
}

function configure_tfe() {
    mkRomDir "ports/tfe"
    addPort "$md_id" "tfe" "The Force Engine (TFE)" "/usr/local/bin/theforceengine"
}