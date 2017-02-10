<!-- README.md is generated from README.Rmd. Please edit that file -->
bdpgxupaper
===========

This package bundles together the code for running experiments demonstrating the Xu biodiversity problem generator.

Explaining, demonstrating, and using the Xu biodiversity problem generator is more than easily fits in a single understandable paper. This package encapsulates the code used for just the first paper, which explains and demonstrates the generator. The package is intended to document what is done in the paper and is not likely to be used by anyone other than the authors, though nothing prevents that use.

Installation
------------

You can install bdpgxupaper from github with:

``` r
# install.packages ("devtools")  
devtools::install_github ("langfob/bdpgxupaper")
```

Debugging
---------

No matter what problem you're having while using tzar emulation, look first to see if R/model.R exists. If it does, then delete it and retry whatever you're doing (e.g., running runtip() or doing a Build, etc.) The presence of model.R (instead of having it built automatically from model.R.tzar) seems to cause all kinds of strange errors whose messages make no mention at all of model.R and lead you astray.

One common place where model.R issues come up is when you rebuild the package. Often, you're fixing a bug and that bug may have shown up as a crash that left model.R in the R directory instead of deleting it as it does on proper completion. When you try to do the rebuild, R thinks that the model.R file is a part of the package and tries to execute it. However, model.R has code in it that's not inside of a function, so R blows up trying to execute that code. In that case, you get an error like this:

    ==> devtools::document(roclets=c('rd', 'collate', 'namespace'))

    Updating bdpgxupaper documentation
    Loading bdpgxupaper
    Error in if (!emulatingTzar) { (from model_with_possible_tzar_emulation.R#36) : argument is of length zero
    Calls: suppressPackageStartupMessages ... source_one -> eval -> eval -> model_with_possible_tzar_emulation
    Execution halted

    Exited with status 1.

Just deleting model.R and starting the build again makes the error disappear.

Example
-------

There are no examples yet.

Overview
--------

There is no overview yet.
