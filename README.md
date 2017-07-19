<!-- README.md is generated from README.Rmd. Please edit that file -->
bdpgxupaper
===========

This package bundles together the code for running experiments demonstrating the Xu biodiversity problem generator.

Explaining, demonstrating, and using the Xu biodiversity problem generator is more than easily fits in a single understandable paper. This package encapsulates the code used for just the first paper, which explains and demonstrates the generator. The package is intended to document what is done in the paper and is not likely to be used by anyone other than the authors, though nothing prevents that use.

Installation
------------

You can install bdpgxupaper from github using devtools::install\_github().

However, the repo is currently private, which means that you have to be listed on github as a collaborator and pass a github personal access token to see it. If you don't have a token yet, you can get one by following the instructions at:

[Personal access tokens](https://github.com/settings/tokens)

or

[Creating a personal access token for the command line](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/)

You can store this token in an environment variable called GITHUB\_PAT on your machine. This allows future use of the personal access token without having to hard-code it into functions calls. You can then retrieve it in a devtools::install\_github() call's "auth" argument by using devtools::github\_pat() as shown below.

While the repo is still private, the devtools call looks like:

``` r
devtools::install_github ("langfob/bdpgxupaper", auth_token = "INSERT YOUR TOKEN STRING HERE")
```

or

``` r
devtools::install_github ("langfob/bdpgxupaper", auth_token = devtools::github_pat())
```

If and when the repo becomes public, the call is simply:

``` r
devtools::install_github ("langfob/bdpgxupaper")
```

So, assuming that the repo is still private and you've stored a token in the GITHUB\_PAT environment variable, you can download the package as follows:

``` r
install.packages ("devtools")    #  if devtools not installed already
devtools::install_github ("langfob/bdpgxupaper", auth_token = devtools::github_pat())
```

Note that install\_github() also has an optional "ref" argument that allows you to specify a particular 'commit, tag, or branch name, or a call to github\_pull. Defaults to "master"'.

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

-   To call the mainline code for bdpgxupaper using tzar emulation:

    ``` r
    library(bdpgxupaper)
    runtip()
    ```

Overview
--------

There is no overview yet.
