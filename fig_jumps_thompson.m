% fig_jumps but for thompson

%load thompson_300000_nonstationary.mat
load thompson_300000.mat

figure;
[r, p] = fig_jumps_single(ex, 1, 1);

r
p

