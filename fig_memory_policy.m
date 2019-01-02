% fig_memory but for policy

load policy_T=100_300000_nonstationary.mat;

figure;
[mses, ranges, vlines] = fig_memory_single(ex, 1, 1);

title('policy gradient');
