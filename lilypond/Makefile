LYFILES = $(wildcard *.ly)
PDFFILES = $(addsuffix .pdf,$(basename $(LYFILES)))

all: $(PDFFILES)

%.pdf: %.ly
	lilypond $<
