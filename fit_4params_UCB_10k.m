function results = fit_4params_UCB(rats, nstarts, data, do_save, max_trials, skip_trials)


if ~exist('nstarts', 'var')
    nstarts = 5;
end

if ~exist('data', 'var')
    %data = data_to_data;
    load data.mat;
end

if ~exist('rats', 'var')
    rats = 1:length(data);
end

if ~exist('do_save', 'var')
    do_save = true;
end

if ~exist('max_trials', 'var')
    max_trials = 10000;
end

if ~exist('skip_trials', 'var')
    skip_trials = 1;
end

% IMPORTANT -- names must match those in model_likfun.m
% we use them to figure out which param gets plugged where
% that way we can fit a subset of parameters and use defaults for the rest

% free parameters
param(1).name = 's'; % observation noise variance 
param(1).logpdf = @(x) -x / 10;
param(1).lb = 0;
param(1).ub = 10000;

param(2).name = 'q'; % transition noise variance 
param(2).logpdf = @(x) -x / 10;
param(2).lb = 0;
param(2).ub = 10000;

param(3).name = 'beta'; % UCB coefficient
param(3).logpdf = @(x) -x;
param(3).lb = 0;
param(3).ub = 10;

param(4).name = 'tau'; % inverse softmax temperature
param(4).logpdf = @(x) -x; % TODO does it make sense?
param(4).lb = 0;
param(4).ub = 10;

UCB_likfun = @(x, data) model_likfun(x, data, param, [], @loglik_UCB, max_trials, skip_trials);


tic
results = mfit_optimize(UCB_likfun, param, data(rats), nstarts);
toc

save('fit_4params_UCB_10k.mat', '-v7.3');
