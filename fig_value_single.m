% test, for block clamps, whether direction of variability change depends on current value
% copied stuff from fig_block.m

function fig_value_single(ex, rat, nrats, figtitle)

ax = -30 : 130;

r = [0.35]; % medium blocks only, for now

cols = {'blue', 'red'};
labels = {'PE > 0', 'PE < 0'};


bix = find(ex.bclamp_r == r);
clear v;
clear vv;
cnt = {0, 0};
for i = 1:length(bix)
    s = ex.bclamp_start(bix(i));
    rr = mean(ex.r(s-10:s-1)); % value TODO maybe more weighted towards recent rewards?

    if rr < r
        k = 1; % higher-than-expected value
    else
        k = 2; % lower-than-expected value
    end
    cnt{k} = cnt{k} + 1;

    for j = 1:length(ax)
        t = s + ax(j);
        v{k}(cnt{k},j) = ex.var(t);
    end
    vv{k}(cnt{k}) = mean(v{k}(cnt{k},ax >= 0 & ax <= 10));
    
end



subplot(2, nrats, rat);

hold on;
for k = 1:2
    m = mean(v{k}, 1);
    s = std(v{k}, 1);
    se = s / sqrt(size(v{k}, 1)); 
    hh(k) = plot(ax, m, 'color', cols{k});

    h = fill([ax flip(ax)], [m + se flip(m - se)], cols{k});
    set(h, 'facealpha', 0.3, 'edgecolor', 'none');
end
hold off;
xlabel('trials in (medium) block reward-clamp');
ylabel('variability');
if ~exist('figtitle', 'var')
    title(['rat ', num2str(rat)]);
else
    title(figtitle);
end
legend(hh, labels);


subplot(2, nrats, rat + nrats);

clear m;
clear s;
clear se;
for k = 1:2
    m(k) = mean(vv{k});
    s(k) = std(vv{k});
    se(k) = s(k) / sqrt(length(vv{k})); 
end

bar(m)
hold on;
errorbar(m, se, 'LineStyle', 'none', 'color', 'black');
hold off;
xticklabels(labels);
ylabel('variability');
xlabel('first 10 trials after switch');
