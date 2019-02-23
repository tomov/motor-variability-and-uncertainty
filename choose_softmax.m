function [a, Qs, Us, QUs, as, logP] = choose_softmax(agent)

    % softmax decison based on Kalman filter values

    Qs = [];
    as = [];
    for a = agent.a_min : agent.da : agent.a_max
        [mu, sigma] = get_values(agent, a);

        Q = mu;

        as = [as a];
        Qs = [Qs Q];
    end

    logP = agent.inv_temp * Qs; % choice prob \propto exp(inv_temp * Q)
    logP = logP - logsumexp(logP); % normalize
    P = exp(logP);
    P = P / sum(P); % do it again... b/c sometimes still doesn't sum to 1; and then we get NaNs...

    choice = mnrnd(1, P);
    assert(~any(isnan(choice(1))), 'P does not sum to 1 and mvrnd fails');
    a = as(find(choice));
