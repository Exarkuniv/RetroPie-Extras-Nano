#!/usr/bin/env bash

# This file is part of RetroPie-Extra, a supplement to RetroPie.
# For more information, please visit:
#
# https://github.com/RetroPie/RetroPie-Setup
# https://github.com/Exarkuniv/RetroPie-Extra
#
# See the LICENSE file distributed with this source and at
# https://raw.githubusercontent.com/Exarkuniv/RetroPie-Extra/master/LICENSE
# last build that works 618c5bd 2-20-23

rp_module_id="openrct2"
rp_module_desc="OpenRCT2 - RollerCoaster Tycoon 2 port"
rp_module_licence="GNU https://github.com/OpenRCT2/OpenRCT2/blob/develop/licence.txt"
rp_module_help="Copy g1.dat, The 772 default RCT2 objects. /n/nEasy to identify by sorting on date, /n/nsince all 772 have a similar timestamp (usually from 2002 or 2003/n/n Required: If you use the OpenRCT2 title sequence, no scenarios are needed./n/n Six Flags Magic Mountain.SC6/n/n is needed for the RCT2 title sequence."
rp_module_repo="git https://github.com/OpenRCT2/OpenRCT2.git develop 618c5bd"
rp_module_section="exp"
rp_module_flags="noinstclean"


function depends_openrct2() {
   getDepends libsdl2-dev libicu-dev gcc pkg-config libjansson-dev libspeex-dev libspeexdsp-dev libcurl4-openssl-dev libcrypto++-dev libfontconfig1-dev libfreetype6-dev libpng-dev libssl-dev libzip-dev build-essential make libbenchmark-dev libbenchmark1 libbenchmark-ocaml-dev libvorbis-dev libflac++-dev ccache nlohmann-json3-dev

}


function sources_openrct2() {
    gitPullOrClone "$md_build" https://github.com/OpenRCT2/OpenRCT2.git develop 618c5bd
}

function build_openrct2() {
    mkdir $md_build/build
    cd $md_build/build
    cmake ../ -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS="-Ofast -DNDEBUG -mcpu=cortex-a72"
    make -j4
    make install

    md_ret_require=( 
	'openrct2'
      )
}

function game_data_openrct2() {
      if [[ ! -f "$home/.config/OpenRCT2/config.ini" ]]; then
        git clone "https://github.com/Exarkuniv/RCTconfig.git" "$home/.config/OpenRCT2/data"
       fi
    cp $home/.config/OpenRCT2/data/confignano.ini $home/.config/OpenRCT2/config.ini
    chown -R  $user:$user  "$home/.config/OpenRCT2"
    chmod +x "$home/.config/OpenRCT2/config.ini"
}

function install_openrct2() {
    md_ret_files=(
	'build'
	'data'
	'resources'
        )
}

function configure_openrct2() {
	cat >"$md_inst/rct.sh" << _EOF_

#!/bin/bash
cd "$md_inst/build"
./openrct2 
_EOF_

 chmod +x "$md_inst/rct.sh"

    addPort "$md_id" "openrct2" "Rollercoaster tycoon 2" "$md_inst/rct.sh"
    mkRomDir "ports/openrct2"
    mkRomDir "ports/openrct1"

   [[ "$md_mode" == "install" ]] && game_data_openrct2
   chown -R  $user:$user  "$home/.config/OpenRCT2"

}