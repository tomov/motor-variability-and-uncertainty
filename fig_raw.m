figure;

% actions and targets
%

num = 100000;
start = randi(length(ex.tar) - num);

range = start:start+num-1;
x = 1:num;

hold on;
h = fill([x flip(x)], [ex.tar(range) + ex.b(range) flip(ex.tar(range) - ex.b(range))], 'red');
set(h, 'facealpha', 0.3, 'edgecolor', 'none');
%plot(ex.a(range), 'o', 'color', 'black', 'markerfacecolor', 'black', 'markersize', 2);
r = ex.r(range);
a = ex.a(range);
plot(x(r == 0), a(r == 0), 'o', 'color', 'black', 'markerfacecolor', 'black', 'markersize', 2);
plot(x(r == 1), a(r == 1), 'o', 'color', 'green', 'markerfacecolor', 'green', 'markersize', 2);
plot(ex.tar(range), 'color', 'red');
hold off;
xlabel('trial');
ylabel('press angle');
title('targets and actions');

