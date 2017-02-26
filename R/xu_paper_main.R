#===============================================================================

                        #  xu_paper_main.R

#===============================================================================

#  History:

#  2017 01 22 - BTL
#       Removed from old biodivprobgen project as part of splitting that
#       project into separate packages for the code specific to papers and
#       the general library of problem generator code.

#===============================================================================

#' Mainline for experiments and data generation for Xu bdpg paper
#'
#' This is the top level function for running experiments and generating data for
#' the problem difficulty paper that explains the Xu biodiversity problem
#' generator.
#'
#' @param parameters List of parameters controlling the current run (usually
#'   decoded from project.yaml by tzar)
#'
#' @return returns nothing
#'
#' @export
#'
#' @examples \dontrun{
#' xu_paper_main (parameters)
#'}

xu_paper_main = function (parameters)
    {

#===============================================================================
#                       external_startup_code.R
#===============================================================================
#
#  This file contains all of the startup code that will not be part of
#  running things as a package.  In particular, it includes:
#
#   - some global variables for debugging
#   - code related to using tzar and tzar emulation
#
#===============================================================================
#          Global variables not to be included in package.
#===============================================================================

    cat ("\n\nSTARTING generateSetCoverProblem.R at ", date(), "\n\n")

#===============================================================================

        #  There are a bunch of constant strings used for things like
        #  directory and column names that are a pain in the ass to pass
        #  all up and down the call tree or to duplicate in every copy of
        #  all class objects, so I'm going to do the evil thing and create
        #  a global variable to store these global constants.
        #
        #  When I don't do it this way and I pass these variables all over,
        #  they make the code harder to read because they're fairly meaningless
        #  variables handed all over the place for little utility.
        #  The only reasons for having these values as variables at all
        #  (as opposed to hard-coding the strings), is to make sure they're
        #  consistent in all occurrences of various structures and to make
        #  it easy to change their values everywhere at once on the rare
        #  occasions when I want to do that.

    bdpg::create_global_constants()

#===============================================================================

        #  debugging level: 0 means don't output debugging write statements.
        #  Having this as an integer instead of binary so that I can have
        #  multiple levels of detail if I want to.
#    DEBUG_LEVEL = 0
    options (bdpg.DEBUG_LEVEL=0)
    options (bdpgxupaper.DEBUG_LEVEL=0)

        #  Turn all R warnings into errors.
    options (warn=2)

#===============================================================================
                    #  START TZAR EMULATION CODE
#===============================================================================

        #  When using RStudio, the console output buffer is currently limited and
        #  you can lose informative console output from bdprobdiff in a big run.
        #  To capture that output, tee the output to a scratch sink file.
        #
        #  NOTE:  For some reason, this sink causes a warning message after
        #  the code comes back from a marxan run:
        #      unused connection
        #  I have no idea why this happens, especially because it doesn't always
        #  happen.  Since I have warnings set to generate errors rather than
        #  warnings, it stops the program by calling browser().  If I just hit Q,
        #  then the program continues from there without any problems.
        #  At the moment, trapping all the output is more important than having
        #  this annoying little hitch, so I'm leaving all this in.
        #  At production time, I'll need to either remove it or fix it.
        #  I should add an issue for this in the github issue tracking.

    echoConsoleToTempFile = TRUE
    emulatingTzar = parameters$emulatingTzar

    if (emulatingTzar & echoConsoleToTempFile)
        {
        sinkFilePath = paste0 (parameters$fullOutputDirWithSlash,
                               "consoleSinkOutput.temp.txt")

            #  Open a file to echo console to.
        tempConsoleOutFile <- file (sinkFilePath, open="wt")

        	#  Redirect console output to the file.
        sink (tempConsoleOutFile, split=TRUE)
        }

        #  Sometimes, for debugging, bdpg needs to know if we're
        #  emulating tzar, so record the value as a global option.
    options (bdpg.emulatingTzar=emulatingTzar)

#===============================================================================
#                   Initialize for use of bdpg package.
#===============================================================================

    params_and_error_codes <- bdpg::init_for_bdpg (parameters)

    parameters             <- params_and_error_codes$parameters
    bdpg_error_codes       <- params_and_error_codes$bdpg_error_codes

#===============================================================================
#       Generate a problem, i.e, create the Xu graph nodes and edge_list.
#===============================================================================

    COR_bd_prob = bdpg::gen_bdprob (parameters,
                               bdpg_error_codes,
                               bdpg::get_integerize_function (parameters$integerize_string)
                               # ,
                               # DEBUG_LEVEL
                               )

    bdpg::do_COR_marxan_analysis_and_output (COR_bd_prob, parameters)

    cat("\n\njust after set_up_for_and_run_marxan() for cor problem")
    cat ("\n\n================================================================================")
    cat ("\n================================================================================\n\n")

#-------------------------------------------------------------------------------

    #     #  Try running marxan on the base cor problem since we know that
    #     #  this particular test has created a wrapped problem.
    #     #
    #     #  Note that a different way around this issue is to create the
    #     #  cor base problem and do the analysis on it before creating
    #     #  the wrapped problem, but creating the wrap by directly passing
    #     #  the cor to it without going through gen_bdprob's superstructure.
    #
    # get_base_cor_prob_of_wrap_prob <- function ()
    #     {
    #     cat ("not implemented yet""
    #     }
    # base_COR_bd_prob = get_base_cor_prob_of_wrap_prob (COR_bd_prob)
    #
    # base_COR_marxan_ret_values = bdpg::set_up_for_and_run_marxan_COR (base_COR_bd_prob, parameters)
    #
    # marxan_control_values  = base_COR_marxan_ret_values$marxan_control_values
    # base_COR_bd_prob       = base_COR_marxan_ret_values$base_COR_bd_prob  #  COR_bd_prob has new dirs
    #
    # cat("\n\njust after set_up_for_and_run_marxan() for base cor problem")

#===============================================================================
#  Generate an APPARENT problem from the correct problem, i.e., apply errors.
#===============================================================================

    APP_bd_prob = bdpg::gen_single_bdprob_APP (COR_bd_prob,
                                            #COR_bd_prob@top_outdir,
                                            parameters,
                                            bdpg_error_codes,
                                            bdpg::get_integerize_function (parameters$integerize_string)
                                            )

    bdpg::do_APP_marxan_analysis_and_output (APP_bd_prob, COR_bd_prob, parameters)

    cat("\n\njust after set_up_for_and_run_marxan() for app problem")
    cat ("\n\n================================================================================")
    cat ("\n================================================================================\n\n")

#===============================================================================
#               Clean up tzar, console sink, etc.
#===============================================================================

    clean_up ()

        #  If you were echoing console output to a temp file,
        #  stop echoing and close the temp file.

    if (echoConsoleToTempFile)
        {
        sink ()
        close (tempConsoleOutFile)
        }

    cat ("\n\n================================================================================")
    cat ("\n================================================================================\n\n")
    }

#===============================================================================

