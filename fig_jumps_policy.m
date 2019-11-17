% fig_jumps but for policy

%load policy_T=1_300000_nonstationary.mat; <-- wrong
load('policy_T=100_300000.mat');

figure;
[r, p] = fig_jumps_single(ex, 1, 1);

r
p
