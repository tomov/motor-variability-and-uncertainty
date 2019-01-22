function [a, Qs, Us] = choose_Thompson(agent)

    % Thompson sampling decison based on Kalman filter values & uncertainteis

    best.a = NaN;
    best.Q = -Inf;
    Qs = [];
    Us = [];

    for a = agent.a_min : agent.da : agent.a_max
        [mu, sigma] = get_values(agent, a);

        Q = normrnd(mu, sigma); % Q ~ N(mu, sigma)
        U = sigma; % UCB
        if Q > best.Q
            best.Q = Q;
            best.a = a;
        end
        Qs = [Qs Q];
        Us = [Us U];
    end

    a = best.a;

    % uncontrolled variability -- do we even need it?
    %a = a + normrnd(0, agent.sigma_n);
    %a = min(a, agent.a_max);
    %a = max(a, agent.a_min);
