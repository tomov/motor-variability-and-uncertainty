% plot results from fit_grid

figure;

files = dir('*.mat');

for l = 1:length(files)
    %if startsWith(files(l).name, 'gridA1_')
    %if startsWith(files(l).name, 'hybrid_grid1_')
    %if startsWith(files(l).name, 'softmax_grid1')
    if startsWith(files(l).name, 'UCB_grid1_')
        load(files(l).name);
        fig_cond(ex, true, length(S), length(Q), i, j, S, Q);
        fig_perf(ex, true, length(S), length(Q), i, j);
        fig_block(ex, true, length(S), length(Q), i, j);
    end
end
