
figure;

files = dir('*.mat');

for l = 1:length(files)
    if startsWith(files{l}, 'grid1_')
        load(files{l});
        fig_cond(true, length(S), length(Q), i, j);
        fig_perf(true, length(S), length(Q), i, j);
        fig_block(true, length(S), length(Q), i, j);
    end
end
