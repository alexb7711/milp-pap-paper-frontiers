################################################################################
# Variables
################################################################################
target   = a-position-allocation-approach-to-the-scheduling-of-beb-charging.pdf # Name of file
doc_src  = main.tex                                                             # Name of main source file
img_src := $(wildcard img/*.tex)                                                # Image source files
doc_pdf := $(patsubst %.tex, %.pdf, $(img_src))                                 # Image source pdfs

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
all: precheck img $(target)

##-----------------------------------------------------------------------------
#
img: $(img_src)

##-----------------------------------------------------------------------------
#
clean:
	@rm -f $(target)
	@rm img/*.pdf
	@latexmk -c $(doc_src)
	@latexmk -c $(img_src)

##=============================================================================
# Helper recipes

##-----------------------------------------------------------------------------
# Create the PDF document
$(target): $(doc_src)
	@echo "Creating document..."
	@latexmk -f -interaction=nonstopmode                                  \ # Don't stop
		 -silent                                                      \ # Shhhh 
		 -bibtex                                                      \ # Don't stop x2
		 -e "$latex='latex %O -shell-escape %S'"                      \ # Output PDF
                 -pdf main.tex
	@[ -f main.pdf ] && mv main.pdf $(target)
	@echo "Done!"

##-----------------------------------------------------------------------------
# Create the images as PDFs
$(img_src):
	@echo "Creating images..."
	@latexmk -f -interaction=nonstopmode                                  \ # Don't stop
		 -e "$latex='latex %O -shell-escape %S'"                      \ # Don't stop x2
		 -pdf $<                                                      \ # Ouput PDF

##-----------------------------------------------------------------------------
# Check if all the requirements are met to build
precheck:
	@if ! command -v latexmk &> /dev/null
	@then
		@echo "'latexmk' could not be found"
		@echo "Installing..."
		@sudo pacman -Syu latexmk
	@if

################################################################################
# References
################################################################################
# https://ctan.math.washington.edu/tex-archive/support/latexmk/latexmk.pdf
# https://www.gnu.org/software/make/manual/html_node/Phony-Targets.html
# https://blogs.ethz.ch/daesters/2020/12/30/make-a-thesis-with-latex-with-latexmk-and-makefile/
