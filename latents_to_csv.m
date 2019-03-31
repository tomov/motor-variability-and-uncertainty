%function csv = data_to_csv
    % convert Ashesh's data to csv's for Eric

    load('from_paper/task_learn_curves (1).mat', 'targs');
    nrats = size(targs, 1);


    for rat = 1:nrats
        rat
        stationary = 1; % non stationary

        ex = rat_to_exp_allsess(rat);

        load('thompson_s=0.013335_q=0.031623_nsess=10000.mat', 'agent');

        M = [];
        S = [];
        for t = 1:length(ex.a)
           % fprintf('              %d, loglik = %f\n', t, loglik);
            a = ex.a(t);
            r = ex.r(t);
            if isnan(a) || isinf(a)
                continue
            end

            [mus, sigmas] = get_mus_sigmas(agent);
            if isempty(M)
                M = nan(length(ex.a), length(mus));
                S = nan(length(ex.a), length(mus));
            end
            M(t,:) = mus;
            S(t,:) = sigmas;

            agent = update(agent, a, r);
        end

        tbl = table(ex.tar', ex.b', ex.a', ex.r', ex.clamp', ex.breaks', M, S, 'VariableNames', {'target', 'boundary', 'action', 'reward', 'clamp', 'break_duration', 'mu', 'sigma'});
        filename = fullfile('eric', sprintf('rat%d.csv', rat));
        writetable(tbl, filename, 'WriteRowNames', true);

        tbl = table(ex.bclamp_start', ex.bclamp_dur', ex.bclamp_r', 'VariableNames', {'start', 'duration', 'reward'});
        filename = fullfile('eric', sprintf('rat%d_blocks.csv', rat));
        writetable(tbl, filename, 'WriteRowNames', true);
    end

