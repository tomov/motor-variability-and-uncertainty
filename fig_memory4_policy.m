% fig_memory4 but for policy

load policy_T=100_300000_nonstationary.mat;

figure;
[mses, ranges, vlines] = fig_memory4_single(ex, 1, 1);

