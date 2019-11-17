% fig_bounds but for thompson

%load thompson_300000_nonstationary.mat
%load thompson_300000.mat
load thompson_s=0.013335_q=0.031623_nsess=10000.mat;
%load('archive/thompson_300000_nonstationary.mat');

figure;
[v, b, sv, sb, sr] = fig_bounds_single(ex, 1, 1);

stbl = table(sv, sb, sr);

fig_bounds_stats
