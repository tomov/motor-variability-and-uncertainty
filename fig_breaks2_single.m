% test if variability at session start is correlated with break duration before session 
%
function [r, p, v, b, m] = fig_breaks2_single(ex, rat, nrats)

which = ex.breaks ~= 0 & ~isnan(ex.breaks);
trials = find(which);

v = [];
b = [];
m = [];
for t = trials

    vv = nanvar(ex.a(t+1:t+20));
    mse = nanmean((ex.tar(t+1:t+20) - ex.a(t+1:t+20)).^2);
    if ~isnan(vv)
        v = [v; vv];
        b = [b; ex.breaks(t)];
        m = [m; mse];
    end
end

%b = log(b); % b/c skewed towards 0 ; nvm we do it manually later

subplot(1, nrats, rat);
scatter(b, v);
lsline;
xlabel('break duration');
ylabel('initial variability');
title(['rat ', num2str(rat)]);

[r, p] = corr(b, v);
r
p


