function loglik = Thompson_likfun(params, data)

    % log lik for data (experiment for a single rat)
    % given parameters
    % using Thompson sampling

    agent = init_agent(params);
    ex = data;

    fprintf('Evaluating Thompson_likfun for rat #%d\n', ex.rat_idx);

    loglik = 0;
    for t = 1:length(ex.a)
        fprintf('              %d\n', t);
        a = ex.a(t);
        r = ex.r(t);

        loglik = loglik + loglik_Thompson(agent, a);
        agent = update(agent, a, r);
    end
