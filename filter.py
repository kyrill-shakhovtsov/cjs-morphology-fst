#!/usr/bin/python3

import subprocess
import sys

# Число «морфем» в сегментации
def num_morph(segmentation):
	return len(segmentation.split('.'))

# Излечение последней частречной пометы
def extract_pos(analysis):
	return analysis[analysis.rfind('[') + 1:analysis.rfind(']')]

#
def abs_len_diff(form, segmentation):
	return abs(len(form) - len(segmentation.replace('.', '')))


if len(sys.argv) > 1:
	try:
		fh = open(sys.argv[1])
	except:
		print("Ошибка: файл", sys.argv[1], "не найден!")
		quit()

forms = dict()

for line in fh:
	if len(line) > 0:
		form = line.strip()
		s1 = subprocess.check_output(['flookup', '-x', 'fst/cjs-clean-analyser.bin'], input=form, universal_newlines=True)
		a = list()
		for analysis in s1.split():
			if analysis != '+?':
				s2 = subprocess.check_output(['flookup', '-x', 'fst/cjs-segmenter-u.bin'], input=analysis, universal_newlines=True)
				for segmentation in s2.split():
					if segmentation != '+?':
						s3 = subprocess.check_output(['flookup', '-x', 'fst/cjs-normaliser.bin'], input=analysis, universal_newlines=True)
						std_analysis = s3.strip()
						s4 = subprocess.check_output(['flookup', '-x', '-i', 'fst/cjs-clean-analyser.bin'], input=std_analysis, universal_newlines=True)
						lemma = s4.strip()
						pos = extract_pos(analysis)
						a.append({'analysis': analysis, 'pos': pos, 'segmentation': segmentation, 'std_analysis': std_analysis, 'lemma': lemma, 'score': 0})
						#print(form, segmentation, lemma, analysis, std_analysis, sep='\t')
		forms[form] = a

#print(forms)

# -----------------------------------------------

for form in forms:
	n = len(forms[form])
	print('— «', form, '»\tкол-во разборов:', n)
	if n > 0:
		i = 0
		a = []
		b = []
		for variant in forms[form]:
			variant['score'] = 1 / n
			print(i, 'вес:', variant['score'], variant['pos'], variant['analysis'], '|', variant['segmentation'], '\tлемма:', variant['lemma'])
			a.append(num_morph(variant['segmentation']))
			#print(len(form), len(variant['segmentation'].replace('.', '')))
			b.append(abs_len_diff(form, variant['segmentation']))
			i = i + 1
		j = a.index(min(a))
		k = b.index(min(b))
		forms[form][j]['score'] += (1 - forms[form][j]['score']) / n
		forms[form][k]['score'] += (1 - forms[form][k]['score']) / (1.5 * n)
		print(j, forms[form][j]['score'], '(a)')
		print(k, forms[form][k]['score'], '(b)')
		#print('a', a, 'b', b)
