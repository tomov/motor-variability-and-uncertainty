figure;

% actions and targets
%

range = 1:100000;
hold on;
h = fill([range flip(range)], [ex.tar(range) + ex.b(range) flip(ex.tar(range) - ex.b(range))], 'red');
set(h, 'facealpha', 0.3, 'edgecolor', 'none');
plot(ex.a(range), 'o', 'color', 'black', 'markerfacecolor', 'black', 'markersize', 2);
plot(ex.tar(range), 'color', 'red');
hold off;
xlabel('trial');
ylabel('press angle');
title('targets and actions');

