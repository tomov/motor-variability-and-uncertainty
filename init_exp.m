function ex = init_exp()
    
    % initialize experimental structure

    ex.min = -20; % min angle
    ex.max = 20; % max angle
    ex.session_size = 300; % # trials in a session
    ex.nsessions = 1000; % # sessions
    ex.n = ex.nsessions * ex.session_size; % # trials

    ex.target = rand * (ex.max - ex.min) + ex.min; % target angle

    ex.t = 1; % trial number
    ex.done = false;
    ex.bound = 5; % target boundary; w in Ashesh's paper
    ex.r = []; % reward history
    ex.a = []; % action history
    ex.tar = []; % target history
    ex.var = []; % variability history (5-trial sliding window)
    ex.b = []; % bound history
    ex.p_reward = 0.81; % probability of getting reward if you're in reward zone = curly R in the paper = p(r=1 | -w/2<=x<=w/2)

    ex.clamp = nan(1, ex.n); % trials with clamped reward probabilities; none by default
    ex.bclamp_start = []; % starting trials for block clamps
    ex.bclamp_dur = []; % duration of block clamps
    ex.bclamp_r = []; % reward rate for block clamps
    ex.tarclamp = nan(1, ex.n); % trials with fixed targets

