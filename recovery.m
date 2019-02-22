% test parameter recovery capabilities of model
% see https://psyarxiv.com/46mbn/
function recovery(niters, nstarts, fit_fun, choice_fun, rand_fun, max_trials, skip_trials)

% example call
% recovery(100, 5, @fit_4params_Thompson, @() [rand*10, rand*10, 4, 10, 1, 10, 4])

filename = sprintf('recovery_iters=%d_nstarts=%d_fitfun=%s_randfun=%s_3k.mat', niters, nstarts, func2str(fit_fun), func2str(rand_fun));
disp(filename)

x_rec = [];
x_orig = [];

if ~exist('max_trials', 'var')
    max_trials = 3000;
end

if ~exist('skip_trials', 'var')
    skip_trials = 1;
end

for iter = 1:niters
    x = rand_fun();

    fprintf('iter %d: generated params: ', iter);
    for i = 1:length(x)
        fprintf('%f ', x(i));
    end
    fprintf('\n');

    data = run(x, choice_fun, ceil(max_trials / 300)); % simulate 1 rat
    data.rat_idx = 1;
    data.N = length(data.a); % for mfit

    try
        tic
        results = fit_fun(1, nstarts, data, false, max_trials, skip_trials);
        toc

        x_orig = [x_orig; x];
        x_rec = [x_rec; results.x];
        fprintf('                            original: %f %f, recovered: %f %f\n', x(1), x(2), results.x(1), results.x(2));
    catch e
        disp('got an error while fitting...');
        disp(e);
        % TODO might introduce correlations between parameters
        rethrow(e); % rethrow for now
    end

    save(filename, '-v7.3'); % save after each iter, just in case
end

