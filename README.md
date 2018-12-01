# 📝 [Jasonelle Documentation](https://jasonelle.com/docs)

Documentation made using [Bookdown](https://bookdown.org/).

[![Build Status](https://travis-ci.com/jasonelle/docs.svg?branch=develop)](https://travis-ci.com/jasonelle/docs)

## Tips

- `build-docker.sh` Uses https://hub.docker.com/r/rocker/verse/ to build.
- `server.sh` Can be used to develop. Needs *Bookdown* installed.
- `check-branch.sh` and `deploy-github.sh` are used by travis.

## Creating new Chapters

*Bookdown* organize files depending on alphabethic sort. 

Files are organized depending on the chapter numbers.

*Example*

`02-01-History.Rmd` Will be before than `03-01-Cell.Rmd`.

Use different headers to include sections inside chapters.
*Bookdown* menu renders until `###` sections.

- `#` - Chapter
- `##` - Section in Chapter
- `###` - Subsection of Section in Chapter

**Note**

The chapter numbers start at `2` because `index.Rmd` is chapter `1`.
