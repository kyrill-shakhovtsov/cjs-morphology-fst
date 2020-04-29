#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import gv

config = {
	'graph': {
		'concentrate': 'true',
		'fontname': 'PT Sans',
		'fontsize': '18',
		'nodesep': '1.0'
		},
	'node': {
		'fontname': 'PT Sans',
		'fontsize': '14',
		'fontcolor': 'black',
		'shape': 'none'
		},
	'edge': {
		'color': 'gray40'
		},
	'tags': ['Tag_N', 'Tag_PN', 'Tag_PRO', 'Tag_NUM', 'Tag_V', 'Tag_A', 'Tag_ADV', 'Tag_POST', 'Tag_INTJ', 'Tag_PART'],
	'color': {
		'tag': 'firebrick',
		'lexicon': 'navy',
		'toSlot': 'navy',
		'toBoundary': 'firebrick',
		'formend': 'firebrick'
		}
	}

if len(sys.argv) == 1:
	print 'Использование: lex2dot.py файл.lexc'
	quit()

if len(sys.argv) > 1:
	try:
		fh = open(sys.argv[1])
	except:
		print 'Ошибка: файл', sys.argv[1], 'не найден!'
		quit()

# Разбор файла lexc
nodes = list()

for line in fh:
	line = line.strip()
	if len(line) > 0 and not line.startswith('!'):
		if line.startswith('LEXICON'):
			node = dict()
			node['name'] = line.split()[1]
			node['cont'] = list()
		elif ';' in line:
			if '<' in line:
				line = line.translate(None, '<>"')
			line = line.split(';', 1)[0]
			rl = line.split()
			if len(rl) == 2:
				node['cont'].append({'rex': rl[0], 'tgt': rl[1]})
			elif len(rl) > 2:
				node['cont'].append({'rex': ''.join(rl[0:-1]), 'tgt': rl[-1]})
			else:
				node['cont'].append({'rex': '     ', 'tgt': rl[0]}) # ∅
			nodes.append(node)

# Исходные паметры графа
g = gv.digraph('LEXC')
gv.setv(g, 'concentrate', config['graph']['concentrate'])
gv.setv(g, 'label', 'Настольная игра для младших научных сотрудников «' + sys.argv[1] + '»')
gv.setv(g, 'fontname', config['graph']['fontname'])
gv.setv(g, 'fontsize', config['graph']['fontsize'])
gv.setv(g, 'nodesep', config['graph']['nodesep'])

pn = gv.protonode(g)
gv.setv(pn, 'fontname', config['node']['fontname'])
gv.setv(pn, 'fontsize', config['node']['fontsize'])
gv.setv(pn, 'fontcolor', config['node']['fontcolor'])
gv.setv(pn, 'shape', config['node']['shape'])

pe = gv.protoedge(g)
gv.setv(pe, 'color', config['edge']['color'])

# Генерация  графа
t = gv.graph(g, "Tags") # подграф для частеречных помет
gv.setv(t, "rank", "same")

s = list()

for node in nodes:
	n = gv.node(g, node['name']) # текущая вершина

	if node['name'] in config['tags']: #.startswith('Tag'):
		gv.node(t, node['name']) # n -> Tags

	if node['name'] == 'Root':
		gv.setv(n, 'shape', 'circle')
		gv.setv(n, 'color', 'firebrick')
		gv.setv(n, 'style', 'filled')
		gv.setv(n, 'fillcolor', 'blanchedalmond')
		for cont in node['cont']:
			gv.edge(n, cont['tgt'])
			gv.setv(gv.findnode(g, cont['tgt']), 'fontname', config['node']['fontname'] + ' Bold')
			s.append(cont['tgt'])
	elif node['name'] in s:
		gv.edge(n, node['cont'][0]['tgt'])
	else:
		label = '<<table border="0" cellborder="1" cellpadding="6" cellspacing="0"><tr><td colspan="2" port="l"><b><font color="'
		if node['name'].startswith('Tag'):
			label += config['color']['tag']
		else:
			label += config['color']['lexicon']
		label += '">' + node['name'] + '</font></b></td></tr>'
		i = 0
		for cont in node['cont']:
			if cont['tgt'] == '#':
				tgt = '<b><font color="' + config['color']['formend'] + '">' + cont['tgt'] + '</font></b>'
				tgt_a = 'right'
			else:
				e = gv.edge(n, cont['tgt'])
				gv.setv(e, 'tailport', 't' + str(i) + ':e')
				gv.setv(e, 'headport', 'l:n')
				if '_Slot' in cont['tgt'] :
					gv.setv(e, 'color', config['color']['toSlot'])
				if '_StemBoundary' in cont['tgt'] :
					gv.setv(e, 'color', config['color']['toBoundary'])
				tgt = cont['tgt']
				tgt_a = 'left'
			label += '<tr><td align="left">' + cont['rex'] + '</td><td align="' + tgt_a + '" port="t' + str(i) + '">' + tgt + '</td></tr>'
			i += 1
		label += '</table>>'
		gv.setv(n, 'label', label)

gv.write(g, sys.argv[1] + '.gv');
