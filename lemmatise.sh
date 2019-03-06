#!/bin/sh

lang="cjs"
in='words/out'
out='words/out'

# if [ -r ${in}/form-lemma-analyses.list ] ; then rm ${out}/form-lemma-analyses.list ${out}/analyses-lemmata.list ; fi

cut -f 2 ${in}/clean-analysed.list | flookup fst/${lang}-normaliser.bin | grep -P -v '^$' | sort | uniq > ${out}/form-lemma-analyses.list

# При генерации лемм не учитываются местоимения! --------V
cut -f 2 ${in}/form-lemma-analyses.list | grep -P -v '^\[PRO\]' | flookup -i fst/${lang}-clean-analyser.bin | grep -P -v '^$' | sort | uniq > ${out}/analyses-lemmata.list

echo "Результаты сохранены в ${out}"
echo "--------------------------------"
echo "form-lemma-analyses.list $(wc -l ${out}/form-lemma-analyses.list | cut -f 1 -d ' '): разбор формы -> рабор леммы"
echo "   analyses-lemmata.list $(wc -l ${out}/analyses-lemmata.list | cut -f 1 -d ' '): разбор леммы -> лемма"

echo -e "NB: Леммы для местоимений не сгенерированы!\n"
