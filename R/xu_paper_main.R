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
#   - code for controlling printing of timepoints
#   - code related to using tzar and tzar emulation
#
#===============================================================================
#          Global variables not to be included in package.
#===============================================================================

cat ("\n\nSTARTING generateSetCoverProblem.R at ", date(), "\n\n")

#===============================================================================

    #  debugging level: 0 means don't output debugging write statements.
    #  Having this as an integer instead of binary so that I can have
    #  multiple levels of detail if I want to.
DEBUG_LEVEL = 0

    #  Turn all R warnings into errors.
options (warn=2)

#===============================================================================
                    #  START TZAR EMULATION CODE
#===============================================================================

    #  This just does the local build of the parameters list of not using tzar.
    #  I suspect that parameters will just be an argument to the mainline
    #  function in the end, and this will go away or be external.
    #  gscp_3_get_parameters.R only contains a dummy example of how to create
    #  a parameters list yourself instead of using the tzar-yaml stuff.
    #  So, it doesn't really even need to exist other than where the emulation
    #  calls it when no parameters are presented (in get_parameters() below).
    #  That means that all of this Tzar Emulation section can be externalized
    #  from the mainline and just pass the parameters list into the mainline
    #  as an argument.
    #  I don't think that even the tzar cleanup code needs to be included
    #  if tzar is not being used.  Even though it's referenced in the general
    #  cleanup code, I think that lazy evaluation would mean that it never
    #  gets called so no error would occur.
#####source (paste0 (sourceCodeLocationWithSlash, "gscp_3_get_parameters.R"))

    #-----------

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
if (emulatingTzar & echoConsoleToTempFile)
    {
        #  Open a file to echo console to.
    tempConsoleOutFile <- file("consoleSinkOutput.temp.txt", open="wt")

    	#  Redirect console output to the file.
    sink (tempConsoleOutFile, split=TRUE)
    }

#####parameters = get_parameters (running_tzar_or_tzar_emulator, emulatingTzar)

#===============================================================================
#                       Load function definitions.
#===============================================================================
#  This will eventually be replaced with a library() call for the bdpg library.
#  Any files sourced in this section can only contain function definitions.
#  Any freestanding code has to be sourced or included elsewhere so that I can
#  tell what still needs doing to be able to finish conversion for a library.
#===============================================================================

#####library (plyr)    #  For count() and arrange()
#####library (marxan)

#####library (methods)    #  bipartite needs this if run before igraph under RScript
#####cat ("\n\nAbout to load bipartite library.")
#####library (bipartite)

#####library (assertthat)    #  For unit testing.
#####library (stringr)   #  For str_replace_all.

#####library (igraph)

#####library (marxan)    #  Need to rename this library (i.e., my marxan library) to allow use of UQ library that has same name.

#===============================================================================

#####source (paste0 (sourceCodeLocationWithSlash, "BDProb.R"))

#===============================================================================
    #  Code in this section is not just function definitions.
    #  It contains code that will have to either be incorporated in the
    #  mainline function or further abstracted into functions or
    #  into testing conventions.
#===============================================================================

    #--------------------------------------------------------------------
    #  Set up to record timepoints during the run.
    #
    #  NOTE:  This has to come AFTER tzar emulation or other method of
    #         creation of parameters variable since it uses parameters.
    #--------------------------------------------------------------------

        #  This variable could be specified somewhere else as well, e.g.,
        #  in the tzar parameters file.
timepoints_df_default_length = 20

run_ID = parameters$run_id
runset_name = parameters$runset_name

timepoints_df =
    data.frame (timepoint_num = 1:timepoints_df_default_length,
                timepoint_name = rep (NA, timepoints_df_default_length),
                prev_chunk_elapsed_user = rep (NA, timepoints_df_default_length),
                tot_elapsed_user = rep (NA, timepoints_df_default_length),
                prev_chunk_elapsed_system = rep (NA, timepoints_df_default_length),
                tot_elapsed_system = rep (NA, timepoints_df_default_length),
                cur_time_user = rep (NA, timepoints_df_default_length),
                cur_time_system = rep (NA, timepoints_df_default_length),
                cur_time_wall_clock = rep (NA, timepoints_df_default_length),
                run_ID = run_ID,
                runset_name = runset_name
                )

    #  First time, intialization.
    #  NOTE that these two values are updated all over the place using the
    #  global assignment operator "<<-" in the call to timepoint().
    #  The timepoints dataframe is updated by returning it from the
    #  timepoint() call.
    #  *** However, does that still work when it's called inside of a function?
    #  If it's not returned from the function, then I don't think it will get
    #  updated.
cur_timepoint_num = 0
prev_time = start_time = proc.time()

    #  Each time...

timepoints_df = timepoint (timepoints_df, "start", "Run start...")

#===============================================================================

    #  Set random seed to help reproducibility.
    #  Has to be done after startup code that loads parameters structure.
set.seed (parameters$seed)

#===============================================================================

    clean_up (timepoints_df, cur_timepoint_num, parameters, emulatingTzar,
              "\n\n>>>>>  Ran to completion.  <<<<<\n\n")

        #  If you were echoing console output to a temp file,
        #  stop echoing and close the temp file.
        #  That echoing is currently initiated by a sink() call in
        #  external_startup_code.R (Dec 14, 2016).

    if (echoConsoleToTempFile)
        {
        sink ()
        close (tempConsoleOutFile)
        }

    }

#===============================================================================







#===============================================================================
#===============================================================================
#===============================================================================
#===============================================================================
#===============================================================================
#===============================================================================






    #  Holding spot for what used to be the guts of the mainline code.
    #  Will start here when reinserting things in the mainline or
    #  refactoring the code.

dummy <- function (parameters)
{
#===============================================================================
#       Initialize.
#===============================================================================

    #  Initialize variables that have to be derived from values
    #  set in the parameters structure (which is generally built
    #  from project.yaml).

derived_bdpg_parameters = initialize_and_derive_parameters (parameters)   #  BUG?  UNKNOWN FOR XU FROM FILE?
bdpg_error_codes = derived_bdpg_parameters$bdpg_error_codes

#===============================================================================
#       Generate a problem, i.e, create the Xu graph nodes and edge_list.
#===============================================================================

EF_num <<- 0    #  2016 06 12 - BTL - Only used for debugging in searching for a lognormal...  Can remove if that search gets axed.

bdprob = gen_bdprob (parameters, bdpg_error_codes,
                     derived_bdpg_parameters$integerize)

if (!bdprob@prob_is_ok)
    {
    clean_up (timepoints_df, cur_timepoint_num, parameters, emulatingTzar,
              "\n\n>>>>>  gen_bdprob() failed.  <<<<<\n\n")
    stop ()
    }

#===============================================================================
#                   Save the values for the "correct" problem.
#===============================================================================

    #  The problem structures built so far represent the correct values.
    #  Adding error to the problem structure will create an apparent
    #  problem structure that is probably different from the correct
    #  structure.
    #  When we compute scores at the end of all this, we need to compute
    #  them with respect to the correct problem rather than the apparent.
    #  So, before we add error, we need to save the values defining the
    #  correct structure.

cor_PU_spp_pair_indices = bdprob@PU_spp_pair_indices
cor_bpm                 = bdprob@bpm
cor_num_PUs             = bdprob@num_PUs
cor_num_spp             = bdprob@num_spp
cor_nodes               = bdprob@nodes
cor_optimum_cost        = bdprob@cor_optimum_cost  #  BUG?  HOW IS THIS LOADED FOR XU FROM FILE?
cor_PU_costs            = bdprob@PU_costs
PU_col_name             = bdprob@PU_col_name
spp_col_name            = bdprob@spp_col_name

cor_PU_IDs              = bdprob@all_PU_IDs
cor_spp_IDs             = bdprob@all_spp_IDs

cat ("\n\nAbout to set all_correct_node_IDs.\n")
#browser()
    #  Some nodes may be unusued in cor_nodes, particularly if building a
    #  compound problem, e.g., if wrapping a distribution around a Xu problem.
    #  Need to add them into this list since it will be used to index array
    #  entries, you can't have any missing indices.
#all_correct_node_IDs = cor_nodes$node_ID
all_correct_node_IDs = 1:max(cor_nodes$node_ID)

presences_col_name = "freq"

#===============================================================================

cor_or_app_subdir_name = "cor"

        #  NOTE:  2016 06 12 - Need to add writing of flags resulting from
        #                       reading Xu file, e.g., prob_generator_params_known.
        #                       This is because learning alg downstream needs to
        #                       know things like whether the generator's params
        #                       are even known, so that it doesn't try to learn
        #                       something from missing data.

do_graph_and_marxan_analysis (cor_or_app_subdir_name,

                                            #  input parameters
                                          parameters,
                                          emulatingTzar,
                                          DEBUG_LEVEL,
                                          #derived_bdpg_parameters,   #  BUG?  UNKNOWN FOR XU FROM FILE?
                                          derived_bdpg_parameters$current_os,

                                            #  parameters from gen prob.
#                                          bdprob$derived_Xu_params,
                                          bdprob@Xu_parameters,
                                          bdprob@read_Xu_problem_from_Xu_file,

#            PU_spp_pair_names,  #NO

                                            #  From bdprob structure, i.e., results of gen prob routine
                                          cor_num_spp,
                                          cor_num_PUs,
                                          cor_PU_spp_pair_indices,
    cor_PU_IDs, #####!!!!!#####
    cor_spp_IDs,  #####!!!!!#####
                                          cor_bpm,

                            cor_PU_costs,
                                          cor_optimum_cost,
                                          cor_nodes,
                                          spp_col_name,
                                          PU_col_name,

                                            #  Immediately after bdprob struct vars above.
                                          presences_col_name, #  hard-coded as "freq"
#####!!!!!#####                                          all_correct_node_IDs,

                                            #  Results of adding error.
                                            cor_num_spp,
                                            cor_num_PUs,
                                          cor_PU_spp_pair_indices,
                                          cor_bpm,

                                            #  input parameters for error model.
                                          add_error=FALSE,
                                          match_error_counts=FALSE,
                                          FP_const_rate=0,
                                          FN_const_rate=0,
                                          original_FP_const_rate=0,
                                          original_FN_const_rate=0
                                          )

#===============================================================================
#                   Add error to the species occupancy data.
#===============================================================================

add_error = FALSE
if (! is.null (parameters$add_error_to_spp_occupancy_data))
    add_error = parameters$add_error_to_spp_occupancy_data

if (add_error)
    {
    ret_vals_from_add_errors =
        add_error_to_spp_occupancy_data (parameters, cor_bpm,
                                         cor_num_PU_spp_pairs,
                                         cor_num_PUs, cor_num_spp,
                                         bdpg_error_codes)

        #  Save the chosen error parameters to output later with results.
    original_FP_const_rate = ret_vals_from_add_errors$original_FP_const_rate
    original_FN_const_rate = ret_vals_from_add_errors$original_FN_const_rate
    match_error_counts     = ret_vals_from_add_errors$match_error_counts
    FP_const_rate          = ret_vals_from_add_errors$FP_const_rate
    FN_const_rate          = ret_vals_from_add_errors$FN_const_rate
    app_num_spp            = ret_vals_from_add_errors$app_num_spp
    app_num_PUs            = ret_vals_from_add_errors$app_num_PUs

        #  Set the values for the apparent problem structure.
    app_PU_spp_pair_indices      = ret_vals_from_add_errors$app_PU_spp_pair_indices
    app_bpm                      = ret_vals_from_add_errors$app_spp_occupancy_data

#=================================

        #  Create subdirectory name for this apparent problem.
        #  In the future, we may allow more than 1 app per cor, so
        #  I'll add an app count to the end of the subdirectory name and
        #  nest it under a more general "app" directory that corresponds to
        #  the "cor" directory.

    cur_app_num = 1
    cor_or_app_subdir_name = paste0 ("app", .Platform$file.sep, "app.", cur_app_num)

    do_graph_and_marxan_analysis (cor_or_app_subdir_name,

                                                #  input parameters
                                              parameters,
                                              emulatingTzar,
                                              DEBUG_LEVEL,
                                              #derived_bdpg_parameters,   #  BUG?  UNKNOWN FOR XU FROM FILE?
                                              derived_bdpg_parameters$current_os,

                                                #  parameters from gen prob.
#                                              bdprob$derived_Xu_params,
                                              bdprob@Xu_parameters,
                                              bdprob@read_Xu_problem_from_Xu_file,

    #            PU_spp_pair_names,  #NO

                                                #  From bdprob structure, i.e., results of gen prob routine
                                              cor_num_spp,
                                              cor_num_PUs,
                                              cor_PU_spp_pair_indices,
    cor_PU_IDs, #####!!!!!#####
    cor_spp_IDs,  #####!!!!!#####
                                              cor_bpm,

                            cor_PU_costs,
                                              cor_optimum_cost,
                                              cor_nodes,
                                              spp_col_name,
                                              PU_col_name,

                                                #  Immediately after bdprob struct vars above.
                                              presences_col_name, #  hard-coded as "freq"
#####!!!!!#####                                              all_correct_node_IDs,

                                                #  Results of adding error.
                                                app_num_spp,
                                                app_num_PUs,
                                              app_PU_spp_pair_indices,
                                              app_bpm,

                                                #  input parameters for error model.
                                              add_error,
                                              match_error_counts,
                                              FP_const_rate,
                                              FN_const_rate,
                                              original_FP_const_rate,
                                              original_FN_const_rate
                                              )
    } #####else    #  Don't add error.
#     {         #  Since no error is being added, correct and apparent are the same.
#
#     app_PU_spp_pair_indices      = cor_PU_spp_pair_indices
#     app_bpm                      = cor_bpm
#     }

}

#===============================================================================

