% test if variability at session start is correlated with break duration before session 
%
function [r, p, v, b] = fig_breaks2_single(ex, rat, nrats)

which = ex.breaks ~= 0 & ~isnan(ex.breaks);
trials = find(which);

v = [];
b = [];
for t = trials

    vv = nanvar(ex.a(t+1:t+20));
    if ~isnan(vv)
        v = [v; vv];
        b = [b; ex.breaks(t)];
    end
end


subplot(1, nrats, rat);
scatter(b, v);
lsline;
xlabel('break duration');
ylabel('initial variability');
title(['rat ', num2str(rat)]);

[r, p] = corr(b, v);
r
p

if isnan(r)
    save shit.mat
end

