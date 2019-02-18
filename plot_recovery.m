% first e.g. load 'recovery_iters=100_nstarts=5_fitfun=fit_3params_softmax_randfun=@()[rand*10,rand*10,4,10,0,rand*10].mat'

k = size(x_rec, 2);

param_name = {'s', 'q', 'sigma', 'D', 'beta', 'tau'};

figure;

for j = 1:k
    subplot(4,2,j);

    i = find(strcmp(results.param(j).name, param_name));
    scatter(x_orig(:,i), x_rec(:,j));
    lsline;
    xlabel('original');
    ylabel('recovered');
    title(param_name{i});

    [r, p] = corr(x_orig(:,i), x_rec(:,j));
    fprintf('%s: r = %f, p = %f\n', param_name{i}, r, p);
end
