% test whether there is "memory" for past target angles
% see if subject does better if an old target pops up again
%


load rats_all.mat;

nrats = length(ex_rats);
figure;

g = [];

for rat = 1:nrats

    stationary = 1;
    ex = ex_rats(rat);

    [mses] = fig_memory_single(ex, rat, nrats);
    title(['rat ', num2str(rat)]);

    m = [nanmean(mses{1}) nanmean(mses{2})];
    g = [g m(1) > m(2)]; % null = chance (1 = policy gradient; note we plot them flipped) 
end

p = binopdf(sum(g), length(g), 0.5);
g
sum(g) / length(g)
p
