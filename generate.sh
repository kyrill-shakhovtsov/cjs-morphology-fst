#!/bin/sh

case "$1" in
	'-g')
		echo $2 | flookup -i fst/cjs-guesser.bin
		;;
	'-a')
		echo $2 | flookup -i fst/cjs-clean-analyser.bin
		;;
	*)
		echo -e "$0 {-a|-g} разбор\n\t-a\tиспользует анализатор: $0 -a ада[N]-PL-DAT\n\t-g\tиспользует «гадалку»:  $0 -g кергиш[N]:Guess-SG-DAT"
esac

