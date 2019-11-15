function agent = init_agent(params, a_min, a_max)
    % params(1) = s = observation noise variance = 0.01
    % params(2) = q = process/transition/diffusion noise variance = 0.1
    % params(3) = sigma = variance of basis functions (Gaussians) = 4
    % params(4) = D = # of basis functions = 10
    % params(5) = beta = UCB coefficient = 1
    % params(6) = tau = inverse softmax temperature = 10
    % params(7) = ares = action space resolution = 24

    % Init agent for Kalman filtering 

    if ~exist('a_min', 'var') || ~exist('a_max', 'var')
        a_min = -30; % min angle
        a_max = 30; % max angle
    end

    % action/angle resolution = how many (- 1) actions to tile the action space
    if exist('params', 'var') && length(params) >= 7 && ~isnan(params(7))
        ares = floor(params(7));  % TODO does mfit work with discrete vars?
        assert(ares <= 24, 'action resolution cannot be greater than 24 b/c of mvncdf');
    else
        ares = 24;
    end

    da = (a_max - a_min) / ares; % action space resolution;  mvncdf doesn't like more than 25 dimensions (see choose_Thompson and loglik_Thompson)

    % # of basis f'ns
    if exist('params', 'var') && length(params) >= 4 && ~isnan(params(4))
        D = floor(params(4)); % TODO does mfit work with discrete vars?
    else
        D = 5;
    end

    % var of basis f'ns
    if exist('params', 'var') && length(params) >= 3 && ~isnan(params(3))
        sigma = params(3);
    else
        sigma = (a_max - a_min) / D;  
    end

    sigma_n = sqrt(13.5); % sigma_e,t = std dev of motor noise; from Figure 3D (unregulated variability); pgParams.n_var ???

    assert(D > 1);
    for i = 1:D
        mu(i,:) = (a_max - a_min) * (i - 1) / (D - 1) + a_min; % mean of basis f'n i
        %basis{i} = @(a) normpdf(a, mu(i), sigma); % basis f'n i
        basis{i} = @(a) rect(a, mu(i) - da/2, mu(i) + da/2);
    end

    w = zeros(D, 1); % prior for w

    % prior variance for w 
    c = 1;
    C = c * eye(D);

    % observation noise variance / error variance
    if exist('params', 'var') && length(params) >= 1 && ~isnan(params(1))
        s = params(1);
    else
        %s = 0.01;
        s = 1;
    end

    % transition noise variance i.e. process noise variance i.e. weight diffusion/drift noise i.e. innovation variance
    if exist('params', 'var') && length(params) >= 2 && ~isnan(params(2))
        q = params(2);
    else
        %q = 0.1;
        q = 1;
    end
    Q = q * eye(D);

    % coefficient for upper confidence bound sampling
    if exist('params', 'var') && length(params) >= 5 && ~isnan(params(5))
        UCB_coef = params(5);
    else
        UCB_coef = 1;
    end

    % inverse temperature of softmax
    if exist('params', 'var') && length(params) >= 6 && ~isnan(params(6))
        inv_temp = params(6);
    else
        inv_temp = 10;
    end

    agent.a_min = a_min;
    agent.a_max = a_max;
    agent.D = D;
    agent.mu = mu;
    agent.sigma = sigma;
    agent.basis = basis;
    agent.w = w;
    agent.c = c;
    agent.C = C;
    agent.s = s;
    agent.q = q;
    agent.Q = Q;
    agent.da = da;
    agent.UCB_coef = UCB_coef;
    agent.inv_temp = inv_temp;
    agent.sigma_n = sigma_n;


   % disp(agent) % sanity check

