function match = compare_fft_to_average(newFile, averagedFFT,match_threshold,debug)
    % This function compares a new audio file to a precomputed averaged FFT.
    % it returns root mean square error (lower = more similar). 
    % It plots forf comparison if debug mode is on.

    % load audio
    [audioData, fs] = audioread(newFile);

    % compute FFT for new waveform  
    N = length(audioData);
    fftData = fft(audioData);
    mag = abs(fftData(1:floor(N/2)+1));

    % truncate or pad to match averagedFFT length
    targetLen = length(averagedFFT);
    if length(mag) >= targetLen
        mag = mag(1:targetLen);
    else
        mag = [mag; zeros(targetLen - length(mag), 1)];
    end

    % convolve with 1000-point moving average
    smoothed = conv(mag, ones(1000, 1)/1000, 'same');
    smoothed = smoothed(1:targetLen);

    % normalize by matching peak magnitudes
    peakAvg = max(averagedFFT);
    peakTest = max(smoothed);

    % normalize
    smoothed = smoothed * (peakAvg / peakTest);
 

    % ensure both are column vectors before subtraction
    averagedFFT = averagedFFT(:);  
    smoothed = smoothed(:);

    % compute root mean square error
    diff = smoothed - averagedFFT;
    matchScore = sqrt(mean(diff.^2));

    % output match result
    if matchScore < match_threshold
        match = true;
    else 
        match = false;
    end

    % Added to help find match_threshold
    %fprintf('Match Score: %.6f | File: %s\n', matchScore, newFile);

    % debug plot
    if debug
        f = linspace(0, fs/2, targetLen);
        figure;
        plot(f, averagedFFT, 'b-', 'LineWidth', 1.5); hold on;
        plot(f, smoothed, 'r--', 'LineWidth', 1.5);
        legend('Averaged FFT', 'Test FFT');
        xlabel('Frequency (Hz)');
        ylabel('Normalized Magnitude');
        % this could be changed so it doesn't have the underscore with the
        % file name
        title(sprintf('FFT Comparison - %s (Score: %.5f)', newFile, matchScore));
        xlim([0 5000]);
        grid on;
    end
end

