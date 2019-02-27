% test for thompson by seeing whether angles that haven't been sampled in a while are more likely to be chosen after omission trials 
%


load rats_all_sess.mat;

nrats = length(ex_rats);
figure;

rs = [];

x_all = [];
y_all = [];
b_all = [];
rat_all = [];
for rat = 1:nrats

    stationary = 1;

    [y] = fig_sampled_single(ex_rats(rat), rat, nrats);
    title(['rat ', num2str(rat)]);

    y_all = [y_all; y];
    rat_all = [rat_all; repmat(rat, size(y, 1), 1)];
end

save fig_sampled_data.mat

% group-level analysis the right way
y = y_all;
rat = rat_all;
tbl = table(y, rat);


formula = 'y ~ 1 + (1 | rat)';

result = fitglme(tbl, formula, 'Distribution', 'Normal', 'Link', 'Identity', 'FitMethod', 'Laplace');

[beta, names, stats] = fixedEffects(result);
H = [1];
[p, F, DF1, DF2] = coefTest(result, H);
fprintf('fitglme intercept = %f (positive is good), p = %f, F(%d,%d) = %f\n', H * beta, p, DF1, DF2, F);

