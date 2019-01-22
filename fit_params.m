clear all;

%data = data_to_data;
load data.mat;

nstarts = 5;

param(1).name = 'observation noise variance s';
param(1).logpdf = @(x) log(exp(-x));
param(1).lb = 0;
param(1).ub = 10;

param(2).name = 'transition noise variance q';
param(2).logpdf = @(x) log(exp(-x));
param(2).lb = 0;
param(2).ub = 10;

tic
results = mfit_optimize(@Thompson_likfun, param, data(1), nstarts);
toc

save('mfit_results_Thompson.mat', '-v7.3');
