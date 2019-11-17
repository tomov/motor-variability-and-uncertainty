% fig_memory but for softmax (copy of thompson)

%load softmax_300000.mat
load softmax_grid1_sigma=dx1.5_s=10.000000_q=100.000000_nsess=10000.mat

figure;
[mses, ranges, vlines, y, v, d1, d2, aa, tt, ttar, ttar1, ttar2] = fig_memory_single(ex, 1, 1);


title('thompson sampling');



% another group-level analysis the right way
%
ttbl = table(aa, tt, ttar, ttar1, ttar2);

fformula = 'aa ~ 1 + ttar*tt + ttar1*tt + ttar2*tt';

rresult = fitglme(ttbl, fformula, 'Distribution', 'Normal', 'Link', 'Identity', 'FitMethod', 'Laplace');

[beta, names, stats] = fixedEffects(rresult);

rresult
