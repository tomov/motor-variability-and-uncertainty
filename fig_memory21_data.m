% test for memory by seeing whether farter targets are learned faster / slower
%


load rats_all.mat;

nrats = length(ex_rats);
figure;

g = [];

b_all = [];
y_all = [];
rat_all = [];
for rat = 1:nrats

    stationary = 1;

    [r, m, b, y] = fig_memory21_single(ex_rats(rat), rat, nrats);
    title(['rat ', num2str(rat)]);

    g = [g m(1) < m(2)]; % null = chance (1 = policy gradient)

    b_all = [b_all; b];
    y_all = [y_all; y];
    rat_all = [rat_all; repmat(rat, size(b, 1), 1)];
end


% group-level analysis the right way
%
b = b_all;
y = y_all;
rat = rat_all;
tbl = table(y, b, rat);

formula = 'y ~ 1 + b + (1 + b | rat)';

result = fitglme(tbl, formula, 'Distribution', 'Normal', 'Link', 'Identity', 'FitMethod', 'Laplace');

[beta, names, stats] = fixedEffects(result);
H = [0 -1 1 0 0 0 0 0 0];
[p, F, DF1, DF2] = coefTest(result, H);
fprintf('fitglme: far > close = %f (positive is policy gradient), p = %f, F(%d,%d) = %f\n', H * beta, p, DF1, DF2, F);



% group-level analysis the wrong way
%
p = binopdf(sum(g), length(g), 0.5);
g
sum(g) / length(g)
p

figure;
fig_memory21_single(ex, 1, 1);
title('superrat');
