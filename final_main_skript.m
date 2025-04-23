%final_main_script
%The arsonist has oddly shaped feet and
%The Human Torch was denied a bank loan


clc
clear

% Match sensativity for Root Mean Square
%match_threshold = 0.0057;

%Changed to be more precise
match_threshold = 0.005;

%plot all 55ish plots
debug=false;

% usernames = {'jose','elise','lidia','laura','kris','hutton','haden', ...
%                 'gracelyn','gabe','caleb','ben'};

% List usernames and imposters
% Took out Ben to only have 10 nominal users
usernames = {'jose','elise','lidia','laura','kris','hutton','haden', ...
                'gracelyn','gabe','caleb'};

imposters = {'sam','mark','barry','blessing'};

% declare struct for holding results
results = struct();

% === Self Testing ( all should PASS) ===
% ensure each user passes with the verifcation case (4) and test case (5)
disp('--- SELF TEST ---');
for u = 1:length(usernames)
    %pull one user
    username = usernames{u};
   
    % % generate name of files with proper format... inserts username
    % file1 = sprintf('%s_1.m4a', username);
    % file2 = sprintf('%s_2.m4a', username);
    % file3 = sprintf('%s_3.m4a', username);
    % file4 = sprintf('%s_4.m4a', username);
    % file5 = sprintf('%s_5.m4a', username);
    
    %Changed code to match Faris's File setup
    % generate name of files with proper format... inserts username
    file1 = fullfile('audio_files', [username '_audio'], sprintf('%s_1.m4a', username));
    file2 = fullfile('audio_files', [username '_audio'], sprintf('%s_2.m4a', username));
    file3 = fullfile('audio_files', [username '_audio'], sprintf('%s_3.m4a', username));
    file4 = fullfile('audio_files', [username '_audio'], sprintf('%s_4.m4a', username));
    file5 = fullfile('audio_files', [username '_audio'], sprintf('%s_5.m4a', username));

    
    % Call test function -(all five files, debug, compare_4_or_5,threshold)
    %match = test_user(file1, file2, file3, file4, file5, debug, 4, match_threshold);
    randomChoice = randi([4,5]);
    match = test_user(file1, file2, file3, file4, file5, debug, randomChoice, match_threshold);

    
    % Store result in struct under proper username
    results.(username).self = match;
end

% === Imposter Testing (all should FAIL) ===
% test every imposter against each user
disp('--- IMPOSTER TEST ---');
for i = 1:length(imposters)
    %pull one imposter
    imposter = imposters{i};
    
    for u = 1:length(usernames)
        %pull one username
        username = usernames{u};

        % % generate user file names
        % file1 = sprintf('%s_1.m4a', username);
        % file2 = sprintf('%s_2.m4a', username);
        % file3 = sprintf('%s_3.m4a', username);
        % 
        % % generate imposter file names
        % file4 = sprintf('%s_4.m4a', imposter);
        % file5 = sprintf('%s_5.m4a', imposter);


        %Changed code to match Faris's File setup
        % generate user file names
        file1 = fullfile('audio_files', [username '_audio'], sprintf('%s_1.m4a', username));
        file2 = fullfile('audio_files', [username '_audio'], sprintf('%s_2.m4a', username));
        file3 = fullfile('audio_files', [username '_audio'], sprintf('%s_3.m4a', username));

        % generate imposter file names
        file4 = fullfile('audio_files', [imposter '_audio'], sprintf('%s_4.m4a', imposter));
        file5 = fullfile('audio_files', [imposter '_audio'], sprintf('%s_5.m4a', imposter));

        % test imposter against user's profile
        %match = test_user(file1, file2, file3, file4, file5, debug, 4, match_threshold);

        % Presents the 28 test recordings at random between file 4 and 5
        randomChoice = randi([4,5]);
        match = test_user(file1, file2, file3, file4, file5, debug, randomChoice, match_threshold);


        % store result
        results.(username).(imposter) = match;
    end
end

% === Summary Output ===
disp('===VERIFICATION RESULTS ===');
%big loop cycle through each user
for u = 1:length(usernames)
    %load user - print name: endline
    username = usernames{u};
    fprintf('\nUser: %s\n', username);
    
    % print self test results
        status = results.(username).self;
        fprintf(' Self Test: %s\n', string(status));

    
    % print imposter tests
    for i = 1:length(imposters)
        %load imposter
        imposter = imposters{i};
        %
        status = results.(username).(imposter);
        verdict = "FAIL";
        if status == 1
            verdict = "PASS ---------------(should have failed: not working right)";
        end
        %print Imposters name : PASS/FAIL
        fprintf('Imposter "%s": %s\n', imposter, verdict);
    end
end

