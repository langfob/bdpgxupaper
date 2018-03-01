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
#' @param emulating_tzar boolean indicating whether to run tzar_emulator; TRUE
#'   implies run emulator, FALSE implies don't run under emulator
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

    cat ("\n\nSTARTING xu_paper_main.R at ", date(), "\n\n")

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

    parameters <- bdpg::init_for_bdpg (parameters)
    integerize <- bdpg::get_integerize_function (parameters$integerize_string)

#===============================================================================
#                       Do the main work.
#===============================================================================

    gen_4_variants =
        bdpg::value_or_FALSE_if_null (parameters$gen_4_basic_variants)

    gen_20_variants =
        bdpg::value_or_FALSE_if_null (parameters$gen_20_basic_variants)

    if (gen_20_variants)
        {
        bdpg::gen_20_basic_variants_including_cost_error (parameters,
                                                          integerize)

        } else if (gen_4_variants)
        {
        bdpg::gen_4_basic_variants (parameters, integerize)

        } else
        {
        single_action =
            bdpg::value_or_FALSE_if_null (parameters$single_action_using_tzar_reps)

        if (single_action)
            {
            bdpg::single_action_using_tzar_reps (parameters, integerize)

            } else
            {
            cat ("\n\nIn xu_paper_main.R, no matching actions found, ",
                 "so, doing nothing...\n\n")
            }
        }

#===============================================================================
#               Clean up tzar, console sink, etc.
#===============================================================================

    clean_up ()

    cat ("\n\n================================================================================")
    cat ("\n================================================================================\n\n")
    }

#===============================================================================

