% fig_memory2 but for thompson

load thompson_300000_nonstationary.mat
%load kalman_300000_nonstationary.mat

figure;
[r, p] = fig_memory2_single(ex, 1, 1);

r
p

