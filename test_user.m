function [match] = test_user(audio_1, audio_2, audio_3, audio_4, audio_5, debug, is4or5, match_threshold)
% this function calculates the users average fft using the first 
% three sound profiles. Then compares a fourth file against the filtered
% wave. It outputs wether or not the the user matched the conditioned
% user profile via root mean square error.
  
    % use first three wave forms to generate user profile.
    test_profile = plot_avg_fft_of_three(audio_1, audio_2, audio_3, debug);

    % inject proper user file for next function call
    if is4or5 == 5
        test_audio = audio_5;
    else
        test_audio = audio_4;
    end

    % condition the test wave and compare against the user profile
    match = compare_fft_to_average(test_audio, test_profile, match_threshold, debug);
end