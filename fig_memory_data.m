% test whether there is "memory" for past target angles
% see if subject does better if an old target pops up again
%


load rats_all.mat;

nrats = length(ex_rats);
figure;

rs = [];

for rat = 1:nrats

    stationary = 1;
    ex = ex_rats(rat);

    r = fig_memory_single(ex, rat, nrats);
    title(['rat ', num2str(rat)]);
    rs = [rs r];
end

