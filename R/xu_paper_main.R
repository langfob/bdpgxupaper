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

xu_paper_main = function (parameters, emulating_tzar=FALSE)
    {

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

        #  Sometimes, for debugging, bdpg needs to know if we're
        #  emulating tzar, so record the value as a global option.

    options (bdpg.emulating_tzar = emulating_tzar)

#===============================================================================
#                   Initialize for use of bdpg package.
#===============================================================================

    params_and_error_codes <- bdpg::init_for_bdpg (parameters)

    parameters             <- params_and_error_codes$parameters
    bdpg_error_codes       <- params_and_error_codes$bdpg_error_codes

    integerize             <- bdpg::get_integerize_function (parameters$integerize_string)

#===============================================================================
#                       Do the main work.
#===============================================================================

    gen_4_variants =
        bdpg::value_or_FALSE_if_null (parameters$gen_4_basic_variants)

    if (gen_4_variants)
        {
        bdpg::gen_4_basic_variants (parameters, bdpg_error_codes, integerize)

        } else
        {
        single_action =
            bdpg::value_or_FALSE_if_null (parameters$single_action_using_tzar_reps)

        if (single_action)
            {
            bdpg::single_action_using_tzar_reps (parameters,
                                                 bdpg_error_codes,
                                                 integerize)

            } else
            {
            cat ("\n\nIn xu_paper_main.R, no matching actions found, ",
                 "so, doing nothing...\n\n")
            }
        }

#===============================================================================
#               Clean up tzar, console sink, etc.
#===============================================================================

    clean_up (tzar_emulation_flag_and_console_sink_information)

    cat ("\n\n================================================================================")
    cat ("\n================================================================================\n\n")
    }

#===============================================================================

