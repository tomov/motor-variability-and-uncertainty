function [a, Qs, Us, QUs] = choose_UCB(agent)

    best.a = NaN;
    best.QU = -Inf;

    QUs = [];
    Qs = [];
    Us = [];
    for a = agent.a_min : agent.da : agent.a_max
        x = activations(agent, a);
        mu = x' * agent.w; % Q-value for a
        sigma = sqrt(x' * agent.C * x + agent.s); % stdev for Q-value

        Q = mu;
        U = sigma; % UCB
        QU = Q + U * agent.UCB_coef; % UCB-adjusted Q-value
        if QU > best.QU
            best.QU = QU;
            best.a = a;
        end

        QUs = [QUs QU];
        Qs = [Qs Q];
        Us = [Us U];
    end

    a = best.a;
