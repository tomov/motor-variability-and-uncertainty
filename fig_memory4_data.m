% test whether there is "memory" for past target angles
% see if new target is learned faster when it is closer to old target (i.e. when jump was in direction of old target)
%


load rats_all.mat;

nrats = length(ex_rats);
figure;

g = [];

for rat = 1:nrats

    stationary = 1;
    ex = ex_rats(rat);

    [mses] = fig_memory4_single(ex, rat, nrats);

    %m = [nanmean(mses{1}) nanmean(mses{2})];
    %g = [g m(1) > m(2)];
end

