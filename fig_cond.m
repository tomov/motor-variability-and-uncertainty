% Figure 1 from paper
% condition single trial, plot variability in reward vs. no reward

%clear all;
%load fig_cond;


figure;

% actions and targets
%

subplot(2,1,1);
range = 1:10000;
hold on;
h = fill([range flip(range)], [ex.tar(range) + ex.b(range) flip(ex.tar(range) - ex.b(range))], 'red');
set(h, 'facealpha', 0.3, 'edgecolor', 'none');
plot(ex.a(range), 'o', 'color', 'black', 'markerfacecolor', 'black', 'markersize', 2);
plot(ex.tar(range), 'color', 'red');
hold off;
xlabel('trial');
ylabel('press angle');
title('targets and actions');


% reward and no-reward
%

subplot(2,2,3);

cols = {'red', 'blue'};
labels = {'reward', 'no reward'};
%which = {~isnan(ex.clamp) & ex.r == 1, ~isnan(ex.clamp) & ex.r == 0}; <-- this is weird! the reward / no-reward trials are dependent b/c of the block clamps
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
    for i = 1:length(ix)
        for j = 1:length(ax)
            t = ix(i) + ax(j);
            v(i,j) = ex.var(t);
            if ax(j) >= 0 && ax(j) < 5
                v(i,j) = NaN;
            end
        end
    end

    n{c_idx} = size(v, 1);
    m{c_idx} = mean(v, 1);
    s{c_idx} = std(v, 1);
    se{c_idx} = std(v, 1) / sqrt(size(v,1));
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

legend(hh, labels);
xlabel('trials from condition');
ylabel('variability');
title('single conditioned trial');

% no-reward - reward
%

subplot(2,2,4);

md = m{2} - m{1};
sed = sqrt(s{1}.^2 + s{2}.^2) / sqrt(n{1} + n{2}); 

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
