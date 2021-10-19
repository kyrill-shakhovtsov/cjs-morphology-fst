#!/bin/sh

case "$1" in
	'-a')
		echo $2 | flookup fst/cjs-clean-analyser.bin
		;;
	'-g')
		echo $2 | flookup fst/cjs-guesser.bin
		;;
	*)
		echo -e "$0 {-a|-g} словоформа\n\t-a\tиспользует анализатор: $0 -a киреечилербе\n\t-g\tиспользует «гадалку»:  $0 -g кертиктеримде"
esac
