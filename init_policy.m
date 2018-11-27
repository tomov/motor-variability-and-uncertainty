function actor = init_policy()

    % Initialize actor for policy gradient

    tau = 4.9; % Figure 1F
    d = 10; % number of bins for rr = number of elements in variability control function s

    actor.sigma_e = 1; % sigma_e = std dev of exploratory variability; from pgParams.e_var0
    actor.sigma_n = sqrt(13.5); % sigma_e,t = std dev of motor noise; from Figure 3D (unregulated variability)
    actor.mu = 0; % mu_t = policy mean
    actor.alpha_mu = 0.23; % learning rate for mu
    actor.rr = 0; % average reward-rate or performance estimate (r_t bar)
    actor.alpha_r = 1 - exp(-1/tau); % learning rate for rr
    actor.s = rand(1,d) + 0.5; % variability control function sigma (word-end sigma) vector of exploratory variabilities for each (discretized) value of rr
    actor.sigma_sigma = 0.25; % parameter space variability i.e. variability of sigma_e
    actor.E_sigma = zeros(1,d); % eligibility trace for updating s
    actor.lambda = 0.9; % decay-rate of E_sigma; from pgParams.lambda
    actor.alpha_sigma = 0.05; % learning rate for s; from paper
    actor.d = d; % number of bins for rr = number of elements in variability control function s
    actor.tau = tau; % Figure 1F
