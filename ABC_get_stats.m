function [S, S_real] = ABC_get_stats(ex)

    % get stats for approximate Bayesian computation

    S = [];
    S_real = [];


    % single conditioned trial
    %
    [~, ~, ~, ~, ~, stats] = get_single_trial_stats(ex);

    S = [S stats];
    S_real = [S_real 31 27 2.1 30 30 4.9]; % from Fig 1E,F

    % variability control f'n
    %
    [~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, stats] = get_variability_control_stats(ex);

    S = [S stats];
    S_real = [S_real 5.3 2.4 1.3 1 0.5 0.5 0.4   20  13]; % from Fig 2C,D and Fig3D

    % block clamps
    %
    [~, ~, ~, ~, ~, stats] = get_block_stats(ex);

    S = [S stats];
    S_real = [S_real 0.4 10 2 -5 ]; % from Fig 3A,B


    % stationary context
    %
    st = round(ex.n*1/3);
    en = round(ex.n*2/3);
    ts = 1:ex.n;
    which_context = {ts <= st, ...
                     ts > st & ts <= en, ...
                     ts > en};

    for con_idx = 1:3
        [~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, stats] = get_variability_control_stats(ex, which_context{con_idx});

        switch con_idx
            case 1
                S = [S stats(end-1)];
                S_real = [S_real 26]; % from Fig 5C

            case 2
                S = [S stats(end-1)];
                S_real = [S_real 11]; % from Fig 5C

            case 3
                S = [S stats(end-1)];
                S_real = [S_real 28]; % from Fig 5C

        end
    end

