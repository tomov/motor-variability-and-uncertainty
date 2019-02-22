%function csv = data_to_csv
    % convert Ashesh's data to csv's for Eric

    load('from_paper/task_learn_curves (1).mat', 'targs');
    nrats = size(targs, 1);

    for rat = 1:nrats
        rat
        stationary = 1; % non stationary

        ex = rat_to_exp_allsess(rat);

        tbl = table(ex.tar', ex.b', ex.a', ex.r', ex.clamp', ex.breaks', 'VariableNames', {'target', 'boundary', 'action', 'reward', 'clamp', 'break_duration'});
        filename = fullfile('eric', sprintf('rat%d.csv', rat));
        writetable(tbl, filename, 'WriteRowNames', true);

        tbl = table(ex.bclamp_start', ex.bclamp_dur', ex.bclamp_r', 'VariableNames', {'start', 'duration', 'reward'});
        filename = fullfile('eric', sprintf('rat%d_blocks.csv', rat));
        writetable(tbl, filename, 'WriteRowNames', true);
    end

