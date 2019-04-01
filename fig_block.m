% Figure 3 
% block clamp reward rate, plot variability as function of clamped reward rate

%clear all;
%load fig_block.mat;

function fig_block(ex, for_grid, grid_R, grid_C, grid_i, grid_j)

if ~exist('for_grid', 'var')
    for_grid = false;
end

if ~for_grid
    figure;
end

cols = {'blue', 'magenta', 'red'};
labels = {'low', 'medium', 'high'};

[ax, r_m, r_se, m, se, stats] = get_block_stats(ex);


% rewards 
%

if ~for_grid
    subplot(1,2,1);

    hold on;
    for c_idx = 1:3
        hh(c_idx) = plot(ax, r_m{c_idx}, 'color', cols{c_idx});

        h = fill([ax flip(ax)], [r_m{c_idx} + r_se{c_idx} flip(r_m{c_idx} - r_se{c_idx})], cols{c_idx});
        set(h, 'facealpha', 0.3, 'edgecolor', 'none');
    end
    hold off;

    legend(hh, labels);
    title('block reward-clamp');
    xlabel('trials in block reward-clamp');
    ylabel('reward rate');
end


% variability
%

if ~for_grid
    subplot(1,2,2);
else
    subplot(grid_R * 2, grid_C * 3, ((grid_i - 1) * 2 + 1) * grid_C * 3 + (grid_j - 1) * 3 + 3);
end



hold on;
for c_idx = 1:3
    hh(c_idx) = plot(ax, m{c_idx}, 'color', cols{c_idx});

    h = fill([ax flip(ax)], [m{c_idx} + se{c_idx} flip(m{c_idx} - se{c_idx})], cols{c_idx});
    set(h, 'facealpha', 0.3, 'edgecolor', 'none');
end
hold off;


if ~for_grid
    legend(hh, labels);
    title('variability');
    xlabel('trials in block reward-clamp');
    ylabel('variability');
else
    set(gca, 'xtick', []);
    set(gca, 'ytick', []);
end
