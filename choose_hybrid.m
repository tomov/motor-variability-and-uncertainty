function [a, QUs] = choose_hybrid(agent)

    best.a = NaN;
    best.QU = -Inf;
    QUs = [];

    for a = agent.a_min : agent.da : agent.a_max
        x = activations(agent, a);
        mu = x' * agent.w; % Q-value for a
        sigma = x' * agent.C * x + agent.s; % stdev for Q-value

        U = sqrt(sigma); % UCB
        QU = normrnd(mu, sigma) + U * agent.UCB_coef; % Q ~ N(mu, sigma) + UCB
        if QU > best.QU
            best.QU = QU;
            best.a = a;
        end
        QUs = [QUs QU];
    end

    a = best.a;
