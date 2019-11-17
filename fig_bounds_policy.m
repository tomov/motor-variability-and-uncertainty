% fig_bounds but for policy

%clear;
%load policy_T=1_300000_nonstationary.mat; <-- wrong!
load('policy_T=100_300000.mat');

figure;
[v, b, sv, sb, sr, rr, ss] = fig_bounds_single(ex, 1, 1, actor);

stbl = table(sv, sb, sr);

fig_bounds_stats
