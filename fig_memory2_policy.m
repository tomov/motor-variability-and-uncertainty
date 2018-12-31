% fig_memory2 but for policy

load policy_T=100_300000_nonstationary.mat;

figure;
[r, p] = fig_memory2_single(ex, 1, 1);

r
p
