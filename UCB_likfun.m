function [loglik, lik] = loglik_UCB(agent, chosen_a)

    % log likelihood for UCB decison based on Kalman filter values & uncertainteis
    % see choose_UCB.m
    %

    % as in loglik_Thompson, we compute the probability exactly for the chosen angle, and use the other (discretized) angles just for computing the normalization constant
    % TODO make sure this is legit (instead of finding closest legit angle)
    %[mu_chosen, sigma_chosen] = get_values(agent, chosen_a);
    %Q = mu_chosen;
    %U = sigma_chosen;
    %QU = Q + U * agent.UCB_coef; % UCB-adjusted Q-value
    
    % ...jk just find closest angle

    [~, ~, ~, ~, as, logP] = choose_UCB(agent);

    [~, idx] = min(abs(as - chosen_a));
    loglik = logP(idx);
    lik = exp(loglik);
