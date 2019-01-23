% test for memory by seeing whether farter targets are learned faster / slower
%


load rats_all.mat;

nrats = length(ex_rats);
figure;

g = [];

for rat = 1:nrats

    stationary = 1;

    [r, m] = fig_memory21_single(ex_rats(rat), rat, nrats);
    title(['rat ', num2str(rat)]);
    rs = [rs r];

    g = [g m(1) < m(2)]; % null = chance (1 = policy gradient)
end

p = binopdf(sum(g), length(g), 0.5);
g
sum(g) / length(g)
p

figure;
fig_memory21_single(ex, 1, 1);
title('superrat');
