# LaTeX Makefile v1.0 -- LaTeX + PDF figures

##==============================================================================
# CONFIGURATION
##==============================================================================
.PHONY = clean help
MAKEFLAGS := --jobs=4
SHELL  = /bin/bash

##==============================================================================
# DIRECTORIES
##==============================================================================
SCRIPTS = ./org-doc-scripts
IMG     = img

##==============================================================================
# FILES
##==============================================================================
DOC_SRC         = main.tex
TARGET          = $(shell find . -type f -name $(DOC_SRC))
ALL             = $(shell find . -type f -name "*.org")
FIGURES_TEX     = $(wildcard img/*tex)
FIGURES_PDF     = $(patsubst %.tex, %.pdf, $(FIGURES_TEX))

##==============================================================================
# RECIPES
##==============================================================================

##------------------------------------------------------------------------------
#
all: precheck $(FIGURES_PDF) ## Build full thesis (LaTeX + figures)

##------------------------------------------------------------------------------
#
clean:	## Clean LaTeX and output figure files
	@rm -f $(FIGURES_PDF)
	@rm -f $(patsubst %.pdf, %.aux, $(FIGURES_PDF))
	@rm -f $(patsubst %.pdf, %.log, $(FIGURES_PDF))
	@rm -f $(TARGET)
	@latexmk -silent -C $(DOC_SRC)


##------------------------------------------------------------------------------
#
watch:	## Recompile on any update of LaTeX or SVG sources
	@while [ 1 ]; do;	       \
		inotifywait $(ALL);    \
		sleep 0.01;	       \
		make all;	       \
		echo "\n----------\n"; \
		done

##------------------------------------------------------------------------------
#
help:  # http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@grep -P '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	sort |                                                \
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

##==============================================================================
# HELPER RECIPES
##==============================================================================

##------------------------------------------------------------------------------
#
%.pdf: %.tex  ## Figures for the manuscript
	@printf "Generating %s...\033[K\r" "$@"
	@pdflatex -shell-escape -interaction=nonstopmode -output-directory $(IMG) "$<" | \
	grep "^!" -A20 --color=always || true

##------------------------------------------------------------------------------
#
precheck: ## Ensures all the required software is installed
	@$(SHELL) -e $(SCRIPTS)/check-packages
	@epspdf -v>/dev/null 2>&1 || ep2pdf -v>/dev/null 2>&1 && \
	echo "EPS converter installed!" ||                       \
	(echo "Warning: no EPS converter installed"; exit 1)
