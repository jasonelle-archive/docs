#!/usr/bin/env Rscript
# https://bookdown.org/yihui/bookdown/serve-the-book.html

options(blogdown.hugo.server = c("-D", "-F"))
bookdown::serve_book(dir = ".", 
                    output_dir = "_book", 
                    preview = TRUE, 
                    in_session = TRUE)