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

ax = -30 : 130;

rs = [0.1 0.35 0.75];

% rewards 
%

if ~for_grid
    subplot(1,2,1);

    hold on;
    for c_idx = 1:3
        bix = find(ex.bclamp_r == rs(c_idx));
        clear r;
        for i = 1:length(bix)
            s = ex.bclamp_start(bix(i));
            d = ex.bclamp_dur(bix(i));
            e = s + d - 1;
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
    bix = find(ex.bclamp_r == rs(c_idx));
    clear v;
    for i = 1:length(bix)
        s = ex.bclamp_start(bix(i));
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
    set(h, 'facealpha', 0.3, 'edgecolor', 'none');
end
hold off;

if ~for_grid
    legend(hh, labels);
    title('variability');
    xlabel('trials in block reward-clamp');
    ylabel('\Delta variability');
else
    set(gca, 'xtick', []);
    set(gca, 'ytick', []);
end
