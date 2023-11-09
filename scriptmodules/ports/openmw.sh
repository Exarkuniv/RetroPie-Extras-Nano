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

rp_module_id="openmw"
rp_module_desc="openmw - Morrowind source port"
rp_module_licence="GPL3 https://github.com/OpenMW/osg/blob/3.4/LICENSE.txt"
rp_module_help="Copy\nMorrowind.esm\nBloodmoon.esm\nTribunal.esm\nFonts folder\nMusic folder\nSound folder\nin the morrowind Folder in above format.\nMAKE sure the video folder is not there, IT will crash. This takes 1HOUR 50MIN to build\n
This will only run MAIN game if you want the expansions have them in a morrowind folder before you install"
rp_module_section="prt"
rp_module_flags="noinstclean"

function depends_openmw() {
   getDepends cmake 

}

function install_bin_openmw() {
    aptInstall openmw openmw-cs openmw-data openmw-launcher
}

function config_data_openmw() { 
    #look for the data files to see what config to install
	
    #download config to for the data files for main and all exp
    if [[ -f "$romdir/ports/morrowind/Morrowind.bsa" && -f "$romdir/ports/morrowind/Tribunal.bsa" && -f "$romdir/ports/morrowind/Bloodmoon.bsa"  ]]; then
	downloadAndExtract "https://github.com/Exarkuniv/game-data/raw/main/openmw/1.zip" "$md_conf_root/openmw"
	
	#download config to for the data files for main and tribunal exp
    elif [[ -f "$romdir/ports/morrowind/Morrowind.bsa" && -f "$romdir/ports/morrowind/Tribunal.bsa" ]]; then
	downloadAndExtract "https://github.com/Exarkuniv/game-data/raw/main/openmw/2.zip" "$md_conf_root/openmw"
	
	#download config to for the data files for main and bloodmoon exp
    elif [[ -f "$romdir/ports/morrowind/Morrowind.bsa" && -f "$romdir/ports/morrowind/Bloodmoon.bsa" ]]; then
	downloadAndExtract "https://github.com/Exarkuniv/game-data/raw/main/openmw/3.zip" "$md_conf_root/openmw"

    elif [[ -f "$romdir/ports/morrowind/Morrowind.bsa" ]]; then
    downloadAndExtract "https://github.com/Exarkuniv/game-data/raw/main/openmw/4.zip" "$md_conf_root/openmw"
	fi
}

function configure_openmw() {
    mkRomDir "ports/morrowind"
    moveConfigDir "$md_inst/data" "$romdir/ports/morrowind"
    moveConfigDir "/etc/openmw" "$md_conf_root/$md_id"

    addPort "$md_id" "openmw" "The Elder Scrolls III - Morrowind" "openmw"
	
	[[ "$md_mode" == "install" ]] && config_data_openmw

}