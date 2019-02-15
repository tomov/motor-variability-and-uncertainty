function [a, Qs, Us, QUs, as, logP] = choose_UCB(agent)

    % UCB decison based on Kalman filter values & uncertainteis
    % passes it through softmax

    QUs = [];
    Qs = [];
    Us = [];
    as = [];
    for a = agent.a_min : agent.da : agent.a_max
        [mu, sigma] = get_values(agent, a);

        Q = mu;
        U = sigma; % UCB
        QU = Q + U * agent.UCB_coef; % UCB-adjusted Q-value

        QUs = [QUs QU];
        as = [as a];
        Qs = [Qs Q];
        Us = [Us U];
    end

    logP = agent.inv_temp * QUs; % choice prob \propto exp(inv_temp * Q)
    logP = logP - logsumexp(logP); % normalize
    P = exp(logP);

    a = as(find(mnrnd(1, P)));
