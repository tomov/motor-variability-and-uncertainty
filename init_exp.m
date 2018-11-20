function ex = init_exp()

    ex.min = -20; % min angle
    ex.max = 20; % max angle
    ex.n = 100; % # trials
    ex.target = rand * (ex.max - ex.min) + ex.min; % target angle
    ex.t = 1; % trial number
    ex.done = false;
    ex.r = []; % reward history
    ex.a = []; % action history
    ex.tar = []; % target history
    ex.bound = 5; % target boundary TODO Ashesh what was it initialized to?

