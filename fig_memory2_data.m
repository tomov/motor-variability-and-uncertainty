% test for memory by seeing whether farter targets are learned faster / slower
%


load rats_all.mat;

nrats = length(ex_rats);
figure;

rs = [];

for rat = 1:nrats

    stationary = 1;

    r = fig_memory2_single(ex_rats(rat), rat, nrats);
    title(['rat ', num2str(rat)]);
    rs = [rs r];
end

frs = atanh(rs);

[h, p, ci, stats] = ttest(frs);
stats
p

figure;
[r, p] = fig_memory2_single(ex, 1, 1);
title('superrat');
r
p

