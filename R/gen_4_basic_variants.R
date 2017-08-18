#===============================================================================

                        #  gen_4_basic_variants.R

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

    # Xu_bench_file_name = parameters$Xu_bench_file_name
    # if (is.null (Xu_bench_file_name)) Xu_bench_file_name = ""

#    starting_dir = file.path (normalizePath (parameters$full_output_dir_with_slash))

    base_COR_bd_prob = bdpg::gen_single_bdprob_COR (parameters,
                                                    bdpg_error_codes,
                                                    integerize,
                                                    base_prob_name_stem = "base_prob",
                                                    cor_dir_name_stem = "cor"
                                                    )
    # base_COR_bd_prob = bdpg::gen_single_bdprob_COR (starting_dir,
    #                                               parameters$compute_network_metrics_COR,
    #                                                 parameters,
    #                                                 parameters$read_Xu_problem_from_Xu_bench_file,
    #                                                 Xu_bench_file_name,
    #                                                 parameters$given_correct_solution_cost,
    #                                                 parameters$max_allowed_num_spp,
    #                                                 bdpg_error_codes,
    #                                                 integerize)

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

