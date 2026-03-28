# Makefile for building LaTeX CV
# Usage:
#   make        - Full build (build -> biber -> build x2)
#   make quick  - Single build (no bibliography)
#   make clean  - Remove all build artifacts

.PHONY: all quick clean

OUTDIR = out
SRC = main.tex
STEM = $(basename $(SRC))
TEX = lualatex -synctex=1 -interaction=nonstopmode -file-line-error -output-directory=$(OUTDIR)

ifeq ($(OS),Windows_NT)
	DEVNULL = NUL
	MKDIR = if not exist $(OUTDIR) mkdir $(OUTDIR)
	CLEAN = if exist $(OUTDIR) del /q $(OUTDIR)\* 2>NUL
else
	DEVNULL = /dev/null
	MKDIR = mkdir -p $(OUTDIR)
	CLEAN = rm -rf $(OUTDIR)/*
endif

all:
	@$(MKDIR)
	@echo [1/4] lualatex (initial)
	@$(TEX) $(SRC) > $(DEVNULL)
	@echo [2/4] biber
	@biber --output-directory=$(OUTDIR) $(STEM) > $(DEVNULL)
	@echo [3/4] lualatex (resolve references)
	@$(TEX) $(SRC) > $(DEVNULL)
	@echo [4/4] lualatex (final)
	@$(TEX) $(SRC) > $(DEVNULL)

quick:
	@$(MKDIR)
	@echo [1/1] lualatex
	@$(TEX) $(SRC) > $(DEVNULL)

clean:
	@$(CLEAN)