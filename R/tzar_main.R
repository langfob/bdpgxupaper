#===============================================================================
#
#                               tzar_main.R
#
#===============================================================================

#' Convenience function to run tzar with all appropriate variables set
#'
#' @return results of running tzar
#' @export
#'
#' @examples \dontrun{
#' runt ()
#'}

runt <- function ()
    {
    emulating_tzar                     = TRUE
    main_function                      = tzar_main
    project_path                       = "/Users/bill/D/Projects/ProblemDifficulty/pkgs/bdpgxupaper/R"
    emulation_scratch_file_path        = "~/tzar_emulation_scratch.yaml"
    tzar_jar_path                      = "~/D/rdv-framework-latest-work/tzar.jar"

    copy_model_R_tzar_file             = TRUE
    model_R_tzar_src_dir               = "/Users/bill/D/Projects/ProblemDifficulty/pkgs/bdpgxupaper/R"    #"."    #system.file("templates", package="bdpgxupaper")
    model_R_tzar_disguised_filename    = "model.R.tzar"
    overwrite_existing_model_R_dest    = TRUE
    required_model_R_filename_for_tzar = "model.R"

    return (
        tzar::run_tzar (
              emulating_tzar                     = emulating_tzar,
              main_function                      = main_function,
              project_path                       = project_path,
              emulation_scratch_file_path        = emulation_scratch_file_path,
              tzar_jar_path                      = tzar_jar_path,

              copy_model_R_tzar_file             = copy_model_R_tzar_file,
              model_R_tzar_src_dir               = model_R_tzar_src_dir,
              model_R_tzar_disguised_filename    = model_R_tzar_disguised_filename,
              overwrite_existing_model_R_dest    = overwrite_existing_model_R_dest,
              required_model_R_filename_for_tzar = required_model_R_filename_for_tzar
              )
            )
    }

#-------------------------------------------------------------------------------

#' Wrapper function to call your application code from tzar
#'
#' @param parameters  list of parameters built by tzar from project.yaml
#'
#' @export
#'
#' @examples \dontrun{
#' tzar_main (parameters)
#'}

tzar_main <- function (parameters)
    {
    cat ("\n\nIn tzar_main now.  parameters = \n\n")
    print (parameters)
    cat ("\n\nAll done now...\n\n")
    }

#===============================================================================
