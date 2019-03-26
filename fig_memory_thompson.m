% fig_memory but for thompson

%load('archive/thompson_300000_nonstationary.mat');
%load Thompson_300000.mat
load grid3_s=0.013335_q=0.031623_nsess=1000.mat

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
