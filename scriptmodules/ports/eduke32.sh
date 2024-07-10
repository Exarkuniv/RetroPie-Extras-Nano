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

rp_module_id="eduke32"
rp_module_desc="Duke3D Port"
rp_module_licence="GPL2 https://voidpoint.io/terminx/eduke32/-/raw/master/package/common/gpl-2.0.txt?inline=false"
rp_module_section="prt"
rp_module_flags=""

function depends_eduke32() {
    local depends=(
        flac libflac-dev libvorbis-dev libpng-dev libvpx-dev freepats
        libsdl2-dev libsdl2-mixer-dev
    )

    isPlatform "x86" && depends+=(nasm)
    isPlatform "gl" || isPlatform "mesa" && depends+=(libgl1-mesa-dev libglu1-mesa-dev)
    isPlatform "x11" && depends+=(libgtk2.0-dev)
    getDepends "${depends[@]}"
	
	if isPlatform "odroid-n2"; then
	/home/aresuser/ARES-Setup/fixmali.sh
    elif isPlatform "rockpro64"; then
    /usr/lib/arm-linux-gnueabihf/install_mali.sh
	fi
}

function sources_eduke32() {
    gitPullOrClone "$md_build" https://voidpoint.io/terminx/eduke32.git "master"
}

function build_eduke32() {
    local params=(LTO=0 SDL_TARGET=2)

    [[ "$md_id" == "ionfury" ]] && params+=(FURY=1)
    ! isPlatform "x86" && params+=(NOASM=1)
    ! isPlatform "x11" && params+=(HAVE_GTK2=0)
    ! isPlatform "gl3" && params+=(POLYMER=0)
    ! ( isPlatform "gl" || isPlatform "mesa" ) && params+=(USE_OPENGL=0)
    # r7242 requires >1GB memory allocation due to netcode changes.
    isPlatform "arm" && params+=(NETCODE=0)

    make veryclean
    CFLAGS+=" -DSDL_USEFOLDER" make STARTUP_WINDOW=0 "${params[@]}"

    if [[ "$md_id" == "ionfury" ]]; then
        md_ret_require="$md_build/fury"
    else
        md_ret_require="$md_build/eduke32"
    fi
}

function install_eduke32() {
    md_ret_files=('mapster32')

    if [[ "$md_id" == "ionfury" ]]; then
        md_ret_files+=('fury')
    else
        md_ret_files+=('eduke32')
    fi
}

function game_data_eduke32() {
    cd "$_tmpdir"

    if [[ "$md_id" == "eduke32" ]]; then
        if [[ ! -f "$romdir/ports/duke3d/duke3d.grp" ]]; then
            wget --no-check-certificate 3dduke13.zip "$__archive_url/3dduke13.zip"
            unzip -L -o 3dduke13.zip dn3dsw13.shr
            unzip -L -o dn3dsw13.shr -d "$romdir/ports/duke3d" duke3d.grp duke.rts
            rm 3dduke13.zip dn3dsw13.shr
            chown -R $user:$user "$romdir/ports/duke3d"
        fi
    fi
}

function configure_eduke32() {
    local appname="eduke32"
    local portname="duke3d"
    if [[ "$md_id" == "ionfury" ]]; then
        appname="fury"
        portname="ionfury"
    fi
    local config="$md_conf_root/$portname/settings.cfg"


    mkRomDir "ports/$portname"
    moveConfigDir "$home/.config/$appname" "$md_conf_root/$portname"

    add_games_eduke32 "$portname" "$md_inst/$appname"


    # remove old launch script
    rm -f "$romdir/ports/Duke3D Shareware.sh"

    if [[ "$md_mode" == "install" ]]; then
        game_data_eduke32

		touch "$config"			   
        iniConfig " " '"' "$config"

        # enforce vsync for kms targets
        isPlatform "kms" && iniSet "r_swapinterval" "1"

        # the VC4 & V3D drivers render menu splash colours incorrectly without this
        isPlatform "mesa" && iniSet "r_useindexedcolortextures" "0"

        chown -R $user:$user "$config"
    fi
}

function add_games_eduke32() {
    local portname="$1"
    local binary="$2"
    local game
    local game_args
    local game_path
    local game_launcher
    local num_games=4

    if [[ "$md_id" == "ionfury" ]]; then
        num_games=0
        local game0=('Ion Fury' '' '')
    else
        local game0=('Duke Nukem 3D' '' '-addon 0')
        local game1=('Duke Nukem 3D - Duke It Out In DC' 'addons/dc' '-addon 1')
        local game2=('Duke Nukem 3D - Nuclear Winter' 'addons/nw' '-addon 2')
        local game3=('Duke Nukem 3D - Caribbean - Lifes A Beach' 'addons/vacation' '-addon 3')
        local game4=('NAM' 'addons/nam' '-nam')
    fi

    for ((game=0;game<=num_games;game++)); do
        game_launcher="game$game[0]"
        game_path="game$game[1]"
        game_args="game$game[2]"

        if [[ -d "$romdir/ports/$portname/${!game_path}" ]]; then
           addPort "$md_id" "$portname" "${!game_launcher}" "${binary}.sh %ROM%" "-j$romdir/ports/$portname/${game0[1]} -j$romdir/ports/$portname/${!game_path} ${!game_args}"
        fi
    done

    if [[ "$md_mode" == "install" ]]; then
        # we need to use a dumb launcher script to strip quotes from runcommand's generated arguments
        cat > "${binary}.sh" << _EOF_
#!/bin/bash
# HACK: force vsync for RPI Mesa driver for now
VC4_DEBUG=always_sync $binary \$*
_EOF_

        chmod +x "${binary}.sh"
    fi
}
