function [ax, m, se, md, sed, stats] = get_single_trial_stats(ex)

%which = {~isnan(ex.clamp) & ex.r == 1, ~isnan(ex.clamp) & ex.r == 0}; %<-- this is weird! the reward / no-reward trials are dependent b/c of the block clamps; try e.g. load data_allsess.mat; fig_cond(data(1))
which = {ex.clamp == 1, ex.clamp == 0};

ax = -10:15;
clear v;
clear hh;
clear n;
clear m;
clear s;
clear se;
hold on;
for c_idx = 1:2
    ix = find(which{c_idx});
    v = nan(length(ix), length(ax));
    for i = 1:length(ix)
        for j = 1:length(ax)
            t = ix(i) + ax(j);
            if t > length(ex.var)
                break
            end
            v(i,j) = ex.var(t);
            if ax(j) >= 0 && ax(j) < 5
                v(i,j) = NaN;
            end
        end
    end

    n{c_idx} = size(v, 1);
    m{c_idx} = nanmean(v, 1);
    s{c_idx} = nanstd(v, 1);
    se{c_idx} = nanstd(v, 1) / sqrt(size(v,1));
    m{c_idx}(m{c_idx} == 0) = NaN; % to deal w/ real data...
    %hh(c_idx) = plot(ax, m{c_idx}, 'color', cols{c_idx});

    %w = ax < 0;
    %h = fill([ax(w) flip(ax(w))], [m{c_idx}(w) + se{c_idx}(w) flip(m{c_idx}(w) - se{c_idx}(w))], cols{c_idx});
    %set(h, 'facealpha', 0.3, 'edgecolor', 'none');

    %w = ax >= 5;
    %h = fill([ax(w) flip(ax(w))], [m{c_idx}(w) + se{c_idx}(w) flip(m{c_idx}(w) - se{c_idx}(w))], cols{c_idx});
    %set(h, 'facealpha', 0.3, 'edgecolor', 'none');

    %plot([0 0], [60 100], '--', 'color', [0.4 0.4 0.4]);
end

md = m{2} - m{1};
sed = sqrt(s{1}.^2 + s{2}.^2) / sqrt(n{1} + n{2}); 


y = md(ax >= 5);
x = 1:length(y);
F0 = fit(x', y', 'exp1');
b = coeffvalues(F0);
tau = - 1/b(2);

        % no reward    % reward        % diff       % no rew baseline   % rew baseline  % tau
stats = [m{2}(ax == 5)  m{1}(ax == 5)  md(ax == 5)  m{2}(ax == -1)      m{1}(ax == -1)   tau];
