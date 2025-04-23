function averagedFFT = plot_avg_fft_of_three(file1, file2, file3, debug)
    % This function computes the average FFT magnitude spectrum of three audio files.
    % Each audio file is loaded and normalized, transformed using FFT, then
    % truncated to the shortest spectrum length
    % The resulting average spectrum is then smoothed using a 1000-point moving average.
    % If `debug` is true, the averaged and smoothed FFT is also plotted.

    %initialize
    % variable holding file names
    files = {file1, file2, file3};
    %cell array to store FFT magnitudes
    specs = cell(1, 3);         
    % store lengths of each FFT magnitude vector
    lengths = zeros(1, 3);          

    for i = 1:3
        % read audio file
        [audioData, fs] = audioread(files{i});

        % compute FFT magnitude and normalize
        N = length(audioData);
        fftData = fft(audioData);
        % keep only non-redundant half of spectrum
        mag = abs(fftData(1:floor(N/2)+1));  
        % normalize
        mag = mag / max(mag);            

        % store results
        specs{i} = mag;
        lengths(i) = length(mag);
    end

    % truncate all FFT magnitudes to the shortest length before averaging
    %find shortest waveform
    minLen = min(lengths);
    % initialize to length of shortes
    truncatedSpecs = zeros(3, minLen);
    % perform truncation
    for i = 1:3
        truncatedSpecs(i, :) = specs{i}(1:minLen);
    end

    % compute average magnitude spectrum
    avgMag = mean(truncatedSpecs, 1);

    % apply 1000-point moving average for smoothing
    averagedFFT = conv(avgMag, ones(1000, 1) / 1000, 'same');
end
