#!/bin/bash
if [[ "$(whoami)" != "root" ]]; then
        sudo ${BASH_SOURCE[0]}
        exit
fi
apt update -y
apt install -y build-essential flex bison libssl-dev libelf-dev git gcc curl make bc bison ca-certificates gnupg libelf-dev lsb-release software-properties-common wget libncurses-dev binutils-aarch64-linux-gnu gcc-aarch64-linux-gnu
if [ -x ./link-llvm.sh ]; then
	./link-llvm.sh 13
fi
