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

rp_module_id="devilutionx"
rp_module_desc="devilutionx - Diablo Engine"
rp_module_licence="https://raw.githubusercontent.com/diasurgical/devilutionX/master/LICENSE"
rp_module_help="Copy your original diabdat.mpq file from Diablo to $romdir/ports/devilutionx."
rp_module_repo="wget https://github.com/diasurgical/devilutionX/releases/download/1.5.0/devilutionx-linux-armhf.zip"
rp_module_section="exp"
rp_module_flags="!x86 !mali"

function depends_devilutionx() {
   getDepends cmake g++ libsdl2-mixer-dev libsdl2-ttf-dev libsodium-dev libfmt-dev
}

function sources_devilutionx() {
    wget "https://github.com/diasurgical/devilutionX/releases/download/1.5.0/devilutionx-linux-aarch64.tar.xz" 
           tar -xvJf $md_build/devilutionx-linux-aarch64.tar.xz
}

function install_devilutionx() {
    dpkg -i ./devilutionx.deb
    md_ret_files=(
          	/devilutionx
		/devilutionx.mpq
		/README.txt 
		/LICENSE.CC-BY.txt
		/LICENSE.OFL.txt)
}

function game_data_diablo() {
    if [[ ! -f "$romdir/ports/devilutionx/diablo.exe" ]]; then
        downloadAndExtract "https://github.com/Exarkuniv/game-data/raw/main/diablo.zip" "$romdir/ports/devilutionx"
    mv "$romdir/ports/devilutionx/diablo"* "$romdir/ports/devilutionx/"
    chown -R $user:$user "$romdir/ports/devilutionx"
    fi
}

function configure_devilutionx() {
    mkRomDir "ports"
    mkRomDir "ports/devilutionx"
    cp -r "$md_inst/devilutionx.mpq" "$romdir/ports/$md_id"
    addPort "$md_id" "devilutionx" "devilutionx - Diablo Engine" "$md_inst/devilutionx --data-dir $romdir/ports/devilutionx --save-dir $md_conf_root/devilutionx"
	
    [[ "$md_mode" == "install" ]] && game_data_diablo
}