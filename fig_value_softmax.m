% fig_value but for UCB 

%load softmax_300000.mat
load softmax_grid1_sigma=dx1.5_s=10.000000_q=100.000000_nsess=10000.mat

%figure;
%fig_value_single(ex, 1, 1, 'softmax');


%rs =  [0.1 0.35 0.75]; % all blocks
rs =  [0.35]; % middle blocks only

figure;
[m, dvars, PEs, r, rr, vars] = fig_value_single(ex, 1, 1, rs, 'softmax');





% group-level analysis the right way
%
dvar = dvars;
var = vars;
PE = PEs;
tbl = table(dvar, PE, r, rr, var);

fig_value_stats;
