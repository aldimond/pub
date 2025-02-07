LYFILES = $(wildcard *.ly)
LYPDFFILES = $(addsuffix .pdf,$(basename $(LYFILES)))

%.pdf: %.ly
	lilypond $<
