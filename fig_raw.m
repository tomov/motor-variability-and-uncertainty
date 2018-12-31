figure;

% actions and targets
%

num = 100000;
start = randi(length(ex.tar) - num);

range = start:start+num-1;
hold on;
h = fill([1:num flip(1:num)], [ex.tar(range) + ex.b(range) flip(ex.tar(range) - ex.b(range))], 'red');
set(h, 'facealpha', 0.3, 'edgecolor', 'none');
plot(ex.a(range), 'o', 'color', 'black', 'markerfacecolor', 'black', 'markersize', 2);
plot(ex.tar(range), 'color', 'red');
hold off;
xlabel('trial');
ylabel('press angle');
title('targets and actions');

