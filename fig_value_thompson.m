% fig_value but for thompson

%load('archive/thompson_300000_nonstationary.mat');
%load('Thompson_300000.mat');
load grid3_s=0.013335_q=0.031623_nsess=1000.mat

%rs =  [0.1 0.35 0.75]; % all blocks
rs =  [0.35]; % middle blocks only

figure;
[m, dvars, PEs, r, rr, vars] = fig_value_single(ex, 1, 1, rs, 'thompson sampling');





% group-level analysis the right way
%
dvar = dvars;
var = vars;
PE = PEs;
tbl = table(dvar, PE, r, rr, var);

fig_value_stats;
