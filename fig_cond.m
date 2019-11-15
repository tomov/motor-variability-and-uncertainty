% Figure 1 from paper
% condition single trial, plot variability in reward vs. no reward

%clear all;
%load fig_cond;

function fig_cond(ex, for_grid, grid_R, grid_C, grid_i, grid_j, S, Q)


if ~exist('for_grid', 'var')
    for_grid = false;
end
if ~for_grid
    figure;
end

% actions and targets
%

if ~for_grid
    subplot(2,1,1);
else
    subplot(grid_R * 2, grid_C, (grid_i - 1) * 2 * grid_C + grid_j);
end

range = 1:10000;
hold on;
h = fill([range flip(range)], [ex.tar(range) + ex.b(range) flip(ex.tar(range) - ex.b(range))], 'red');
set(h, 'facealpha', 0.3, 'edgecolor', 'none');
plot(ex.a(range), 'o', 'color', 'black', 'markerfacecolor', 'black', 'markersize', 2);
plot(ex.tar(range), 'color', 'red');

% clamps
mini1 = find(~isnan(ex.clamp(range)) & ex.clamp(range) == 1);
plot(mini1, -29 * ones(size(mini1)), 'o', 'color', 'green', 'markerfacecolor', 'green', 'markersize', 1);
mini0 = find(~isnan(ex.clamp(range)) & ex.clamp(range) == 0);
plot(mini0, -30 * ones(size(mini0)), 'o', 'color', 'green', 'markerfacecolor', 'green', 'markersize', 1);

hold off;
if ~for_grid
    xlabel('trial');
    ylabel('press angle');
    title('targets and actions');
else
    set(gca, 'xtick', []);
    set(gca, 'ytick', []);
    if grid_i == 1
        title(sprintf('q = %.4f', Q(grid_j)));
    end
    if grid_j == 1
        ylabel(sprintf('s = %.4f', S(grid_i)));
    end
end
ylim([-30 30]);


% reward and no-reward
%


if ~for_grid
    subplot(2,2,3);
else
    subplot(grid_R * 2, grid_C * 3, ((grid_i - 1) * 2 + 1) * grid_C * 3 + (grid_j - 1) * 3 + 1);
end

cols = {'red', 'blue'};
labels = {'reward', 'no reward'};


[ax, m, se, md, sed, stats] = get_single_trial_stats(ex);

hold on;
for c_idx = 1:2
    hh(c_idx) = plot(ax, m{c_idx}, 'color', cols{c_idx});

    w = ax < 0;
    h = fill([ax(w) flip(ax(w))], [m{c_idx}(w) + se{c_idx}(w) flip(m{c_idx}(w) - se{c_idx}(w))], cols{c_idx});
    set(h, 'facealpha', 0.3, 'edgecolor', 'none');

    w = ax >= 5;
    h = fill([ax(w) flip(ax(w))], [m{c_idx}(w) + se{c_idx}(w) flip(m{c_idx}(w) - se{c_idx}(w))], cols{c_idx});
    set(h, 'facealpha', 0.3, 'edgecolor', 'none');

    %plot([0 0], [60 100], '--', 'color', [0.4 0.4 0.4]);
end
hold off;

if ~for_grid
    legend(hh, labels);
    xlabel('trials from condition');
    ylabel('variability');
    title('single conditioned trial');
else
    set(gca, 'xtick', []);
    set(gca, 'ytick', []);
end

% no-reward - reward
%

if ~for_grid
    subplot(2,2,4);

    plot(ax, md, 'color', 'black');
    hold on;

    w = ax < 0;
    h = fill([ax(w) flip(ax(w))], [md(w) + sed(w) flip(md(w) - sed(w))], [0.5 0.5 0.5]);
    set(h, 'facealpha', 0.3);

    w = ax >= 5;
    h = fill([ax(w) flip(ax(w))], [md(w) + sed(w) flip(md(w) - sed(w))], [0.5 0.5 0.5]);
    set(h, 'facealpha', 0.3);
    hold off;

    xlabel('trials from condition');
    ylabel('\Delta variability (no reward - reward)');
    title('single conditioned trial');
end
