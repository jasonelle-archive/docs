#!/usr/bin/env Rscript
# https://bookdown.org/yihui/bookdown/build-the-book.html

bookdown::render_book("index.Rmd", "bookdown::gitbook")

# Epub output disabled due to github constraints
# bookdown::render_book("index.Rmd", "bookdown::epub_book")

# PDF Book gives some troubles because of gifs
# bookdown::render_book("index.Rmd", "bookdown::pdf_book")
