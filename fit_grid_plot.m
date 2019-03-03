
figure;

files = dir('*.mat');

for l = 1:length(files)
    if startsWith(files(l).name, 'grid2_')
        load(files(l).name);
        fig_cond(ex, true, length(S), length(Q), i, j, S, Q);
        fig_perf(ex, true, length(S), length(Q), i, j);
        fig_block(ex, true, length(S), length(Q), i, j);
    end
end
