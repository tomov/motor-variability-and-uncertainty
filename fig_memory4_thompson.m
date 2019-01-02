% fig_memory4 but for thompson

load thompson_300000_nonstationary.mat

figure;
[mses, ranges, vlines] = fig_memory4_single(ex, 1, 1);

