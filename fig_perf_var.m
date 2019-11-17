% Figure 2 but as f'n of previous 2 clamps
% plot single-trial variability effect (fig_cond) as function of (recent) past performance = performance estimate
% TODO copy of fig_perf

%clear all;
%load fig_cond.mat

function fig_perf_var(ex, for_grid, grid_R, grid_C, grid_i, grid_j)

if ~exist('for_grid', 'var')
    for_grid = false;
end
if ~for_grid
    figure;
end

blue = [0 0 1];
red = [1 0 0];

[ax, labels, md, sed, vd, vsd, vn, vsed, cvd, cvsed, stats] = get_variability_control_stats_var(ex);

for bin = 1:length(md)
    color{bin} = blue * (7 - bin)/6 + red * (bin - 1) / 6;

    if ~for_grid
        subplot(2,4,bin);
        plot(ax, md{bin}, 'color', color{bin});
        hold on;

        w = ax < 0;
        h = fill([ax(w) flip(ax(w))], [md{bin}(w) + sed{bin}(w) flip(md{bin}(w) - sed{bin}(w))], color{bin});
        set(h, 'facealpha', 0.3, 'edgecolor', 'none');

        w = ax >= 5;
        h = fill([ax(w) flip(ax(w))], [md{bin}(w) + sed{bin}(w) flip(md{bin}(w) - sed{bin}(w))], color{bin});
        set(h, 'facealpha', 0.3, 'edgecolor', 'none');
        hold off;

        ylim([-2 10]);
        %ylim([-25 150]);
        %ylim([-5 20]);
        title(labels{bin});

        if bin == 6
            xlabel('trials from condition');
        end
        if bin == 1
            ylabel('\Delta variability (no reward - reward)');
        end
    end
end


% plot population plot (Figure 2C)
%
if ~for_grid
    subplot(2,4,5);
else
    subplot(grid_R * 2, grid_C * 3, ((grid_i - 1) * 2 + 1) * grid_C * 3 + (grid_j - 1) * 3 + 2);
end

xs = (1:length(labels))/length(labels);
hold on;
for bin = 1:length(labels)
    h = bar(xs(bin), vd(bin), 0.08);
    set(h, 'facecolor', color{bin});
end
xticks(xs);
xticklabels(labels);
errorbar(xs, vd, vsed, 'color', 'black', 'linestyle', 'none');
hold off;
xlim([-0.05 1.05]);

if ~for_grid
    xlabel('prev 2 clamps');
    ylabel('\Delta variability');
else
    ylim([-1 8]);
    set(gca, 'xtick', []);
    set(gca, 'ytick', []);
end



if ~for_grid

    subplot(2,4,6);
    errorbar(xs, cvd, cvsed, 'color', 'black');
    ylim([0 35]);
    %ylim([0 500]);
    %ylim([-5 40]);
    xticks(xs);
    xticklabels(labels);
    xlabel('prev 2 clamps');
    ylabel('regulated variability');
end
