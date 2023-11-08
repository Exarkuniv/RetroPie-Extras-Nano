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

rp_module_id="srb2"
rp_module_desc="Sonic Robo Blast 2 - 3D Sonic the Hedgehog fan-game built using a modified version of the Doom Legacy source port of Doom"
rp_module_licence="GPL2 https://raw.githubusercontent.com/STJr/SRB2/master/LICENSE"
rp_module_section="prt"

function depends_srb2() {
    getDepends libpng-dev zlib1g-dev libsdl2-dev libsdl2-mixer-dev libgme-dev libopenmpt-dev libcurl4-openssl-dev
}

function sources_srb2() {
    gitPullOrClone "$md_build" https://git.do.srb2.org/STJr/SRB2.git "master" a4a3b5b
    downloadAndExtract "https://github.com/Exarkuniv/game-data/blob/main/srb2-assets-1.tar.gz" "$md_build"
    downloadAndExtract "https://github.com/Exarkuniv/game-data/blob/main/srb2-assets-2.tar.gz" "$md_build"
}

function build_srb2() {
    make
    md_ret_require="$md_build/bin/lsdl2srb2"
}

function install_srb2() {
    # copy and dereference, so we get a srb2 binary rather than a symlink to lsdlsrb2-version
    cp -L '/home/aresuser/ARES-Setup/tmp/build/srb2/bin/lsdl2srb2' "$md_inst/srb2"
    md_ret_files=(
        'assets/installer/music.dta'
        'assets/installer/player.dta'
        'assets/installer/zones.pk3'
        'assets/installer/srb2.pk3'
		'assets/installer/patch.pk3'
        'assets/README.txt'
        'assets/LICENSE.txt'
    )
}

function configure_srb2() {
    addPort "$md_id" "srb2" "Sonic Robo Blast 2" "pushd $md_inst; ./srb2; popd"

    moveConfigDir "$home/.srb2"  "$md_conf_root/$md_id"
}
