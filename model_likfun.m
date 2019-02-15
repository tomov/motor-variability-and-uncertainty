function loglik = model_likfun(params, data, loglik_fun, max_trials, skip_trials)

    % generic function to compute the log likelihood for the choices of a single rat (data == ex, as output by run.m)
    %
    % look up to trial # max_trials
    % skipping every skip_trials
    % ...basically, subsample the choices
    % loglik_func is the single-trial likelihood function that takes an agent (i.e. current state of learning) and the action it took 

    tic

    agent = init_agent(params, min(data.a) - 0.01, max(data.a) + 0.01);
    ex = data;

    fprintf('Evaluating %s for rat #%d (max trials = %d, skip_trials = %d), params ', func2str(loglik_fun), ex.rat_idx, max_trials, skip_trials);
    for i = 1:length(params)
        fprintf('%f ', params(i));
    end
    fprintf('\n');

    niters = min(max_trials, length(ex.a)); % too slow... can't do all trials

    loglik = 0;
    for t = 1:niters
       % fprintf('              %d, loglik = %f\n', t, loglik);
        a = ex.a(t);
        r = ex.r(t);
        if isnan(a) || isinf(a)
            continue
        end

        if mod(t, skip_trials) == 0  % only sample lik once every skip trials
            loglik = loglik + loglik_fun(agent, a);
        end
        agent = update(agent, a, r);
    end

    toc
