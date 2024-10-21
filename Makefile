EMACS := emacs
VERSION := $(shell sed -ne 's/^;; Version: \(.*\)/\1/p' buttercup.el)
ELISP_FILES := $(filter-out buttercup-pkg.el,$(wildcard *.el))

.PHONY: test compile clean

all: test

check test: check-buttercup check-docs

check-buttercup test-buttercup: compile
	./bin/buttercup -L . tests $(if $(CI),--traceback pretty)

check-docs test-docs: compile
	$(EMACS) -batch -L . -l buttercup.el -f buttercup-run-markdown docs/writing-tests.md

compile: $(patsubst %.el,%.elc,$(ELISP_FILES))

%.elc: %.el
	$(EMACS) -batch -L . -f batch-byte-compile $<

%.eps: %.jpg
	convert $< eps2:$@

doc: info
info: docs/buttercup.info
doc: dvi
dvi: docs/buttercup.dvi
docs/buttercup.dvi: docs/images/buttercup.eps

TEXI2DVI_FLAGS = -o $@

clean:
	rm -f *.elc tests/*.elc
	rm -f docs/*.info
	rm -f docs/*.dvi docs/images/*.eps
