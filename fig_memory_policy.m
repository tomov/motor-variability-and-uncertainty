% fig_memory but for policy

load policy_T=100_300000_nonstationary.mat;

figure;
[mses, ranges, vlines, y, v, d1, d2, aa, tt, ttar, ttar1, ttar2] = fig_memory_single(ex, 1, 1);

title('policy gradient');



% another group-level analysis the right way
%
ttbl = table(aa, tt, ttar, ttar1, ttar2);

fformula = 'aa ~ 1 + ttar*tt + ttar1*tt + ttar2*tt';

rresult = fitglme(ttbl, fformula, 'Distribution', 'Normal', 'Link', 'Identity', 'FitMethod', 'Laplace');

[beta, names, stats] = fixedEffects(rresult);

rresult
