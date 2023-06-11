################################################################################
# Variables
################################################################################
target	 = a-position-allocation-approach-to-the-scheduling-of-beb-charging.pdf # Name of file
doc_src	 = main.tex																															# Name of main source file
tex_src	 = $(wildcard tex/*.tex)																								# LaTeX files
img_src := $(wildcard img/*.tex)																								# Image source files
img_pdf := $(patsubst %.tex, %.pdf, $(img_src))																	# Image source pdfs

###############################################################################
# Configuration
###############################################################################
.PHONY: all precheck img clean

###############################################################################
# Recipes
###############################################################################

##=============================================================================
# Rules

##-----------------------------------------------------------------------------
#
all: precheck images $(target)

##-----------------------------------------------------------------------------
#
images: $(img_pdf)

##-----------------------------------------------------------------------------
#
clean:
	@rm -f $(target)
	@rm -f img/*.pdf img/*.fls img/*.log img/*.fdb_latexmk img/*.aux
	@latexmk -silent -c $(doc_src)

##=============================================================================
# Helper recipes

##-----------------------------------------------------------------------------
# Create the PDF document
$(target): $(doc_src) $(tex_src)
	@echo "============================"
	@echo "Creating document..."
	@echo "============================"

	@latexmk -f -interaction=nonstopmode \
           -pdf -pdflatex="pdflatex --shell-escape %O %S" \
           -silent -bibtex $<

	@[ -f main.pdf ] && mv main.pdf $(target)
	@echo "Done!"

##-----------------------------------------------------------------------------
# Create the LaTeX images as PDFs
img/%.pdf: img/%.tex
	@echo "============================"
	@echo "Creating $@..."
	@echo "============================"

	@pdflatex -shell-escape -interaction=nonstopmode -output-directory ./img $<

##-----------------------------------------------------------------------------
# Check if all the requirements are met to build
precheck:
	@echo "Checking the programs required for the build are installed..."
	@latexmk --version >/dev/null 2>&1 && (echo "latexmk installed!") || (echo "ERROR: latexmk is required."; exit 1)
	@pdflatex --version >/dev/null 2>&1 && (echo "pdflatex installed!") || (echo "ERROR: pdflatex is required."; exit 1)

################################################################################
# References
################################################################################
# https://ctan.math.washington.edu/tex-archive/support/latexmk/latexmk.pdf
# https://www.gnu.org/software/make/manual/html_node/Phony-Targets.html
# https://blogs.ethz.ch/daesters/2020/12/30/make-a-thesis-with-latex-with-latexmk-and-makefile/
