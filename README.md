# Free morphological analyser for Shor language

# Свободный морфологический анализатор шорского языка
© К.Г. Шаховцов, 2011—2019

Первый вариант анализатора был разработан для проекта [«Корпусы ИЭА РАН»] (http://corpora.iea.ras.ru/) в 2011—2014 гг.

В настоящее время разработка продолжается в рамках проекта «Языковое и этнокультурное разнообразие Южной Сибири в синхронии и диахронии: взаимодействие языков и культур» (грант Правительства РФ П 220 №14.Y26.31.0014, руководитель А.В. Дыбо), 2017—2019.

### Лицензия



### Источники

1. Дыренкова Н.П. Грамматика шорского языка. М.—Л., 1941. (Д)
2. Чиспияков Э.Ф. Графика и орфография шорского языка. Кемерово, 1992. (ЧГ)
3. Чиспияков Э.Ф. Учебник шорского языка.  Кемерово, 1992. (ЧУ)
4. Шорско-русский и русско-шорский словарь / Сост. Курпешко-Таннагашева Н.Н., Апонькин Ф.Я. Кемерово, 1993.
5. Шорско-русский словарь с сайта [Shorica] (http://shoriya.ngpi.rdtc.ru/)
6. Ойротско-русский словарь / Сост. Н.А. Баскаков, Н.М. Тощакова. М., 1947. (Б)
7. Шенцова И.В. Акциональные формы глагола в шорском языке. Кемерово, 1997. (Ш)
8. Озонова А.А. Система деепричастных форм алтайского языка // Сибирский филологический журнал, 2017, №4. С. 238—252. (Оз)

Обозначения в скобках используются в комментариях в коде для отсылок к источникам, напр. Д-151 соответствует [Дыренкова 1941:151].

### Благодарности
Я благодарен проф. Д.А. Функу за поддержку безнадежного начинания и многочисленные консультации.

## Описание
Анализатор выполен в виде набора конечно-автоматных преобразователей (finite-state transducer) с использованием формализма XFST (Xerox Finite-State Tools).

Для самостоятельной компиляции преобразователей необходимы инструментарий [foma] (https://fomafst.github.io/), GNU make и оболочка, совместимая с Bash. Если вы не собираетесь экспериментировать с исходным кодом, вам достаточно установить foma (доступно для Linux, Mac и Windows) и загрузить готовые к использованию преобразователи из каталога fst/.

### Состав анализатора
* собственно анализатор
* «гадалка» — разбирает формы, основы которых отсутствуют в словаре
* автомат морфемной сегментации
* «нормализатор» — превращает разбор формы в разбор леммы для последующего ее синтеза

### Структура каталогов
* include/
	вспомогательные файлы LEXC: корневые лексиконы и декларация символов
* debug/

	phonology.xfst — грамматика для отладки _фонологии_
	lexicon.xfst — грамматика для отладки _морфосинтаксиса_
* fst/
	скомпилированные преобразователи
* extra/
	xfst.xml — файл подсветки синтаксиса XFST/foma для Kate/KDevelop
	lexc2dot.pl — скрипт для визуализации внутренностей морфосинтаксисической части анализатора (нужны Perl и GraphViz)
* lexicon/
	словарь, разбитый на файлы по частям речи, в формате LEXC
* morphosyntax/
	модель морфосинтаксиса (именные части речи, глагол, клитики) в формате LEXC
* orthography/
	примитивный преобразователь из «старой» шорской орфографии в новую
* phonology/
	rules.xfst — фонологические правила
	roots.xfst — фонетическая структура корня для «гадательного» разбора
* words/
	* in
		списки слов из шорского корпуса ИЭА РАН для тестирования анализатора
	* out
		результаты обработки списков из каталога in/
Makefile
TODO
stats.sh
lemmatise.sh

### Использование
Простейший вариант:
* анализ: `flookup fst/<файл анализатора> < список_слов.txt > результаты.txt`
* синтез: `flookup -i fst/<файл анализатора> < список_разборов.txt > результаты.txt`



### Дополнительные мелочи
Скрипт lexc2dot.pl позволяет построить граф, отображающий связи между «лексиконами» внутри файла LEXC. Использование: команда `lexc2dot.pl cjs.lexc` сгенерирует файл cjs.lexc.gv (граф в формате GraphViz dot), который затем может быть преобразован, напр., в PDF, командой `dot -Tpdf -O cjs.lexc.gv` (файл будет называться cjs.lexc.gv.pdf).

Чтобы в KDE можно было использовать подсветку синтаксиса для форматов XFST и LEXC, нужно поместить файл xfst.xml в каталог $HOME/.local/share/org.kde.syntax-highlighting/syntax/
