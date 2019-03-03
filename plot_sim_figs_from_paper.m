

%filename = 'grid3_s=0.013335_q=0.048697_nsess=1000.mat';
%filename = 'grid3_s=0.010000_q=0.039242_nsess=1000.mat';
filename = 'grid3_s=0.031623_q=0.039242_nsess=1000.mat';
load(filename);

fig_cond(ex);
fig_perf(ex);
fig_block(ex);
