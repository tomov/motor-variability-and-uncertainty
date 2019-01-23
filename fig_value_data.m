% fig_value but for data
% copied stuff from fig_memory2_data and fig_value

load rats_all_blocks.mat;

nrats = length(ex_rats);
figure;


g = [];

for rat = 1:nrats

    m = fig_value_single(ex_rats(rat), rat, nrats);
    title(['rat ', num2str(rat)]);

    g = [g m(1) > m(2)]; % null = chance (1 = policy gradient; note we plot them flipped) 
end

p = binopdf(sum(g), length(g), 0.5);
g
sum(g) / length(g)
p


figure;
fig_value_single(ex, 1, 1);
title('superrat');

