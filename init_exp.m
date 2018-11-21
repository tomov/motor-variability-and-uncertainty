function ex = init_exp()

    ex.min = -20; % min angle
    ex.max = 20; % max angle
    ex.n = 200; % # trials

    %ex.target = rand * (ex.max - ex.min) + ex.min; % target angle
    ex.target = 0;

    ex.t = 1; % trial number
    ex.done = false;
    ex.bound = 5; % target boundary TODO Ashesh what was it initialized to?
    ex.r = []; % reward history
    ex.a = []; % action history
    ex.tar = []; % target history
    ex.var = []; % variability history (5-trial sliding window)
    ex.b = []; % bound history
    ex.r_clamp = logical([]); % reward clamp single trials 
    ex.nor_clamp = logical([]); % no-reward clamp single trials

