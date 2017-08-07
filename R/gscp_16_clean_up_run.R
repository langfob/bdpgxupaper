#===============================================================================

                        #  gscp_16_clean_up_run.R

#===============================================================================

clean_up_console_sink_if_necessary <-
    function (tzar_emulation_flag_and_console_sink_information)
    {
    emulatingTzar =
        tzar_emulation_flag_and_console_sink_information$emulatingTzar

    echoConsoleToTempFile =
        tzar_emulation_flag_and_console_sink_information$echoConsoleToTempFile

    tempConsoleOutFile =
        tzar_emulation_flag_and_console_sink_information$tempConsoleOutFile

    cat ("\n\nIn clean_up_tzar_emulation:\n")
    cat ("    emulatingTzar         = ", emulatingTzar, "\n")
    cat ("    echoConsoleToTempFile = ", echoConsoleToTempFile, "\n")
    if (is.null (tempConsoleOutFile))
        cat ("    tempConsoleOutFile is NULL\n")

        #  If you were echoing console output to a temp file,
        #  stop echoing and close the temp file.

    if (emulatingTzar & echoConsoleToTempFile)
        {
        cat ("\nClosing sink file.\n")

        sink()
        if (! is.null (tempConsoleOutFile))  close (tempConsoleOutFile)
        }
    }

#===============================================================================

clean_up <- function (tzar_emulation_flag_and_console_sink_information)
    {
    clean_up_console_sink_if_necessary (
                            tzar_emulation_flag_and_console_sink_information)

    cat ("\n\nIn clean_up, sessionInfo() =\n\n")
    print (sessionInfo())
    cat ("\n\n")

    cat ("\n\nALL DONE at ", date(), "\n\n")
    }

#===============================================================================

