% test for memory by seeing whether farter targets are learned faster / slower
%


load rats_all.mat;

nrats = length(ex_rats);
figure;

rs = [];

x_all = [];
y_all = [];
rat_all = [];
for rat = 1:nrats

    stationary = 1;

    [r, p, x, y] = fig_memory2_single(ex_rats(rat), rat, nrats);
    title(['rat ', num2str(rat)]);
    rs = [rs r];

    x_all = [x_all; x];
    y_all = [y_all; y];
    rat_all = [rat_all; repmat(rat, size(x, 1), 1)];
end

% group-level analysis the right way
x = x_all;
y = y_all;
rat = rat_all;
tbl = table(y, x, rat);
formula = 'y ~ 1 + x + (1 + x | rat)';

result = fitglme(tbl, formula, 'Distribution', 'Normal', 'Link', 'Identity', 'FitMethod', 'Laplace');

[beta, names, stats] = fixedEffects(result);
H = [0 1];
[p, F, DF1, DF2] = coefTest(result, H);
fprintf('fitglme slope = %f (positive is policy gradient), p = %f, F(%d,%d) = %f\n', H * beta, p, DF1, DF2, F);



% group-level analysis the wrong way
%

frs = atanh(rs);

[h, p, ci, stats] = ttest(frs);
stats
p

figure;
[r, p] = fig_memory2_single(ex, 1, 1);
title('superrat');
r
p

