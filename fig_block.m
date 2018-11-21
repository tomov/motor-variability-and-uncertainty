figure;

cols = {'blue', 'magenta', 'red'};
labels = {'low', 'medium', 'high'};
which = {ex.bclamp == 0.1, ex.bclamp == 0.5, ex.bclamp == 0.9};

ax = -ex.block_size/2 : ex.block_size*3/2;
clear v;
hold on;
for c_idx = 1:3
    bs = find(which{c_idx});
    for i = 1:length(bs)
        b = bs(i);
        s = (b - 1) * ex.block_size;
        for j = 1:length(ax)
            t = s + ax(j);
            v(i,j) = ex.var(t);
        end
    end

    v = mean(v, 1);
    plot(ax, v, 'color', cols{c_idx});
end
hold off;

legend(labels);

