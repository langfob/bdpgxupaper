#===============================================================================
#
#                               non_tzar_main.R

#       NOTE:  THIS HAS NOT BEEN TESTED YET BECAUSE THE PARAMETERS LIST
#               THAT IT BUILDS NEEDS A LOT MORE ELEMENTS.
#               AT THE MOMENT, IT'S ONLY HERE TO SHOW WHAT IT WOULD
#               LOOK LIKE.
#               BTL - 2017 08 11
#
# This is a standalone file with everything someone would need to run the
# paper's code without using tzar or tzar emulation.
#
# This requires building a parameters list yourself, so an example for how to do
# that is given along with the code to call the paper's mainline code.
#
#===============================================================================

#' Dummy function to build parameters list if tzar was not run.
#'
#' This function is just a place holder that other users could modify
#' if they were neither running tzar nor running the tzar emulator.
#' They would just change all of the NA values in here to whatever
#' they want for the run.
#' More lines may need to be added to this in the future if more
#' values from the parameters list are used in this program.
#' I generated this list by running the following bash command and
#' editing the resulting lines in the old bdprobdiff project:
#'      grep 'parameters\$' generateSetCoverProblem.R
#'
#' Note that the variables listed in this routine are very likely to be
#' out of date due to the constant evolution of the rest of the code
#' for this project.  If you're going to use this local_build_parameters_list()
#' function, you should rebuild it to match the variables currently used in the
#' rest of the code.  The code shown here for this function is only here
#' to provide an example of what it might look like based on the parameters
#' that were in use when it was first generated.
#'
#' @return list of parameters corresponding to what would have been in tzar's
#'   project.yaml file
#'
#' @examples \dontrun{
#' local_build_parameters_list ()
#'}

local_build_parameters_list = function ()
    {
    parameters = list()

    parameters$seed = NA
    parameters$integerize_string = NA
    parameters$n__num_groups = NA
    parameters$use_unif_rand_n__num_groups = NA
    parameters$n__num_groups_lower_bound = NA
    parameters$n__num_groups_upper_bound = NA
    parameters$alpha__ = NA
    parameters$use_unif_rand_alpha__ = NA
    parameters$alpha___lower_bound = NA
    parameters$alpha___upper_bound = NA
    parameters$p__prop_of_links_between_groups = NA
    parameters$use_unif_rand_p__prop_of_links_between_groups = NA
    parameters$p__prop_of_links_between_groups_lower_bound = NA
    parameters$p__prop_of_links_between_groups_upper_bound = NA
    parameters$r__density = NA
    parameters$use_unif_rand_r__density = NA

        #  BTL - 2015 03 19
        #  Not sure why these bounds on r__density said p__r__... instead
        #  of just r__...
        #  So, replacing the p__r__... in gscp_3..., gscp_5..., and in
        #  project.yaml.

#    parameters$p__r__density_lower_bound = NA
    parameters$r__density_lower_bound = NA
#    parameters$p__r__density_upper_bound = NA
    parameters$r__density_upper_bound = NA

    parameters$base_for_target_num_links_between_2_groups_per_round = NA
    parameters$at_least_1_for_target_num_links_between_2_groups_per_round = NA
    parameters$marxan_spf_const = NA
    parameters$marxan_num_reps = NA
    parameters$marxan_num_iterations = NA
    parameters$run_id = NA
    parameters$summary_filename = NA

    return (parameters)
    }

#===============================================================================

#' Example function for running the main code without using tzar or tzar
#' emulation
#'
#' All experiments for the paper described in this package are done under tzar
#' or tzar emulation.  However, run_without_tzar_or_tzar_emulation() is provided
#' to document how you would call the code for the paper without using tzar.
#'
#' In that case, you would have to create the required parameters list yourself.
#' An example function for doing that is provided in get_parameters().
#'
#' Neither non_tzar_main() nor get_parameters() are used in creating the paper
#' described in this package, but both functions are provided here as examples.
#'
#' @param parameters  list of parameters built by tzar from project.yaml
#'
#' @export
#'
#' @examples \dontrun{
#' run_without_tzar_or_tzar_emulation (parameters)
#'}

run_without_tzar_or_tzar_emulation <- function ()
    {

stop ("\n\nNOT TESTED YET.  2017 08 17.  NEEDS MANY MORE PARAMETERS.\n\n")

    parameters = local_build_parameters_list ()
    xu_paper_main (parameters)
    }

#===============================================================================

