% fig_jumps but for policy

%load policy_T=100_300000_nonstationary.mat;
load policy_T=1_300000_nonstationary.mat;

figure;
[r, p] = fig_jumps_single(ex, 1, 1);

r
p
