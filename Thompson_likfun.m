function loglik = Thompson_likfun(params, data)

    % log lik for data (experiment for a single rat)
    % given parameters
    % using Thompson sampling

    tic

    agent = init_agent(params, min(data.a) - 0.01, max(data.a) + 0.01);
    ex = data;

    fprintf('Evaluating Thompson_likfun for rat #%d, params ', ex.rat_idx);
    for i = 1:length(params)
        fprintf('%f ', params(i));
    end
    fprintf('\n');

    niters = min(1000, length(ex.a)); % too slow... can't do all trials
    skip = 13; % only sample lik once every skip trials

    loglik = 0;
    for t = 1:niters
       % fprintf('              %d, loglik = %f\n', t, loglik);
        a = ex.a(t);
        r = ex.r(t);
        if isnan(a) || isinf(a)
            continue
        end

        if mod(t, skip) == 0
            loglik = loglik + loglik_Thompson(agent, a);
        end
        agent = update(agent, a, r);
    end

    toc
