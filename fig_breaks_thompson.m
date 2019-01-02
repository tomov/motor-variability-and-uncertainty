% fig_breaks but for thompson

load thompson_300000_nonstationary_breaks.mat

figure;
[mses, vars] = fig_breaks_single(ex, 1, 1);

title('thompson sampling');
