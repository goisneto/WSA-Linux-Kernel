#!/bin/bash
if [[ "$(whoami)" != "root" ]]; then
	sudo ${BASH_SOURCE[0]}
	exit
fi
while true; do
	if [ -n "$(echo $LLVM_VERSION | grep -E '[0-9][0-9]+')" ]; then
		break
	elif [[ "$LLVM_VERSION_SET" == "1" ]]; then
		echo "Please satisfy this format [0-9][0-9]+"
	elif [ -n "$(echo $1 | grep -E '[0-9][0-9]+')" ]; then
		LLVM_VERSION=$1
		shift
		continue
	fi
	read -p "LLVM_VERSION? " LLVM_VERSION
	LLVM_VERSION_SET=1
done
unset LLVM_VERSION_SET
if [[ "$1" == "llvm-install" ]]; then
        wget https://apt.llvm.org/llvm.sh
        chmod +x llvm.sh
        ./llvm.sh $LLVM_VERSION
        rm ./llvm.sh
fi
arr_execs=( /usr/bin/clang /usr/bin/ld.lld /usr/bin/llvm-objdump /usr/bin/llvm-ar /usr/bin/llvm-nm /usr/bin/llvm-strip /usr/bin/llvm-objcopy /usr/bin/llvm-readelf /usr/bin/clang++ )
for path_exec in ${arr_execs[@]}
do
	if [ ! -x $path_exec-$LLVM_VERSION ]; then
		if [[ "$1" == "llvm-install" ]]; then
			echo "Error: LLVM installation not provide $path_exec file as executable. Can't continue."
			exit
		fi
		LLVM_VERSION=$LLVM_VERSION ${BASH_SOURCE[0]} llvm-install
		exit
	fi
	ln -sf $path_exec-$LLVM_VERSION $path_exec
done
ls -alh ${arr_execs[@]}
