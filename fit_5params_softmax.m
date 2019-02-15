function results = fit_5params_softmax(rats, nstarts, data, do_save)
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

param(1).name = 'observation noise variance s';
param(1).logpdf = @(x) log(exp(-x));
param(1).lb = 0;
param(1).ub = 10;

param(2).name = 'transition noise variance q';
param(2).logpdf = @(x) log(exp(-x));
param(2).lb = 0;
param(2).ub = 10;

param(3).name = 'stdev of basis funcs sigma';
param(3).logpdf = @(x) log(exp(-x));
param(3).lb = 0;
param(3).ub = 10;

param(4).name = 'number of basis funcs D';
param(4).logpdf = @(x) 1; % TODO make sure it works even though we discretize this
param(4).lb = 5;
param(4).ub = 25; % = max # actions de to mvncdf

% const
param(5).name = 'UCB coefficient'; % set to 0 for pure softmax
param(5).logpdf = @(x) log(exp(-x));
param(5).lb = 0;
param(5).ub = 0;

param(6).name = 'inverse softmax temperature';
param(6).logpdf = @(x) log(exp(-x)); % TODO does it make sense?
param(6).lb = 0;
param(6).ub = 100;

UCB_likfun = @(params, data) model_likfun(params, data, @loglik_UCB, 1000, 13);

tic
results = mfit_optimize(UCB_likfun, param, data(rats), nstarts);
toc

save('fit_5params_softmax.mat', '-v7.3');
