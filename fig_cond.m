figure;

cols = {'red', 'blue'};
labels = {'reward', 'no reward'};
which = {ex.r_cond, ex.nor_cond};

ax = -10:30;
clear v;
hold on;
for c_idx = 1:2
    ix = find(which{c_idx});
    for i = 1:length(ix)
        for j = 1:length(ax)
            t = ix(i) + ax(j);
            v(i,j) = ex.var(t);
            if abs(ax(j)) <= 2
                v(i,j) = NaN;
            end
        end
    end

    v = mean(v, 1);
    plot(ax, v, 'color', cols{c_idx});
end
hold off;

legend(labels);

