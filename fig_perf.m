% Figure 2
% plot single-trial variability effect (fig_cond) as function of (recent) past performance = performance estimate

%clear all;
%load fig_cond.mat

function fig_perf(ex, for_grid, grid_R, grid_C, grid_i, grid_j)

if ~exist('for_grid', 'var')
    for_grid = false;
end
if ~for_grid
    figure;
end

blue = [0 0 1];
red = [1 0 0];

[ax, lb, ub, md, sed, vd, vsd, vn, vsed, cvd, cvsed, stats] = get_variability_curve_stats(ex);

save tmp.mat

for bin = 1:length(md)
    color{bin} = blue * (7 - bin)/6 + red * (bin - 1) / 6;

    if ~for_grid
        subplot(3,4,bin+1);
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
        title(sprintf('%.2f-%.2f', lb(bin), ub(bin)));

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
    subplot(3,4,9);
else
    subplot(grid_R * 2, grid_C * 3, ((grid_i - 1) * 2 + 1) * grid_C * 3 + (grid_j - 1) * 3 + 2);
end

xs = (lb + ub)/2;
hold on;
for bin = 1:length(lb)
    h = bar(xs(bin), vd(bin), 0.08);
    set(h, 'facecolor', color{bin});
end
errorbar(xs, vd, vsed, 'color', 'black', 'linestyle', 'none');
hold off;
xlim([-0.05 1.05]);

if ~for_grid
    xlabel('performance estimate');
    ylabel('\Delta variability');
else
    ylim([-1 8]);
    set(gca, 'xtick', []);
    set(gca, 'ytick', []);
end



if ~for_grid

    subplot(3,4,10);
    errorbar(xs, cvd, cvsed, 'color', 'black');
    ylim([0 25]);
    %ylim([0 500]);
    %ylim([-5 40]);
    xlabel('performance estimate');
    ylabel('regulated variability');
end
