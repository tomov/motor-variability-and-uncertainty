% test, for block clamps, whether direction of variability change depends on current value
% copied stuff from fig_block.m

function [m, dvars, PEs, block_reward, reward_rate_before_block, vars] = fig_value_single(ex, rat, nrats, rs, figtitle)

ax = -30 : 130;

%rs = [0.1 0.35 0.75];
%rs = [0.35 ];

cols = {'blue', 'red'};
labels = {'PE > 0', 'PE < 0'};

dvars = [];
vars = [];
PEs = [];
block_reward = [];
reward_rate_before_block = [];


bix = find(ismember(ex.bclamp_r, rs));
clear v;
clear vv;
cnt = {0, 0};
for i = 1:length(bix)
    s = ex.bclamp_start(bix(i));
    rr = nanmean(ex.r(s-20:s-1)); % value TODO maybe more weighted towards recent rewards?
    r = ex.bclamp_r(bix(i));

    if rr < r
        k = 1; % higher-than-expected value
    else
        k = 2; % lower-than-expected value
    end
    cnt{k} = cnt{k} + 1;

    for j = 1:length(ax)
        t = s + ax(j);
        if t > length(ex.var)
            break
        end
        v{k}(cnt{k},j) = ex.var(t);
        a{k}(cnt{k},j) = ex.a(t);
    end

    %dvar = nanmean(v{k}(cnt{k},ax >= 0 & ax <= 10)) -  nanmean(v{k}(cnt{k},ax >= -10 & ax <= -1)); % technically should be 5 vs. -1 (b/c var is over 5 trials)
    %dvar = nanmean(v{k}(cnt{k},ax >= 5 & ax <= 15)) -  nanmean(v{k}(cnt{k},ax >= -10 & ax <= -1)); % <-------- YESSS!!!
    dvar = nanvar(a{k}(cnt{k},ax >= 0 & ax <= 20)) - nanvar(a{k}(cnt{k},ax >= -20 & ax <= -1)); % FUCK YES..... ......fuck no => wrong; 
    variability = nanvar(a{k}(cnt{k},ax >= 0 & ax <= 80)); % not delta

    dv{k}(cnt{k}) = dvar; 
    vv{k}(cnt{k}) = variability; 
    %vv{k}(cnt{k}) = nanmean(v{k}(cnt{k},ax >= 5 & ax <= 5)) -  nanmean(v{k}(cnt{k},ax >= -1 & ax <= -1)); % technically should be 5 vs. -1 (b/c var is over 5 trials)
   
    vars = [vars; variability];
    dvars = [dvars; dvar];
    PEs = [PEs; r - rr];
    block_reward = [block_reward; r];
    reward_rate_before_block = [reward_rate_before_block; rr];
end



subplot(2, nrats, rat);

hold on;
for k = 1:2
    m = nanmean(v{k}, 1);
    s = nanstd(v{k}, 1);
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
    m(k) = nanmean(vv{k});
    s(k) = nanstd(vv{k});
    se(k) = s(k) / sqrt(length(vv{k})); 
end

bar(m)
hold on;
errorbar(m, se, 'LineStyle', 'none', 'color', 'black');
hold off;
xticklabels(labels);
%xtickangle(30);
ylabel('Variability');
xlabel('first 80 trials after switch');
%ylabel('\Delta variability');
%xlabel({'first 10 trials after switch - ', 'last 10 trials before switch'});

save wtf.mat
