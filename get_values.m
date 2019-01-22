function [mu, sigma] = get_values(agent, a)

    % get value distribution N(mu, sigma^2) for given action a
    %

    x = activations(agent, a);
    mu = x' * agent.w; % Q-value for a
    sigma = sqrt(x' * agent.C * x + agent.s); % stdev for Q-value
