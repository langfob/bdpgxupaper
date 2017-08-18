#===============================================================================

                        #  xu_paper_main.R

#===============================================================================

#  MOVE TO BDPG AND EXPORT

value_or_1_if_null <- function (value)
    {
    if (is.null (value)) 1 else value
    }

value_or_FALSE_if_null <- function (value)
    {
    if (is.null (value)) FALSE else value
    }

#===============================================================================

#  MOVE TO BDPG AND EXPORT

gen_single_bdprob_COR <- function (parameters,
                                   bdpg_error_codes,
                                   integerize,
                                   base_prob_name_stem = "base_prob",
                                   cor_dir_name_stem = "cor"
                                   )
    {
    exp_root_dir = file.path (normalizePath (parameters$full_output_dir_with_slash))
    Xu_bench_infile_name = parameters$infile_name
    if (is.null (Xu_bench_infile_name)) Xu_bench_infile_name = ""

    COR_Xu_bdprob =
        gen_single_bdprob_COR_from_scratch_or_Xu_bench_file (
                                exp_root_dir,
                                parameters$compute_network_metrics_COR,
                                parameters,
                                parameters$read_Xu_problem_from_Xu_bench_file,
                                Xu_bench_infile_name,
                                parameters$given_correct_solution_cost,
                                parameters$max_allowed_num_spp,
                                bdpg_error_codes,
                                integerize,
                                base_prob_name_stem = "base_prob",
                                cor_dir_name_stem = "cor"
                                )

    return (COR_Xu_bdprob)
    }

#===============================================================================

#  MOVE TO BDPG AND EXPORT

gen_single_bdprob_WRAP <- function (bdprob_to_wrap,
                                    parameters,
                                    bdpg_error_codes)
    {
    wrap_lognormal_dist_around_Xu =
        value_or_FALSE_if_null (parameters$wrap_lognormal_dist_around_Xu)

    read_Xu_problem_from_Xu_bench_file =
        value_or_FALSE_if_null (parameters$read_Xu_problem_from_Xu_bench_file)

    #---------------------------------------------------------------------------

        #----------------------------------------------------------------------
        #  Make sure that the base problem for the multiproblem is not one of
        #  Xu's benchmark problems read in from a file, since they do not
        #  contain the correct solution set.  They only contain the correct
        #  solution cost.
        #----------------------------------------------------------------------

    if (wrap_lognormal_dist_around_Xu &   #(parameters$wrap_lognormal_around_Xu &
        read_Xu_problem_from_Xu_bench_file)   # parameters$read_Xu_problem_from_Xu_file)
        {
        stop (paste0 ("\n\nParameters wrap_lognormal_dist_around_Xu and ",
                    "read_Xu_problem_from_Xu_file ",
                    "\nare both true.",
                    "\nCannot wrap around Xu problem read from file ",
                    "because dependent node IDs ",
                    "\nare never given with the file.",
                    "\nQuitting.\n\n")
            )
        }

    #---------------------------------------------------------------------------

    if (wrap_lognormal_dist_around_Xu)  #parameters$wrap_lognormal_around_Xu)
        {
        starting_dir =
            file.path (normalizePath (parameters$full_output_dir_with_slash))
            # ,
            # "wrap_prob.1")

        compute_network_metrics_for_this_prob =
            value_or_FALSE_if_null (parameters$compute_network_metrics_for_this_prob)

        WRAP_prob =
            bdpg::gen_wrapped_bdprob_COR (starting_dir,
                                          compute_network_metrics_for_this_prob,
                                          parameters,
                                          bdprob_to_wrap,
                                          bdpg_error_codes)
        } else
        {
        stop (paste0 ("\n\nwrap_lognormal_dist_around_Xu is not set to TRUE.  ",
                    "\n    It is currently the only defined wrap function.\n")
            )
        }

    return (WRAP_prob)
    }

#===============================================================================

get_bdprob_from_rds_file <- function (prob_src,
                                      cur_input_prob_idx,
                                      rds_file_set_path,
                                      rds_file_set_yaml_array,
                                      rds_file_path
                                      )
    {
    prob_src = parameters$prob_src

    if (is.null (prob_src))
        {
        cat ("\n\nERROR: no prob_src given.\n", sep='')
        quit (save="no", bdpg_error_codes$ERROR_STATUS_no_prob_src_given)

        } else if (prob_src == prob_from_rds_file)
        {
            rds_file_path = parameters$rds_file_path

            Xu_bdprob =
                load_saved_obj_from_file (normalizePath (rds_file_path))

        } else if (prob_src == prob_from_rds_file_set_from_file)
        {
            rds_file_set_path = parameters$rds_file_set_path
            rds_file_set = readLines (rds_file_set_path)

            cur_input_prob_idx = parameters$cur_input_prob_idx
            rds_file_path = rds_file_set [cur_input_prob_idx]

            Xu_bdprob =
                load_saved_obj_from_file (normalizePath (rds_file_path))

        } else if (prob_src == prob_from_rds_file_set_from_yaml_array)
        {
            rds_file_set = parameters$rds_file_set_yaml_array

            cur_input_prob_idx = parameters$cur_input_prob_idx
            rds_file_path = rds_file_set [cur_input_prob_idx]

            Xu_bdprob =
                load_saved_obj_from_file (normalizePath (rds_file_path))

        } else
        {
        cat ("\n\nERROR: unknown prob_src = '", prob_src, "'.\n", sep='')
        quit (save="no", bdpg_error_codes$ERROR_STATUS_unknown_prob_src)
        }

    return (Xu_bdprob)
    }

#===============================================================================

single_action_using_tzar_reps <- function (parameters)
    {
    gen_COR_prob  = value_or_FALSE_if_null (parameters$gen_COR_prob)
    gen_WRAP_prob = value_or_FALSE_if_null (parameters$gen_WRAP_prob)
    gen_APP_prob  = value_or_FALSE_if_null (parameters$gen_APP_prob)
    do_rsrun      = value_or_FALSE_if_null (parameters$do_rsrun)

    num_actions_chosen = gen_COR_prob + gen_WRAP_prob + gen_APP_prob +
                         do_rsrun

    if (num_actions_chosen != 1)
        stop (paste0 ("\nMust set 1 and only 1 of these variables to TRUE: ",
                      "gen_COR_prob (", gen_COR_prob, "), ",
                      "gen_WRAP_prob (", gen_WRAP_prob, "), ",
                      "gen_APP_prob (", gen_APP_prob, "), ",
                      "do_rsrun (", do_rsrun, "), ",
                      "\n"))

    #---------------------------------------------------------------------------

    if (gen_COR_prob)
        {
        bdpg::gen_single_bdprob_COR (parameters,
                                     bdpg_error_codes,
                                     integerize,
                                     base_prob_name_stem = "base_prob",
                                     cor_dir_name_stem = "cor")
        }

    #---------------------------------------------------------------------------

    if (gen_WRAP_prob)
        {
        bdprob_to_wrap =
            get_bdprob_from_rds_file (parameters$WRAP_input_prob_src,
                                      parameters$cur_input_prob_idx,
                                      parameters$WRAP_input_rds_file_set_path,
                                      parameters$WRAP_input_rds_file_set_yaml_array,
                                      parameters$WRAP_rds_file_path
                                     )

        bdpg::gen_single_bdprob_WRAP (bdprob_to_wrap,
                                      parameters,
                                      bdpg_error_codes)
        }

    #---------------------------------------------------------------------------

NEED TO DO APP NOW...

    #---------------------------------------------------------------------------

    return()
    }

#===============================================================================

gen_4_basic_variants <- function (parameters,
                                  bdpg_error_codes,
                                  integerize)
    {
cat ("\n\nAT START OF gen_4_basic_variants().\n\n")

    #===============================================================================
    #       Generate a base problem, i.e, create the Xu graph nodes and edge_list.
    #===============================================================================

        #  May need to test these parameters to see if they even exist
        #  and if they don't for this particular run, then set them to
        #  something like NULL.

    Xu_bench_file_name = parameters$Xu_bench_file_name
    if (is.null (Xu_bench_file_name)) Xu_bench_file_name = ""

    starting_dir = file.path (normalizePath (parameters$full_output_dir_with_slash))

    base_COR_bd_prob = bdpg::gen_single_bdprob_COR (starting_dir,
                                                  parameters$compute_network_metrics_COR,
                                                    parameters,
                                                    parameters$read_Xu_problem_from_Xu_bench_file,
                                                    Xu_bench_file_name,
                                                    parameters$given_correct_solution_cost,
                                                    parameters$max_allowed_num_spp,
                                                    bdpg_error_codes,
                                                    integerize)

cat ("\n\n-----  base_COR_bd_prob@UUID = '", base_COR_bd_prob@UUID,
     "', checksum = '", base_COR_bd_prob@checksum, "'  -----\n\n")

if(FALSE)
{
#####if (COR_prob_src != prob_from_rds_file)
    bdpg::do_COR_marxan_analysis_and_output (base_COR_bd_prob, parameters)

    cat("\n\njust after set_up_for_and_run_marxan() for Base COR problem")
    cat ("\n\n================================================================================")
    cat ("\n================================================================================\n\n")

    #===============================================================================
    #  Generate an APPARENT problem from the base problem, i.e., apply errors.
    #===============================================================================

    if (parameters$apply_error_to_spp_occupancy_data)
        {
        base_APP_bd_prob = bdpg::gen_single_bdprob_APP (base_COR_bd_prob,
                                                      parameters$compute_network_metrics_APP,
                                                      parameters,
                                                      bdpg_error_codes,
                                                      integerize)

        bdpg::do_APP_marxan_analysis_and_output (base_APP_bd_prob,
                                               base_COR_bd_prob,
                                               parameters)

        cat("\n\njust after set_up_for_and_run_marxan() for Base APP problem")
        cat ("\n\n================================================================================")
        cat ("\n================================================================================\n\n")
        }

    #===============================================================================
    #       Generate a wrapped problem around the base problem.
    #===============================================================================

    if (parameters$wrap_lognormal_dist_around_Xu)
        {
        wrapped_COR_bd_prob = bdpg::gen_bdprob (parameters,
                                              parameters$compute_network_metrics_wrapped_COR,
                                              bdpg_error_codes,
                                              integerize,
                                              base_COR_bd_prob)

        bdpg::do_COR_marxan_analysis_and_output (wrapped_COR_bd_prob, parameters)

        cat("\n\njust after set_up_for_and_run_marxan() for Wrapped COR problem")
        cat ("\n\n================================================================================")
        cat ("\n================================================================================\n\n")

        #-------------------------------------------------------------------------------

        #     #  Try running marxan on the base cor problem since we know that
        #     #  this particular test has created a wrapped problem.
        #     #
        #     #  Note that a different way around this issue is to create the
        #     #  cor base problem and do the analysis on it before creating
        #     #  the wrapped problem, but creating the wrap by directly passing
        #     #  the cor to it without going through gen_bdprob's superstructure.
        #
        # get_base_cor_prob_of_wrap_prob <- function ()
        #     {
        #     cat ("not implemented yet""
        #     }
        # base_COR_bd_prob = get_base_cor_prob_of_wrap_prob (COR_bd_prob)
        #
        # base_COR_marxan_ret_values = bdpg::set_up_for_and_run_marxan_COR (base_COR_bd_prob, parameters)
        #
        # marxan_control_values  = base_COR_marxan_ret_values$marxan_control_values
        # base_COR_bd_prob       = base_COR_marxan_ret_values$base_COR_bd_prob  #  COR_bd_prob has new dirs
        #
        # cat("\n\njust after set_up_for_and_run_marxan() for base cor problem")

    #===============================================================================
    #  Generate an APPARENT problem from the wrapped problem, i.e., apply errors.
    #===============================================================================

        if (parameters$apply_error_to_spp_occupancy_data)
            {
            wrapped_APP_bd_prob = bdpg::gen_single_bdprob_APP (wrapped_COR_bd_prob,
                                                             parameters$compute_network_metrics_wrapped_APP,
                                                              parameters,
                                                              bdpg_error_codes,
                                                              integerize)

            bdpg::do_APP_marxan_analysis_and_output (wrapped_APP_bd_prob,
                                                   wrapped_COR_bd_prob,
                                                   parameters)

            cat("\n\njust after set_up_for_and_run_marxan() for Wrapped APP problem")
            cat ("\n\n================================================================================")
            cat ("\n================================================================================\n\n")
            }
        }  #  end if - wrap_lognormal_dist_around_Xu

}  #  end if - FALSE

    }  #  end function - gen_4_basic_variants()

#===============================================================================

