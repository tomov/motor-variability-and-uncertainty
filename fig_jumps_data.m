% test for thompson by seeing whether farter targets have higher initial rewards 
%


load rats_all.mat;

nrats = length(ex_rats);
figure;

rs = [];

x_all = [];
y_all = [];
b_all = [];
rat_all = [];
for rat = 1:nrats

    stationary = 1;

    [r, p, x, y, b] = fig_jumps_single(ex_rats(rat), rat, nrats);
    title(['rat ', num2str(rat)]);
    rs = [rs r];

    x_all = [x_all; x];
    y_all = [y_all; y];
    b_all = [b_all; b];
    rat_all = [rat_all; repmat(rat, size(x, 1), 1)];
end

% group-level analysis the right way, for # trials to learn / switch
x = x_all;
y = y_all;
b = b_all;
rat = rat_all;
tbl = table(y, x, rat, b);

% group-level analysis for reward 
formula = 'y ~ 1 + x + b + (1 + x + b | rat)';

result = fitglme(tbl, formula, 'Distribution', 'Normal', 'Link', 'Identity', 'FitMethod', 'Laplace');

[beta, names, stats] = fixedEffects(result);
H = [0 1 0];
[p, F, DF1, DF2] = coefTest(result, H);
fprintf('fitglme (reward on first 20 trials) slope = %f (negative is policy gradient), p = %f, F(%d,%d) = %f\n', H * beta, p, DF1, DF2, F);

