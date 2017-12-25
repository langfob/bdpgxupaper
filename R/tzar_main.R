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

tzar_main <- function (parameters, emulating_tzar=FALSE)
    {
    cat ("\n\nIn tzar_main now.\n\n")

#    cat ("\n    parameters = \n\n")
#    print (parameters)

    xu_paper_main (parameters, emulating_tzar)

    cat ("\n\nAll done now...\n\n")
    }

#===============================================================================

#' Convenience function to call run_tzar without having to enter arguments
#'
#' @return Returns nothing
#' @export
#'
#' @examples \dontrun{
#' runt ()
#'}

runt <- function ()
    {
    tzar::run_tzar (main_function = tzar_main,
              parameters_yaml_file_path = "./R/project.yaml",
#              tzar_emulation_yaml_file_path = "./R/tzar_emulation.yaml")
              tzar_emulation_yaml_file_path = "/Users/bill/D/Projects/ProblemDifficulty/pkgs/bdpgxupaper/R/tzar_emulation.yaml")
    }

#===============================================================================
