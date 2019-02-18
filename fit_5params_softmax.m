function results = fit_5params_softmax(rats, nstarts, data, do_save, max_trials, skip_trials)
% TODO dedupe w/ fit_6params_UCB

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

param(3).name = 'sigma'; % stdev of basis funcs 
param(3).logpdf = @(x) log(exp(-x));
param(3).lb = 0;
param(3).ub = 10;

param(4).name = 'D'; %  number of basis funcs 
param(4).logpdf = @(x) 1; % TODO make sure it works even though we discretize this
param(4).lb = 5;
param(4).ub = 25; % = max # actions de to mvncdf

param(5).name = 'tau'; %  inverse softmax temperature
param(5).logpdf = @(x) log(exp(-x)); % TODO does it make sense?
param(5).lb = 0;
param(5).ub = 10;

% non-free parameters
defaults(1).name = 'beta';
defaults(1).value = 0;

UCB_likfun = @(x, data) model_likfun(x, data, param, defaults, @loglik_UCB, max_trials, skip_trials);


tic
results = mfit_optimize(UCB_likfun, param, data(rats), nstarts);
toc

save('fit_5params_softmax.mat', '-v7.3');
