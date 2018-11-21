function ex = init_exp()

    ex.min = -20; % min angle
    ex.max = 20; % max angle
    ex.block_size = 50; % # trials in a block
    ex.nblocks = 2000; % # blocks
    ex.n = ex.nblocks * ex.block_size; % # trials

    ex.target = rand * (ex.max - ex.min) + ex.min; % target angle

    ex.t = 1; % trial number
    ex.done = false;
    ex.bound = 5; % target boundary TODO Ashesh what was it initialized to?
    ex.r = []; % reward history
    ex.a = []; % action history
    ex.tar = []; % target history
    ex.var = []; % variability history (5-trial sliding window)
    ex.b = []; % bound history

    ex.clamp = nan(1, ex.n); % trials with clamped reward probabilities; none by default
    ex.bclamp = nan(1, ex.nblocks); % blocks with clamped rewards
    ex.tarclamp = nan(1, ex.n); % trials with fixed targets

