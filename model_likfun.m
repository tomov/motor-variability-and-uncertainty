function loglik = model_likfun(x, data, param, defaults, loglik_fun, max_trials, skip_trials)

    % generic function to compute the log likelihood for the choices of a single rat (data == ex, as output by run.m)
    %
    % look up to trial # max_trials
    % skipping every skip_trials
    % ...basically, subsample the choices
    % loglik_func is the single-trial likelihood function that takes an agent (i.e. current state of learning) and the action it took 

    % note param = the struct for mfit with free parameter names, bounds, etc (we use it to figure out which params were passed)
    %      x = the free parameter values (that end up in results.x); subset of all parameters
    %      params = all parameters (free and non-free) passed to the agent, with values from x and default values where appropriate
    %      defaults = default to use for non-free parameters, if different than built-in defaults

    names = {'s', 'q', 'sigma', 'D', 'beta', 'tau', 'ares'};

    params = nan(1, 7);  % nan = use default value

    % free params
    for i = 1:length(param)
        idx = find(strcmp(param(i).name, names));
        assert(~isempty(idx), sprintf('no parameter %s', param(i).name));
        params(idx) = x(i);
    end

    % non-free params
    for i = 1:length(defaults)
        idx = find(strcmp(defaults(i).name, names));
        assert(~isempty(idx), sprintf('no parameter %s', param(i).name));
        assert(~ismember(defaults(i).name, {param.name}), sprintf('parameter %s is both free and not free', defaults(i).name));
        params(idx) = defaults(i).value;
    end

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
