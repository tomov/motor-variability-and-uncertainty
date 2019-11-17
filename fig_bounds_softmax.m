% fig_bounds but for softmax 


%load softmax_300000.mat
load softmax_grid1_sigma=dx1.5_s=10.000000_q=100.000000_nsess=10000.mat

figure;
[v, b, sv, sb, sr] = fig_bounds_single(ex, 1, 1);

stbl = table(sv, sb, sr);

fig_bounds_stats
