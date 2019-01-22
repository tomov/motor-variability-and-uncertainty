function agent = init_agent(params)

    % Init agent for Kalman filtering 

    a_min = -20; % min angle
    a_max = 20; % max angle
    da = (a_max - a_min) / 24; % action space resolution;  mvncdf doesn't like more than 25 dimensions (see choose_Thompson and loglik_Thompson)

    % # of basis f'ns
    if exist(params, 'var') && length(params) >= 4
        D = params(4);
    else
        D = 10;
    end

    % var of basis f'ns
    if exist(params, 'var') && length(params) >= 3
        sigma = params(3);
    else
        sigma = (a_max - a_min) / D; 
    end

    sigma_n = sqrt(13.5); % sigma_e,t = std dev of motor noise; from Figure 3D (unregulated variability); pgParams.n_var ???

    assert(D > 1);
    for i = 1:D
        mu(i,:) = (a_max - a_min) * (i - 1) / (D - 1) + a_min; % mean of basis f'n i
        basis{i} = @(a) normpdf(a, mu(i), sigma); % basis f'n i
    end

    w = zeros(D, 1); % prior for w

    % prior variance for w 
    c = 1;
    C = c * eye(D);

    % observation noise variance
    if exist(params, 'var') && length(params) >= 1
        s = param(1);
    else
        s = 0.01;
    end

    % transition noise variance i.e. weight diffusion/drift noise
    if exist(params, 'var') && length(params) >= 2
        q = param(2)
    else
        q = 0.1;
    end
    Q = q * eye(D);


    UCB_coef = 1; % coefficient for upper confidence bound sampling

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
    agent.sigma_n = sigma_n;

