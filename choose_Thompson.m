function [a, Qs] = choose_Thompson(agent)

    best.a = NaN;
    best.Q = -Inf;
    Qs = [];

    for a = agent.a_min : agent.da : agent.a_max
        x = activations(agent, a);
        mu = x' * agent.w; % Q-value for a
        sigma = x' * agent.C * x + agent.s; % stdev for Q-value

        Q = normrnd(mu, sigma); % Q ~ N(mu, sigma)
        if Q > best.Q
            best.Q = Q;
            best.a = a;
        end
        Qs = [Qs Q];
    end

    a = best.a;
