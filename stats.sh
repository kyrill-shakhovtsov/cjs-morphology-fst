#!/bin/sh

lang="cjs"
in='words/in'
out='words/out'

flookup -a fst/${lang}-analyser-guesser.bin < ${in}/${lang}-normalised.test | grep -P -v '^$' > ${out}/processed.list

flookup fst/${lang}-clean-analyser.bin < ${in}/${lang}-normalised.test | grep -P -v '^$|\+' > ${out}/clean-analysed.list

flookup fst/${lang}-clean-analyser.bin < ${in}/${lang}-normalised.test | grep -P '\+\?' > ${out}/clean-failures.list

grep 'Guess' ${out}/processed.list > ${out}/guessed.list

grep -P '\+\?' ${out}/processed.list > ${out}/failures.list


echo "Обработаны $(wc -l ${in}/${lang}-normalised.test | cut -f 1 -d ' ') форм из ${in}/${lang}-normalised.test"

echo "Результаты сохранены в каталоге ${out}/"
echo '------------------------------------------------------'

echo "processed.list      ($(wc -l ${out}/processed.list | cut -f 1 -d ' ')) — все обработанные варианты"

echo "clean-analysed.list ($(wc -l ${out}/clean-analysed.list | cut -f 1 -d ' ')) — разобранное «чистым» анализатором"

echo "clean-failures.list ($(wc -l ${out}/clean-failures.list | cut -f 1 -d ' ')) — неразобранное «чистым» анализатором"

echo "guessed.list        ($(wc -l ${out}/guessed.list | cut -f 1 -d ' ')) — «гадательно» разобранное"

echo -e "failures.list       ($(wc -l ${out}/failures.list | cut -f 1 -d ' ')) — вообще неразбираемое\n"
