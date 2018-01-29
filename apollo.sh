#!/bin/bash
##
#  Copyright (C) 2015, Samsung Electronics, Co., Ltd.
#  Written by System S/W Group, S/W Platform R&D Team,
#  Mobile Communication Division.
#
#  For Apollo_X
#  By Hashtag (hash07)
#
##

set -e -o pipefail

PLATFORM=sc8830
DEFCONFIG=AX_defconfig
NAME=Apollo_X
VERSION=v1

export ARCH=arm
export CROSS_COMPILE=/home/hash/toolchain/ubertc-4.9/bin/arm-eabi-
export LOCALVERSION=-${NAME}-${VERSION}
export KBUILD_BUILD_USER="Hashtag"
export KBUILD_BUILD_HOST="Hell_Box"

KERNEL_PATH=$(pwd)
KERNEL_ZIP=${KERNEL_PATH}/kernel_zip
KERNEL_ZIP_NAME=${NAME}-${VERSION}.zip
EXTERNAL_MODULE_PATH=${KERNEL_PATH}/external_module
OUTPUT_PATH=${KERNEL_PATH}/output

JOBS=`grep processor /proc/cpuinfo | wc -l`

# Colors
cyan='\033[1;36m'
yellow='\033[1;33m'
red='\033[1;31m'
nocol='\033[0m'
BRed='\e[1;31m'
BGre='\e[1;32m'
BYel='\e[1;33m'
BBlu='\e[1;34m'
BCya='\e[1;36m'
BMag='\e[1;35m'
Whi='\e[1;37m'
NONE="\033[0m"

function build() {
	clear;

	BUILD_START=$(date +"%s");
	echo -e "$cyan"
	echo "***********************************************";
	echo "              Compiling Apollo_X          	     ";
	echo -e "***********************************************$nocol";
	echo -e "$red";

	if [ ! -e ${OUTPUT_PATH} ]; then
		mkdir ${OUTPUT_PATH};
	fi;

	echo -e "$red";
	echo -e "Initializing defconfig...$nocol";
	make ${DEFCONFIG};
	echo -e "$red";
	echo -e "Building kernel...$nocol";
	make -j${JOBS};
	make -j${JOBS} dtbs;
	./scripts/mkdtimg.sh -i ${KERNEL_PATH}/arch/arm/boot/dts/ -o dt.img;
	find ${KERNEL_PATH} -name "zImage" -exec mv -f {} ${KERNEL_ZIP} \;
	find ${KERNEL_PATH} -name "dt.img" -exec mv -f {} ${KERNEL_ZIP} \;

	BUILD_END=$(date +"%s");
	DIFF=$(($BUILD_END - $BUILD_START));
	echo -e "$yellow";
	echo -e "Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol";
}

function make_zip() {
	echo -e "$red";
	echo -e "Making flashable zip...$nocol";

	cd ${KERNEL_PATH}/kernel_zip;
	zip -r ${KERNEL_ZIP_NAME} ./;
	mv ${KERNEL_ZIP_NAME} ${KERNEL_PATH};

	echo -e "$yellow";
	echo -e "Zip is Ready..!$nocol";
}

function clean() {
	echo -e "$red";
	echo -e "Cleaning build environment...$nocol";
	make mrproper;

	if [ -e ${KERNEL_ZIP_NAME} ]; then
		rm ${KERNEL_ZIP_NAME};
	fi;

	if [ -e ${KERNEL_ZIP}/zImage ]; then
		rm ${KERNEL_ZIP}/zImage;
	fi;

	if [ -e ${KERNEL_ZIP}/dt.img ]; then
		rm ${KERNEL_ZIP}/dt.img;
	fi;

	echo -e "$yellow";
	echo -e "Done!$nocol";
}

function main() {
	reset;
    echo -e "\n\n                              ${BMag}╦╔═${NONE}${BCya}╔═╗${NONE}${BYel}╦═╗${NONE}${BGre}╔═╗╗${NONE}${BRed}╔═╗${NONE}${BBlu}╔ ${NONE}";
    echo -e "                              ${BMag}╠╩╗${NONE}${BCya}║╣ ${NONE}${BYel}╠╦╝${NONE}${BGre}║ ║║${NONE}${BRed}║╣ ${NONE}${BBlu}║ ${NONE}";
    echo -e "                              ${BMag}╩ ╩${NONE}${BCya}╚═╝${NONE}${BYel}╩╚═${NONE}${NONE}${BGre}╚ ╚╝${NONE}${BRed}╚═╝${NONE}${BBlu}╚═╝${NONE}";
    echo -e "";
echo -e "";
    echo -e "      ${red}██████${NONE}${BCya}╗${NONE} ${red}██████${NONE}${BCya}╗${NONE}  ${red}█████${NONE}${BCya}╗${NONE}  ${red}██${NONE}${BCya}╗${NONE}     ${red}██${NONE}${BCya}╗${NONE}      ${red}█████${NONE}${BCya}╗${NONE}            ${red}██${NONE}${BCya}╗${NONE}   ${red}██${NONE}${BCya}╗${NONE}";
    echo -e "      ${red}██${NONE}${BCya}╔═${NONE}${red}██${NONE}${BCya}║${NONE} ${red}██${NONE}${BCya}╔═${NONE}${red}██${NONE}${BCya}║${NONE} ${red}██${NONE}${BCya}╔══${NONE}${red}██${NONE}${BCya}╗${NONE} ${red}██${NONE}${BCya}║${NONE}     ${red}██${NONE}${BCya}║${NONE}     ${red}██${NONE}${BCya}╔══${NONE}${red}██${NONE}${BCya}╗${NONE}            ${red}██${NONE}${BCya}╗${NONE} ${red}██${NONE}${BCya}╔╝${NONE}";
    echo -e "      ${red}██████${NONE}${BCya}║${NONE} ${red}██████${NONE}${BCya}║${NONE} ${red}██${NONE}${BCya}║${NONE}  ${red}██${NONE}${BCya}║${NONE} ${red}██${NONE}${BCya}║${NONE}     ${red}██${NONE}${BCya}║${NONE}     ${red}██${NONE}${BCya}║${NONE}  ${red}██${NONE}${BCya}║${NONE}              ${red}██${NONE}${BCya}╔═╝${NONE}"; 
    echo -e "      ${red}██${NONE}${BCya}╔═${NONE}${red}██${NONE}${BCya}║${NONE} ${red}██${NONE}${BCya}╔═══╝ ${NONE}${red}██${NONE}${BCya}║${NONE}  ${red}██${NONE}${BCya}║${NONE} ${red}██${NONE}${BCya}║${NONE}     ${red}██${NONE}${BCya}║${NONE}     ${red}██${NONE}${BCya}║${NONE}  ${red}██${NONE}${BCya}║${NONE}            ${red}██${NONE}${BCya}╔═${NONE}${red}██${NONE}${BCya}╗${NONE}";  
    echo -e "      ${red}██${NONE}${BCya}║${NONE} ${red}██${NONE}${BCya}║${NONE} ${red}██${NONE}${BCya}║${NONE}      ${red}█████${NONE}${BCya}╔╝${NONE} ${red}██████${NONE}${BCya}╗${NONE} ${red}██████${NONE}${BCya}╗${NONE}  ${red}█████${NONE}${BCya}╔╝${NONE} ${red}████████${NONE}${BCya}╗${NONE} ${red}██${NONE}${BCya}╔╝${NONE}  ${red}██${NONE}${BCya}╗${NONE}";
    echo -e "      ${BCya}╚═╝ ╚═╝ ╚═╝      ╚════╝  ╚═════╝ ╚═════╝  ╚════╝  ╚═══════╝ ╚═╝   ╚═╝${NONE}\n";
	echo -e "$Whi"
	echo -e "                                                                     By Hash07$nocol";
	echo -e "$yellow"
	echo -e "Specified Toolchain path:$nocol ${CROSS_COMPILE}";
	if [ "${USE_CCACHE}" == "1" ]; then
		CCACHE_PATH=/usr/bin/ccache;
		export CROSS_COMPILE="${CCACHE_PATH} ${CROSS_COMPILE}";
		export JOBS=8;
		echo -e "$red";
		echo -e "You have enabled ccache through *export USE_CCACHE=1*, now using ccache...$nocol\n";
	fi;
#Main Menu
while :
	do
	echo -e "$BCya===================${NONE} ${BGre}[!]${NONE} ${BBlu}AX Kernel Menu${NONE} ${BGre}[!]${NONE} $BCya===================${NONE}";
	echo -e "$Whi"
	echo "[1] Cleanup source";
	echo "[2] Build kernel";
	echo "[3] Build kernel then make flashable ZIP";
	echo "[4] Make flashable ZIP package";
	echo -e ""
	echo " Hit Any key to exit this script";
	echo -e ""
	echo -e "$BCya=====================================================================$NONE\n";
	read -n 1 -p "Select your choice: " -s choice;
	case ${choice} in
		1) clean;;
		2) clean
		   build;;
		3) clean
		   build
		   make_zip;;
		4) make_zip;;
		*) echo
		   echo "Invalid choice entered. Exiting..."
		   sleep 2;
		   exit 1;;
	esac
done
}

main $@
