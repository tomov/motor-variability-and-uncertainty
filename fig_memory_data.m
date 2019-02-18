% test whether there is "memory" for past target angles
% see if subject does better if an old target pops up again
%


load rats_all.mat;

nrats = length(ex_rats);
figure;

g = [];

y_all = [];
v_all = [];
d1_all = [];
d2_all = [];
rat_all = [];

aa_all = [];
tt_all = [];
ttar_all = [];
ttar1_all = [];
ttar2_all = [];
rrat_all = [];
for rat = 1:nrats

    stationary = 1;

    [mses, ~, ~, y, v, d1, d2, aa, tt, ttar, ttar1, ttar2] = fig_memory_single(ex_rats(rat), rat, nrats);
    title(['rat ', num2str(rat)]);

    m = [nanmean(mses{1}) nanmean(mses{2})];
    g = [g m(1) > m(2)]; % null = chance (1 = policy gradient; note we plot them flipped) 

    y_all = [y_all; y];
    v_all = [v_all; v];
    d1_all = [d1_all; d1];
    d2_all = [d2_all; d2];
    rat_all = [rat_all; repmat(rat, size(y, 1), 1)];

    aa_all = [aa_all; aa];
    tt_all = [tt_all; tt];
    ttar_all = [ttar_all; ttar];
    ttar1_all = [ttar1_all; ttar1];
    ttar2_all = [ttar2_all; ttar2];
    rrat_all = [rrat_all; repmat(rat, size(aa, 1), 1)];
end

% group-level analysis the right way
%
y = y_all; % MSE on first 20 trials after switch
v = v_all; % variance on...
d1 = d1_all; % distance from last target
d2 = d2_all; % distance from second to last target
rat = rat_all;
tbl = table(y, v, d1, d2, rat);

formula = 'y ~ 1 + d1 + d2 + (1 + d1 + d2 | rat)';

result = fitglme(tbl, formula, 'Distribution', 'Normal', 'Link', 'Identity', 'FitMethod', 'Laplace');

[beta, names, stats] = fixedEffects(result);
H = [0 0 1];
[p, F, DF1, DF2] = coefTest(result, H);
fprintf('fitglme: does distance to second-to-last target matter? %f (policy gradient predicts n.s.), p = %f, F(%d,%d) = %f\n', H * beta, p, DF1, DF2, F);

% another group-level analysis the right way
%
aa = aa_all; % action on first 20 trials after switch
tt = tt_all; % trial index after switch
ttar = ttar_all; %  target
ttar1 = ttar1_all; %  last target
ttar2 = ttar2_all; %  second to last target
rrat = rrat_all;
ttbl = table(aa, tt, ttar, ttar1, ttar2, rrat);

fformula = 'aa ~ 1 + ttar*tt + ttar1*tt + ttar2*tt + (1 + ttar*tt + ttar1*tt + ttar2*tt | rrat)';

rresult = fitglme(ttbl, fformula, 'Distribution', 'Normal', 'Link', 'Identity', 'FitMethod', 'Laplace');

[beta, names, stats] = fixedEffects(rresult);
%H = [0 0 1];
rresult
%[p, F, DF1, DF2] = coefTest(result, H);
%fprintf('fitglme: does distance to second-to-last target matter? %f (policy gradient predicts n.s.), p = %f, F(%d,%d) = %f\n', H * beta, p, DF1, DF2, F);




% group-level analysis the wrong way
%
p = binopdf(sum(g), length(g), 0.5);
g
sum(g) / length(g)
p

figure;
fig_memory_single(ex, 1, 1);
title('superrat');
