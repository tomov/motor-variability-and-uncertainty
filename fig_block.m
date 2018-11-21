% Figure 3
%

clear all;
load fig_block.mat;

figure;

cols = flip({'blue', 'magenta', 'red'});
labels = flip({'low', 'medium', 'high'});
which = flip({ex.bclamp == 0.1, ex.bclamp == 0.5, ex.bclamp == 0.9});

ax = -ex.block_size/2 : ex.block_size*3/2;

% rewards 
%

subplot(1,2,1);

clear r;
hold on;
for c_idx = 1:3
    bs = find(which{c_idx});
    for i = 1:length(bs)
        b = bs(i);
        s = (b - 1) * ex.block_size;
        for j = 1:length(ax)
            t = s + ax(j);
            r(i,j) = ex.r(t);
        end
    end

    m = mean(r, 1);
    s = std(r, 1);
    se = s / sqrt(size(r, 1)); 
    hh(c_idx) = plot(ax, m, 'color', cols{c_idx});

    h = fill([ax flip(ax)], [m + se flip(m - se)], cols{c_idx});
    set(h, 'facealpha', 0.3);
end
hold off;

legend(hh, labels);
title('block reward-clamp');
xlabel('trials in block reward-clamp');
ylabel('reward rate');


% variability
%

subplot(1,2,2);

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

    m = mean(v, 1);
    s = std(v, 1);
    se = s / sqrt(size(v, 1)); 
    hh(c_idx) = plot(ax, m, 'color', cols{c_idx});

    h = fill([ax flip(ax)], [m + se flip(m - se)], cols{c_idx});
    set(h, 'facealpha', 0.3);
end
hold off;

legend(hh, labels);
title('variability');
xlabel('trials in block reward-clamp');
ylabel('\Delta variability');
