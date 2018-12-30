function actor = init_policy()

    % Initialize actor for policy gradient

    tau = 4.9; % 4.9 in Figure 1F, but pgParams.tau = 5.1 TODO ashesh?
    %d = 10; % number of bins for rr = number of elements in variability control function s
    d = 7;  % based on Figure 4B in paper
    T = 10; % time horizon for eligibility trace (1 = short timescale, 100 = long timescale; 10 based on pgParams.lambda)

    actor.sigma_e = 1; % sigma_e = std dev of exploratory variability; from pgParams.e_var0
    actor.sigma_n = sqrt(13.5); % sigma_e,t = std dev of motor noise; from Figure 3D (unregulated variability); pgParams.n_var ???
    actor.mu = 0; % mu_t = policy mean
    actor.alpha_mu = 0.23; % learning rate for mu TODO pgParams.a_A?
    actor.rr = 0; % average reward-rate or performance estimate (r_t bar)
    actor.alpha_r = 1 - exp(-1/tau); % learning rate for rr; pgParams.a_R
    actor.s = rand(1,d) + 0.5; % variability control function sigma (word-end sigma) vector of exploratory variabilities for each (discretized) value of rr
    actor.sigma_sigma = 0.25; % parameter space variability i.e. variability of sigma_e (from paper)
    actor.E_sigma = zeros(1,d); % eligibility trace for updating s
    actor.lambda = 1 - 1/T; % decay-rate of E_sigma; depends on time horizon T (1 or 100 trials); also see pgParams.lambda
    actor.alpha_sigma = 0.05; % learning rate for s; from paper; pgParams.a_var
    actor.d = d; % number of bins for rr = number of elements in variability control function s
    actor.tau = tau; % Figure 1F
    actor.T = T; % time horizon for eligibility trace

    % variability regulation functions from Figure 4B
    actor.s_T1 = sqrt([51 4 0.01 0.01 0.01 0.01 0.01]); % optimal variability regulation function for short timescales (T = 1) -- from Figure 4B
    actor.s_T100 = sqrt([61 18 6 4 3 1 0.01]); % optimal variability regulation function for long timescales (T = 100) -- from Figure 4B
