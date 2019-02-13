function [a, mus, sigmas] = choose_Thompson(agent)

    % Thompson sampling decison based on Kalman filter values & uncertainteis

    best.a = NaN;
    best.Q = -Inf;
    mus = [];
    sigmas = [];

    for a = agent.a_min : agent.da : agent.a_max
        [mu, sigma] = get_values(agent, a);

        Q = normrnd(mu, sigma); % Q ~ N(mu, sigma)
        if Q > best.Q
            best.Q = Q;
            best.a = a;
        end
        mus = [mus, mu];
        sigmas = [sigmas, sigma];
    end

    a = best.a;

    % uncontrolled variability -- do we even need it?
    %a = a + normrnd(0, agent.sigma_n);
    %a = min(a, agent.a_max);
    %a = max(a, agent.a_min);
