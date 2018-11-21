function [a, Qs] = choose_greedy(agent, eps)

    best.a = NaN;
    best.Q = -Inf;

    Qs = [];
    as = agent.a_min : agent.da : agent.a_max;
    for a = as
        x = activations(agent, a);
        mu = x' * agent.w; % Q-value for a

        Q = mu;
        if Q > best.Q
            best.Q = Q;
            best.a = a;
        end

        Qs = [Qs Q];
    end

    a = best.a;
    if rand < eps
        a = as(randi(length(as)));
    end

