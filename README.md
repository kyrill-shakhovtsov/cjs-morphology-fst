# Free morphological analyser for Shor language
© Kirill Shakhovtsov, 2014—2020

## Licence
GNU GPL is assumed for everything except the contents of the folders _lexicon_ and _words_ (see respective README's).

# Свободный морфологический анализатор шорского языка
© К.Г. Шаховцов, 2014—2020

Первый вариант анализатора был разработан для проекта «Корпусы ИЭА РАН» (http://corpora.iea.ras.ru/) в 2014 г.

В настоящее время разработка продолжается в рамках проекта «Языковое и этнокультурное разнообразие Южной Сибири в синхронии и диахронии: взаимодействие языков и культур» (грант Правительства РФ П 220 №14.Y26.31.0014, руководитель А.В. Дыбо), 2017—2019.

### Лицензия
В настоящий момент все составлющие части анализатора распространяются на условиях GNU GPL, за исключением содержимого каталогов _lexicon_ и _words_ (подробности см. в README в соответствующих каталогах).

### Источники

1. Д — Дыренкова Н.П. Грамматика шорского языка. М.—Л., 1941.
2. ЧГ — Чиспияков Э.Ф. Графика и орфография шорского языка. Кемерово, 1992.
3. ЧУ — Чиспияков Э.Ф. Учебник шорского языка.  Кемерово, 1992.
4. КА — Шорско-русский и русско-шорский словарь / Сост. Курпешко-Таннагашева Н.Н., Апонькин Ф.Я. Кемерово, 1993.
5. ШС — Шорско-русский словарь с сайта Shorica (http://shoriya.ngpi.rdtc.ru/)
6. Б — Ойротско-русский словарь / Сост. Н.А. Баскаков, Н.М. Тощакова. М., 1947.
7. Ш — Шенцова И.В. Акциональные формы глагола в шорском языке. Кемерово, 1997.
8. Оз — Озонова А.А. Система деепричастных форм алтайского языка // Сибирский филологический журнал, 2017, №4. С. 238—252.
9. ХС — Хакасско-русский словарь. Новосибирск: Наука, 2006.
10. Е — Есипова А.В. Фонетические деформации производящей основы (на материале шорского языка) //


Обозначения в скобках используются в комментариях в коде и словарях для отсылок к источникам, напр. (Д-151) соответствует [Дыренкова 1941:151]. По умолчанию словари анализатора основаны на КА.

Помимо вышеуказанных могут встретиться следующие пометы:
* (К) — обнаружено в корпусе;
* (Ф) — комментарий Д.А. Функа.

### Благодарности
Я благодарен проф. Д.А. Функу за поддержку безнадежного начинания и многочисленные консультации.

## Описание
Анализатор выполен в виде набора конечно-автоматных преобразователей (finite-state transducer) с использованием формализма XFST (Xerox Finite-State Tools).

Для самостоятельной компиляции преобразователей необходимы инструментарий foma (https://fomafst.github.io/), GNU make и оболочка, совместимая с Bash. Если вы не собираетесь экспериментировать с исходным кодом, вам достаточно установить foma (доступно для Linux, Mac и Windows) и загрузить готовые к использованию преобразователи из каталога `fst/`.

### Состав анализатора
* собственно анализатор
* «гадалка» — разбирает формы, основы которых отсутствуют в словаре
* автомат морфемной сегментации
* «нормализатор» — превращает разбор формы в разбор леммы для последующего ее синтеза

### Структура каталогов
* `include/` — вспомогательные файлы LEXC: корневые лексиконы и декларация символов
* `debug/`
	* `phonology.xfst` — грамматика для отладки _фонологии_
	* `morphosyntax.xfst` — грамматика для отладки _морфосинтаксиса_
* `doc/` — дополнительная документация, см. README.md
* `fst/` — скомпилированные преобразователи
* `extra/` — дополнительные мелочи, см. README.md
* `lexicon/` — словарь, разбитый на файлы по частям речи, в формате LEXC, см. README.md
* `morphosyntax/` — модель морфосинтаксиса в формате LEXC
* `orthography/` — примитивный преобразователь из «старой» шорской орфографии в новую
* `phonology/`
	* `rules.xfst` — фонологические правила
	* `roots.xfst` — фонетическая структура корня для «гадательного» разбора
* `words/`
	* `in/` — списки слов из шорского корпуса ИЭА РАН для тестирования анализатора
	* `out/` — результаты обработки списков из каталога in/
* `Makefile`
* `cjs.lexc` — словарь + морфосинтаксис (создается автоматически)
* `cjs-guesser.lexc` — морфосинтаксис для бессловарной «гадалки» (создается автоматически)
* `analyser-guesser.xfst` — создает комбинацию анализатора и «гадалки» в `fst/cjs-analyser-guesser.bin` (неразобранное анализатором отдается на разбор «гадалке»)
* `analyser.xfst` — анализатор, использующий как новую, так и старую орфографию (`fst/cjs-analyser.bin`)
* `clean-analyser-guesser.xfst` — комбинация «чистого» анализатора и «гадалки» (`fst/cjs-clean-analyser-guesser.bin`)
* `clean-analyser.xfst` — «чистый» (без учета старой орфографии) анализатор (`fst/cjs-clean-analyser.bin`)
* `filter.xfst` — правила фильтрации наиболее безумных вариантов морфологического разбора
* `guesser.xfst` — бессловарная «гадалка», порождающая все возможные варианты разбора (`fst/cjs-guesser.bin`)
* `normaliser.xfst` — вспомогательный автомат (`fst/cjs-normaliser.bin`) для превращения разбора формы в разбор леммы
* `segmenter.xfst` — автомат морфемной сегментации (`fst/cjs-segmenter.bin`)
* `stats.sh` — см. _Использование_
* `lemmatise.sh` — см. _Использование_
* `TODO`

### Использование
Простейший вариант:
* анализ: `flookup fst/<анализатор> < <список_слов> > <результаты>`
* синтез: `flookup -i fst/<анализатор> < <список_разборов> > <результаты>`
* `stats.sh` — обрабатывает списки форм из `words/in/` всеми имеющимися автоматами (результаты помещаются в `words/out/`) с выводом краткой статистики
* `lemmatise.sh` — сопоставляет разбору формы разбор потенциальной леммы, затем порождает леммы по разборам (следует использовать после `stats.sh`)
