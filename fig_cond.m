figure;

cols = {'red', 'blue'};
labels = {'reward', 'no reward'};
which = {ex.clamp == 1, ex.clamp == 0};

ax = -10:15;
clear v;
clear hh;
hold on;
for c_idx = 1:2
    ix = find(which{c_idx});
    for i = 1:length(ix)
        for j = 1:length(ax)
            t = ix(i) + ax(j);
            v(i,j) = ex.var(t);
            if ax(j) >= 0 && ax(j) < 5
                v(i,j) = NaN;
            end
        end
    end

    m = mean(v, 1);
    s = std(v, 1) / sqrt(size(v,1));
    hh(c_idx) = plot(ax, m, 'color', cols{c_idx});

    w = ax < 0;
    h = fill([ax(w) flip(ax(w))], [m(w) + s(w) flip(m(w) - s(w))], cols{c_idx});
    set(h, 'facealpha', 0.3);

    w = ax >= 5;
    h = fill([ax(w) flip(ax(w))], [m(w) + s(w) flip(m(w) - s(w))], cols{c_idx});
    set(h, 'facealpha', 0.3);
end
hold off;

legend(hh, labels);

