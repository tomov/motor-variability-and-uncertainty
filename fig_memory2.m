% test for memory by seeing whether farter targets are learned faster
%


load rats_all.mat;

nrats = length(ex_rats);
figure;

rs = [];

for rat = 1:nrats

    stationary = 1;
    ex = ex_rats(rat);

    r = fig_memory2_single(ex, rat, nrats);
    title(['rat ', num2str(rat)]);
    rs = [rs r];
end

frs = atanh(rs);

[h, p, ci, stats] = ttest(frs);
stats
p
