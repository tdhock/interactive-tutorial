old.lib <- file.path(Sys.getenv("HOME"), "lib-old")
dir.create(old.lib, showWarnings=FALSE)
.libPaths(old.lib)
options(repos="http://cran.rstudio.com")
### Write down what package versions work with your R code, and
### attempt to download and load those packages. The first argument is
### the version of R that you used, e.g. "3.0.2" and then the rest of
### the arguments are package versions. For
### CRAN/Bioconductor/R-Forge/etc packages, write
### e.g. RColorBrewer="1.0.5" and if RColorBrewer is not installed
### then we use install.packages to get the most recent version, and
### warn if the installed version is not the indicated version. For
### GitHub packages, write "user/repo@commit"
### e.g. "tdhock/animint@f877163cd181f390de3ef9a38bb8bdd0396d08a4" and
### we use install_github to get it, if necessary.
works_with_R <- function(Rvers,...){
  pkg_ok_have <- function(pkg,ok,have){
    stopifnot(is.character(ok))
    if(!as.character(have) %in% ok){
      warning("works with ",pkg," version ",
              paste(ok,collapse=" or "),
              ", have ",have)
    }
  }
  pkg_ok_have("R",Rvers,getRversion())
  pkg.vers <- list(...)
  for(pkg.i in seq_along(pkg.vers)){
    vers <- pkg.vers[[pkg.i]]
    pkg <- if(is.null(names(pkg.vers))){
      ""
    }else{
      names(pkg.vers)[[pkg.i]]
    }
    if(pkg == ""){# Then it is from GitHub.
      ## suppressWarnings is quieter than quiet.
      if(!suppressWarnings(require(requireGitHub))){
        ## If requireGitHub is not available, then install it using
        ## devtools.
        if(!suppressWarnings(require(devtools))){
          install.packages("devtools")
          require(devtools)
        }
        install_github("tdhock/requireGitHub")
        require(requireGitHub)
      }
      requireGitHub(vers)
    }else{# it is from a CRAN-like repos.
      if(!suppressWarnings(require(pkg, character.only=TRUE))){
        install.packages(pkg)
      }
      pkg_ok_have(pkg, vers, packageVersion(pkg))
      require(pkg, character.only=TRUE)
    }
  }
}


works_with_R(
  "3.2.3",
  ##rCharts="0.4.2",
  ## "ramnathv/rCharts@faf2043f90e149d8620a570c78449079c6dbb6fb",
  ## "ramnathv/rMaps@e08edfed5a1c1e02dcf04269f42120dd3224c952",
  ## dygraphs="0.8",
  ## igraph="0.7.1",
  ## shiny="0.13.0",
  ## "ekstroem/MESS@0a4218119fb9f6d2bd715ffb57b6cf2f24eee710",
  ## metricsgraphics="0.9.0",
  ##highcharter="1.0",
  ##"jbkunst/highcharter@a8c917e91ae64efa66087d8fe883e1b403e177be",
  "hadley/scales@2c3edf45de56d617444dc38e47e0404173817886",
  "tdhock/ggplot2@a8b06ddb680acdcdbd927773b1011c562134e4d2",
  "tdhock/animint@6b1c9e588b03f632cd39cdec9bbcfa730db9e889",
  ## DiagrammeR="1.0"## DO NOT UNCOMMENT! Okay okay ;)
)


