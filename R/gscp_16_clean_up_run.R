#===============================================================================

                        #  gscp_16_clean_up_run.R

#===============================================================================

clean_up <- function (timepoints_df, 
                      cur_timepoint_num, 
                      parameters, 
                      emulatingTzar, 
                      message="End of run..."
                      ) 
    {
    timepoints_df = timepoint (timepoints_df, "gscp_16", "Starting clean_up().")
    
    cat ("\n\n")
    sessionInfo()
    cat ("\n\n")

        #---------------------------------------------------------------------    
        #  Write the timepoints output file.
        #  NOTE: This has to come BEFORE the tzar emulation cleanup 
        #  because the directory name used to locate the output here will be 
        #  changed by the emulator cleanup.
        #---------------------------------------------------------------------    
    
    timepoints_df = timepoint (timepoints_df, "end", message)
    timepoints_df = timepoints_df [1:cur_timepoint_num,]  #  Remove excess NA lines.
    write.csv (timepoints_df, 
             file = parameters$timepoints_filename, 
             row.names = FALSE)
    
    #===========================================================================
                        #  START EMULATION CODE
    #===========================================================================

    if (emulatingTzar)
        {
        cat ("\n\nIn generateSetCoverProblem:  Cleaning up after running emulation...\n\n")
        cleanUpAfterTzarEmulation (parameters)
        }

    #===========================================================================
                        #  END EMULATION CODE
    #===========================================================================
    
    cat ("\n\nALL DONE at ", date(), "\n\n")
    }

#===============================================================================

