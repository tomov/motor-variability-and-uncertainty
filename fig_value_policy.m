% fig_value but for policy

%load policy_T=1_300000_nonstationary.mat; <-- wrong
load('policy_T=100_300000.mat');

%rs =  [0.1 0.35 0.75]; % all blocks
rs =  [0.35]; % middle blocks only

figure;
[m, dvars, PEs, r, rr, vars] = fig_value_single(ex, 1, 1, rs, 'policy gradient');



% group-level analysis the right way
%
dvar = dvars;
var = vars;
PE = PEs;
tbl = table(dvar, PE, r, rr, var);


fig_value_stats;
