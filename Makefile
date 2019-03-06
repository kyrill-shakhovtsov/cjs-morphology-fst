LANGUAGE = cjs

main_lexc = $(LANGUAGE).lexc
guesser_lexc = $(LANGUAGE)-guesser.lexc

analyser_fst = fst/$(LANGUAGE)-analyser.bin
clean_analyser_fst = fst/$(LANGUAGE)-clean-analyser.bin
guesser_fst = fst/$(LANGUAGE)-guesser.bin
combined_fst = fst/$(LANGUAGE)-analyser-guesser.bin
clean_combined_fst = fst/$(LANGUAGE)clean-analyser-guesser.bin
segmenter_fst= fst/$(LANGUAGE)-segmenter.bin
normaliser_fst = fst/$(LANGUAGE)-normaliser.bin

all: $(main_lexc) $(guesser_lexc) $(analyser_fst) $(clean_analyser_fst) $(guesser_fst) $(combined_fst) $(clean_combined_fst) $(segmenter_fst) $(normaliser_fst)

$(main_lexc): include/description.txt include/multichar_symbols.lexc include/root.lexc lexicon/*.lexc morphosyntax/*.lexc
	@cat $^ > $(main_lexc)

analyser: $(analyser_fst)

clean_analyser: $(clean_analyser_fst)

guesser: $(guesser_fst)

combined: $(combined_fst)

clean_combined: $(clean_combined_fst)

segmenter: $(segmenter_fst)

normaliser: $(normaliser_fst)


$(guesser_lexc): include/multichar_symbols.lexc include/root-guesser.lexc morphosyntax/*.lexc
	@cat $^ > $(guesser_lexc)

$(analyser_fst): $(main_lexc) analyser.xfst analysis.xfst phonology/rules.xfst
	foma -f analyser.xfst

$(clean_analyser_fst): $(main_lexc) clean-analyser.xfst clean-analysis.xfst phonology/rules.xfst filter.xfst
	foma -f clean-analyser.xfst

$(guesser_fst): $(guesser_lexc) guesser.xfst phonology/rules.xfst phonology/root.xfst filter.xfst
	foma -f guesser.xfst

$(combined_fst): $(analyser_fst) $(guesser_fst) analyser-guesser.xfst
	foma -f analyser-guesser.xfst

$(clean_combined_fst): $(clean_analyser_fst) $(guesser_fst) clean-analyser-guesser.xfst
	foma -f clean-analyser-guesser.xfst

$(segmenter_fst): $(main_lexc) phonology/rules.xfst segmenter.xfst filter.xfst
	foma -f segmenter.xfst

$(normaliser_fst): normaliser.xfst
	foma -f normaliser.xfst

clean:
	@if [ -r $(main_lexc) ] ; then rm *.lexc ; fi
	@if [ -r $(analyser_fst) ] ; then rm fst/* ; fi
	@rm words/out/*.list
	@find . -name '*~' -delete
