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
