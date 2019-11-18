% test for thompson by seeing whether angles that haven't been sampled in a while are more likely to be chosen after omission trials 
%


load thompson_s=0.013335_q=0.031623_nsess=10000.mat;

[y] = fig_sampled_single(ex, 1, 1);


formula = 'y ~ 1';

result = fitglme(tbl, formula, 'Distribution', 'Normal', 'Link', 'Identity', 'FitMethod', 'Laplace');

[beta, names, stats] = fixedEffects(result);
H = [1];
[p, F, DF1, DF2] = coefTest(result, H);
fprintf('fitglme intercept = %f (positive is good), p = %f, F(%d,%d) = %f\n', H * beta, p, DF1, DF2, F);

