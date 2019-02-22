% fit parameters of given model
% see recovery.m
function fit_params(nstarts, fit_fun, max_trials, skip_trials)

% example call
% fit_params(5, @fit_4params_Thompson, 3000, 10)

if ~exist('max_trials', 'var')
    max_trials = 3000;
end

if ~exist('skip_trials', 'var')
    skip_trials = 1;
end

filename = sprintf('fit_params_nstarts=%d_fitfun=%s_max=%d_skip=%d.mat', nstarts, func2str(fit_fun), max_trials, skip_trials);
disp(filename)

load data.mat

results = fit_fun(1, nstarts, data, true, max_trials, skip_trials);

save(filename, '-v7.3'); % save after each iter, just in case

