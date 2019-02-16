% convert rat data with all sessions to exp like init_exp
% that we can analyze with our scripts
% same as rat_to_exp_blocks but for all sessions (incl block clamps)
%
function ex = rat_to_exp_allsess(rat)
    load('from_paper/sessData.mat');

    tar = [sessData{rat}.Target];

    b = ([sessData{rat}.Upper] - [sessData{rat}.Lower]) / 2;
    nsess = length(tar);


    sess_size = 300; % approximate...
    ex.session_size = sess_size;
    ex.nsessions = nsess;
    ex.n = ex.nsessions * ex.session_size;


    % create experiment from data
    %
    ex.tar = inf(1, sess_size * nsess); % trial-by-trial target
    ex.b = inf(1, sess_size * nsess); % trial-by-trial boundary
    ex.a = inf(1, sess_size * nsess); % trial-by-trial action / angle of animal
    ex.r = inf(1, sess_size * nsess); % trial-by-trial reward
    ex.clamp = inf(1, sess_size * nsess); % trial-by-trial mini reward clamps
    ex.bclamp_start = [];
    ex.bclamp_dur = [];
    ex.bclamp_r = [];

    t = 0;
    for s = 1:nsess
        a = sessData{rat}(s).angs;
        r = sessData{rat}(s).rewards;
        clamp = nan(size(a));

        % mini clamps
        which_mini_clamps = sessData{rat}(s).inMiniClamp;
        clamp(which_mini_clamps) = r(which_mini_clamps);

        % block clamps
        if ~isnan(sessData{rat}(s).RewardProb)
            which_block_clamps = sessData{rat}(s).inBlockClamp;
            clamp(which_block_clamps) = sessData{rat}(s).RewardProb;

            ex.bclamp_start = [ex.bclamp_start min(find(which_block_clamps))];
            ex.bclamp_dur = [ex.bclamp_dur sum(which_block_clamps)];
            ex.bclamp_r = [ex.bclamp_r sessData{rat}(s).RewardProb];
        end

        for i = 1:length(a)
            t = t + 1;
            ex.tar(t) = tar(s);
            ex.a(t) = a(i);
            ex.b(t) = b(s);
            ex.r(t) = r(i);
            ex.clamp(t) = clamp(i);

            if t >= 5
                ex.var(t) = var(ex.a(t-4:t));
            else
                ex.var(t) = NaN;
            end
        end

        if s < nsess
            t1 = datevec(datenum(sessData{rat}(s).startTime));
            t2 = datevec(datenum(sessData{rat}(s + 1).startTime));
            ex.breaks(t) = etime(t2, t1) / 3600; % time to next session in hours TODO convert to trials TODO subtract duration of session s
        end
    end

    ex.rat_idx = rat;
    ex.is_stationary = false;
    ex.there_are_blocks = true;

end
