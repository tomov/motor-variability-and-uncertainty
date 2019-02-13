% test parameter recovery capabilities of model
% see https://psyarxiv.com/46mbn/

clear all;

niters = 100;

param(1).name = 'observation noise variance s';
param(1).logpdf = @(x) log(exp(-x));
param(1).lb = 0;
param(1).ub = 10;

param(2).name = 'transition noise variance q';
param(2).logpdf = @(x) log(exp(-x));
param(2).lb = 0;
param(2).ub = 10;

nstarts = 5;

x_rec = [];
x_orig = [];

for iter = 1:niters
    x(1) = rand() * 10;
    x(2) = rand() * 10;
    %params(3) = rand() * 10;
    %params(4) = floor(rand() * 20 + 5);

    fprintf('iter %d: params %f %f\n', iter, x(1), x(2));

    data = run(x); % simulate 1 rat
    data.rat_idx = 1;

    try
        tic
        results = mfit_optimize(@Thompson_likfun, param, data, nstarts);
        toc

        x_orig = [x_orig; x];
        x_rec = [x_rec; results.x];
        fprintf('                            original: %f %f, recovered: %f %f\n', x(1), x(2), results.x(1), results.x(2));
    catch e
        disp('got an error while fitting...');
        disp(e);
        % TODO might introduce correlations between parameters
    end

    save recovery.mat
end

