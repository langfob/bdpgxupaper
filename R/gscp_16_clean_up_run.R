#===============================================================================

                        #  gscp_16_clean_up_run.R

#===============================================================================

clean_up <- function ()
    {
    cat ("\n\nIn clean_up, base R's utils::sessionInfo() =\n\n")
    print (sessionInfo())
    cat ("\n\n")
    cat ("\n\nIn clean_up, devtools's utils::session_info() =\n\n")
    print (session_info())
    cat ("\n\n")

    cat ("\n\nALL DONE at ", date(), "\n\n")
    }

#===============================================================================

