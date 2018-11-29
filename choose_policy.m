function [x, eps_e, eps_sigma] = choose_policy(actor)

    % choose action (angle) x based on policy gradient algorithm
    % also returns the exploratory variability eps_e and the parameter space variability eps_sigma

    eps_sigma = normrnd(0, actor.sigma_sigma); % parameter space variability
    bin = floor(actor.d * actor.rr) + 1; % which bin does the reward rate r bar fall into
    sigma_e = actor.s(bin) + eps_sigma; % stdev of exploratory variability
    sigma_e = max(sigma_e, 0); % ensure sigma_e is >= 0

    eps_e = normrnd(0, sigma_e); % exploratory variability
    eps_n = normrnd(0, actor.sigma_n); % motor noise

    x = actor.mu + eps_e + eps_n;
