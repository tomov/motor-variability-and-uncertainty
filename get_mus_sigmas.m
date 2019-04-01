function [mus, sigmas] = get_mus_sigmas(agent)

    % TODO dedupe w/ choice f'ns

    mus = [];
    sigmas = [];
    for a = agent.a_min : agent.da : agent.a_max
        [mu, sigma] = get_values(agent, a);

        mus = [mus, mu];
        sigmas = [sigmas, sigma];
    end
