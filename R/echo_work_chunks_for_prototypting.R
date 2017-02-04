#===============================================================================
#       Echo experiment sets for prototyping.
#===============================================================================

divider = function ()
    {
    cat ("\n\n================================================================================\n\n")
    }

analyze_and_archive_procedure = function ()
    {
    cat ("\n\n================================================================================")
    cat ("\n\nanalyze_and_archive procedure:")
    cat ("\n            - Compute attributes of the problem.")
    cat ("\n                - Compute generator attributes of problem (e.g., 4 Xu input parameters).")
    cat ("\n                    - Compute igraph attributes of problem.")
    cat ("\n                    - Compute bipartite attributes of problem.")
    cat ("\n            - Save the problem and its attributes, e.g, as .RDS file.")
    cat ("\n                - Should we save something about the class structure used?")
}

select_reserves_and_archive_procedure = function ()
    {
    cat ("\n\n================================================================================")
    cat ("\n\nselect_reserves_and_archive procedure:")
    cat ("\n            - Run specified reserve selector on each problem and save the results.")
    cat ("\n                - Save results as cvs file for each read and recombine")
    cat ("\n                - Save results as list for easy future rebuilding of combined outputs that don't necessarily have identical attributes")
    }

aggregate_and_summarize_procedure = function ()
    {
    cat ("\n\n================================================================================")
    cat ("\n\naggregate_and_summarize procedure:")
    cat ("\n        - Collect and display individual results")
    cat ("\n        - For each optimizer (marxan, simple richness, etc.)")
    cat ("\n            - Compute distribution characteristics, e.g., median, sd, etc.")
    }

train_and_test_procedure = function ()
    {
    cat ("\n\n================================================================================")
    cat ("\n\ntrain_and_test procedure:")
    cat ("\n        - Split into traininig, cv, and test sets (or generate new, independent test set).")
    cat ("\n        - Train and parameterize learning algorithm on training and cv sets.")
    cat ("\n        - Test learning algorithm on test sets.")
    }

redo_analysis_for_new_optimizer_procedure = function ()
    {
    cat ("\n\n================================================================================")
    cat ("\n\nredo_analysis_for_new_optimizer procedure:")
    cat ("\n        - run new optimizer over all data sets")
    cat ("\n        - summarize all scores for new optimizer")
    cat ("\n        - chunk_3_learn_to_predict_from_GENERATOR_Xu()")
    cat ("\n        - chunk_4_learn_to_predict_from_PROBLEM_Xu()")
    }

round_1_single_cor_Xu = function ()
    {
    cat ("\n\n================================================================================")
    cat ("\n\nRound 1:  Generate base set of single Xu problems of varying difficulty")
    cat ("\n\n    - Premise: We can generate problems:")
    cat ("\n            - with known optimal solutions")
    cat ("\n            - with variety of difficulties, including some very difficult")
    cat ("\n            - with non-trivial complexity (i.e., beyond the Visconti-Joppa simple problems)")
    cat ("\n            - in archival/benchmark sets allowing sharing and re-use by other researchers")
    cat ("\n\n    - Procedure:  Generate N single bdprobs with different Xu input params.")
    cat ("\n        - Randomly select most, but also choose some in the difficult region.")
    cat ("\n        - For each problem apply the analyze_and_archive procedure.")
    }

round_2_wrapped_cor_Xu = function ()
    {
    cat ("\n\n================================================================================")
    cat ("\n\nRound 2:  Re-use Round 1 results to generate base set of wrapped Xu problems")
    cat ("\n\n    - Premise: We can generate problems that match all Round 1 qualities:")
    cat ("\n            - with arbitrarily more realistic species distributions")
    cat ("\n            - and can re-use existing archived results to do it")
    cat ("\n\n    - Procedure:  Generate N problems by wrapping 1 (or more?) distributions around the existing single Xu problem set.")
    cat ("\n        - For each problem:")
    cat ("\n            - Randomly choose lognormal to wrap around original Xu problem using optimizer.")
    cat ("\n            - Apply the same analyze_and_archive procedure applied to single Xu problems in Round 1.")
    }

round_3_combined_cor_Xu = function ()
    {
    cat ("\n\n================================================================================")
    cat ("\n\nRound 3:  Re-use Rounds 1 & 2 results to generate base set of combined Xu problems")
    cat ("\n\n    - Premise: We can generate problems that match all Round 1 qualities:")
    cat ("\n            - with arbitrarily more complex and realistic species distributions")
    cat ("\n            - and can re-use existing archived results to do it")
    cat ("\n\n    - Procedure:  Generate N problems by combining  2 (or more?) single and/or wrapped Xu problems from the Round 1 and Round 2 sets.")
    cat ("\n        - For each problem:")
    cat ("\n            - Randomly choose existing problems to combine.")
    cat ("\n            - Apply the same analyze_and_archive procedure applied to single Xu problems in Round 1.")
    }

round_4_app_Xu = function ()
    {
    cat ("\n\n================================================================================")
    cat ("\n\nRound 4:  Generate set of apparent versions of each existing Xu problem")
    cat ("\n\n    - Premise: We can generate a set of problems under a range of uncertainties")
    cat ("\n            - and all of the traits of the initial set from chunk_1")
    cat ("\n\n    - Procedure:  Generate K apparent problems for each problem in the existing Xu problem sets by adding uncertainties.")
    cat ("\n        - For each problem:")
    cat ("\n            - K times:")
    cat ("\n                - Choose an error model.")
    cat ("\n                - Add randomly set uncertainty to the original Xu problem using the chosen error model.")
    cat ("\n                - Apply the same analyze_and_archive procedure applied to single Xu problems in Round 1.")
    }

round_5_select_reserves_and_summarize_performance_on_cor_Xu = function ()
    {
    cat ("\n\n================================================================================")
    cat ("\n\nRound 5:  Run reserve selector and summarize over Rounds 1-3, i.e., performance on simple and multi-problems with CORRECT data")
    cat ("\n\n    - Premise: We can characterize reserve selection performance:")
    cat ("\n            - and a range of problem difficulties exists even with CORRECT data")
    cat ("\n\n    - Procedure:  Apply aggregate_and_summarize procedure across all problems from Rounds 1-3.")
    }

round_6_select_reserves_and_summarize_performance_on_app_Xu = function ()
    {
    cat ("\n\n================================================================================")
    cat ("\n\nRound 6:  Run reserve selector and summarize over Rounds 1-3, i.e., performance on simple and multi-problems with APPARENT data")
    cat ("\n\n    - Premise: We can characterize reserve selection performance:")
    cat ("\n            - and a range of problem difficulties exists even with APPARENT data")
    cat ("\n\n    - Procedure:  Apply aggregate_and_summarize procedure across all problems from Round 4.")
    }

round_7_learn_to_predict_from_GENERATOR_on_COR_Xu = function ()
    {
    cat ("\n\n================================================================================")
    cat ("\n\nRound 7:  Learn to predict performance of each optimizer across CORRECT Xu problems based on problem GENERATOR characteristics")
    cat ("\n\n    - Premise: We can learn to predict optimizer performance based on problem GENERATOR characteristics to a certain level")
    cat ("\n            - and robustness of that prediction is indicative of how much to trust the optimizer with CORRECT data and knowledge of GENERATOR")
    cat ("\n\n    - Procedure:  ")
    cat ("\n        - Build data set of GENERATOR characteristics crossed with CORRECT problem characteristics and optimizer performance.")
    cat ("\n        - Apply train_and_test procedure")
    }

round_8_summarized_learn_to_predict_from_GENERATOR_on_COR_Xu = function ()
    {
    cat ("\n\n================================================================================")
    cat ("\n\nRound 8:  Summarize Round 7, i.e., performance on simple and multi-problems with CORRECT data")
    cat ("\n\n    - Premise: We can characterize prediction of reserve selection performance on INDIVIDUAL PROBLEMS.")
    cat ("\n\n    - Procedure:  Apply aggregate_and_summarize procedure across all problems from Round 7.")
    }

round_9_learn_to_predict_from_GENERATOR_on_APP_Xu = function ()
    {
    cat ("\n\n================================================================================")
    cat ("\n\nRound 9:  Learn to predict performance of each optimizer across APPARENT Xu problems based on problem GENERATOR characteristics")
    cat ("\n\n          Almost the same as Round 7 but possible new features re uncertainty.")
    cat ("\n\n    - Premise: We can learn to predict optimizer performance based on problem GENERATOR characteristics to a certain level")
    cat ("\n            - and robustness of that prediction is indicative of how much to trust the optimizer with CORRECT data and knowledge of GENERATOR")
    cat ("\n\n    - Procedure:  ")
    cat ("\n        - Build data set of GENERATOR characteristics crossed with CORRECT problem characteristics and optimizer performance.")
    cat ("\n        - Apply train_and_test procedure")
    }

round_10_summarized_learn_to_predict_from_GENERATOR_on_APP_Xu = function ()
    {
    cat ("\n\n================================================================================")
    cat ("\n\nRound 10:  Summarize Round 9, i.e., performance on simple and multi-problems with APPARENT data")
    cat ("\n\n           Almost the same as Round 8 but possible new features re uncertainty.")
    cat ("\n\n    - Premise: We can characterize prediction of reserve selection performance on INDIVIDUAL PROBLEMS.")
    cat ("\n\n    - Procedure:  Apply aggregate_and_summarize procedure across all problems from Round 9.")
    }

round_11_learn_to_predict_from_PROBLEM_on_COR_Xu = function ()
    {
    cat ("\n\n================================================================================")
    cat ("\n\nRound 11:  Learn to predict performance of each optimizer across CORRECT Xu problems based on problem PROBLEM characteristics")
    cat ("\n\n    - Premise: We can learn to predict optimizer performance based on problem PROBLEM characteristics to a certain level")
    cat ("\n            - and robustness of that prediction is indicative of how much to trust the optimizer with CORRECT data and knowledge of PROBLEM")
    cat ("\n\n    - Procedure:  ")
    cat ("\n        - Build data set of PROBLEM characteristics crossed with CORRECT problem characteristics and optimizer performance.")
    cat ("\n        - Apply train_and_test procedure")
    }

round_12_summarized_learn_to_predict_from_PROBLEM_on_COR_Xu = function ()
    {
    cat ("\n\n================================================================================")
    cat ("\n\nRound 12:  Summarize Round 11, i.e., performance on simple and multi-problems with CORRECT data")
    cat ("\n\n    - Premise: We can characterize prediction of reserve selection performance on INDIVIDUAL PROBLEMS.")
    cat ("\n\n    - Procedure:  Apply aggregate_and_summarize procedure across all problems from Round 11.")
    }

round_13_learn_to_predict_from_PROBLEM_on_APP_Xu = function ()
    {
    cat ("\n\n================================================================================")
    cat ("\n\nRound 13:  Learn to predict performance of each optimizer across APPARENT Xu problems based on problem PROBLEM characteristics")
    cat ("\n\n          Almost the same as Round 11 but possible new features re uncertainty.")
    cat ("\n\n    - Premise: We can learn to predict optimizer performance based on problem PROBLEM characteristics to a certain level")
    cat ("\n            - and robustness of that prediction is indicative of how much to trust the optimizer with CORRECT data and knowledge of PROBLEM")
    cat ("\n\n    - Procedure:  ")
    cat ("\n        - Build data set of PROBLEM characteristics crossed with CORRECT problem characteristics and optimizer performance.")
    cat ("\n        - Apply train_and_test procedure")
    }

round_14_summarized_learn_to_predict_from_PROBLEM_on_APP_Xu = function ()
    {
    cat ("\n\n================================================================================")
    cat ("\n\nRound 14:  Summarize Round 13, i.e., performance on simple and multi-problems with APPARENT data")
    cat ("\n\n           Almost the same as Round 8 but possible new features re uncertainty.")
    cat ("\n\n    - Premise: We can characterize prediction of reserve selection performance on INDIVIDUAL PROBLEMS.")
    cat ("\n\n    - Procedure:  Apply aggregate_and_summarize procedure across all problems from Round 13.")
    }

    #**************************************************************************
    #  This suggests that you might want to build a procedure that did all of
    #  the above analysis (other than problem generation) for a single
    #  optimizer, so that you could apply it to each of the optimizers
    #  and to any new optimizer that anyone might want to add.
    #**************************************************************************

round_15_ensemble_optimizer = function ()
    {
    cat ("\n\n================================================================================")
    cat ("\n\nRound 15:  Same as all of the above for ensemble uncertainty optimizer in place of marxan")
    cat ("\n\n    - Premise: We can build a more robust optimizer using the uncertainty ensemble.")
    }


chunk_reusable_procedures = function ()
    {
    analyze_and_archive_procedure ()
    aggregate_and_summarize_procedure ()
    train_and_test_procedure ()
    redo_analysis_for_new_optimizer_procedure ()

    divider()
    }

chunk_1_cor_Xu = function ()
    {
    round_1_single_cor_Xu()
    round_2_wrapped_cor_Xu()
    round_3_combined_cor_Xu()

    round_4_app_Xu ()

    divider()
    }

chunk_2_app_Xu = function ()
    {
    round_5_select_reserves_and_summarize_performance_on_cor_Xu()
    round_6_select_reserves_and_summarize_performance_on_app_Xu ()

    divider()
    }

chunk_3_learn_to_predict_from_GENERATOR_Xu = function ()
    {
    round_7_learn_to_predict_from_GENERATOR_on_COR_Xu()
    round_8_summarized_learn_to_predict_from_GENERATOR_on_COR_Xu()

    round_9_learn_to_predict_from_GENERATOR_on_APP_Xu()
    round_10_summarized_learn_to_predict_from_GENERATOR_on_APP_Xu()

    divider()
    }

chunk_4_learn_to_predict_from_PROBLEM_Xu = function ()
    {
    cat ("\n\nALMOST THE SAME AS CHUNK_3 GENERATOR, JUST DIFFERENT FEATURES.")

    round_11_learn_to_predict_from_PROBLEM_on_COR_Xu()
    round_12_summarized_learn_to_predict_from_PROBLEM_on_COR_Xu()

    round_13_learn_to_predict_from_PROBLEM_on_APP_Xu()
    round_14_summarized_learn_to_predict_from_PROBLEM_on_APP_Xu()

    divider()
    }

echo_work_chunks_for_prototyping = function ()
    {
    chunk_reusable_procedures ()
    chunk_1_cor_Xu ()
    chunk_2_app_Xu ()
    chunk_3_learn_to_predict_from_GENERATOR_Xu ()
    chunk_4_learn_to_predict_from_PROBLEM_Xu ()
    round_15_ensemble_optimizer ()
    divider ()
    }

#===============================================================================

