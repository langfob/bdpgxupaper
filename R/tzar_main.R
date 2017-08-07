#===============================================================================
#
#                               tzar_main.R
#
#===============================================================================

#' Wrapper function to call your application code from tzar
#'
#' @param parameters List of parameters controlling the current run (usually
#'   decoded from project.yaml by tzar)
#'
#' @return Returns nothing
#' @export
#'
#' @examples \dontrun{
#' tzar_main (parameters)
#'}

tzar_main <- function (parameters)
    {
    cat ("\n\nIn tzar_main now.\n\n")

#    cat ("\n    parameters = \n\n")
#    print (parameters)

    xu_paper_main (parameters)

    cat ("\n\nAll done now...\n\n")
    }

#===============================================================================
