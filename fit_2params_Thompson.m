function results = fit_2params_Thompson(rats, nstarts, data, do_save, max_trials, skip_trials)



if ~exist('data', 'var')
    %data = data_to_data;
    load data.mat;
end

if ~exist('rats', 'var')
    rats = 1:length(data);
end

if ~exist('nstarts', 'var')
    nstarts = 5;
end

if ~exist('do_save', 'var')
    do_save = true;
end

if ~exist('max_trials', 'var')
    max_trials = 10000;
end

if ~exist('skip_trials', 'var')
    skip_trials = 10000;
end

% IMPORTANT -- names must match those in model_likfun.m
% we use them to figure out which param gets plugged where
% that way we can fit a subset of parameters and use defaults for the rest

% free parameters
param(1).name = 's'; % observation noise variance 
param(1).logpdf = @(x) log(exp(-x));
param(1).lb = 0;
param(1).ub = 1;

param(2).name = 'q'; % transition noise variance 
param(2).logpdf = @(x) log(exp(-x));
param(2).lb = 0;
param(2).ub = 1;

Thompson_likfun = @(x, data) model_likfun(x, data, param, [], @loglik_Thompson, max_trials, skip_trials);

tic
results = mfit_optimize(Thompson_likfun, param, data(rats), nstarts);
toc

if do_save
    save('fit_2params_Thompson.mat', '-v7.3');
end
