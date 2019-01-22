

% plot Q-values & UCBs
%
subplot(2,2,1);
[~, Q, U] = choose_Thompson(agent);
as = agent.a_min : agent.da : agent.a_max;
fill([as flip(as)], [Q + U * agent.UCB_coef flip(Q - U * agent.UCB_coef)], [0.7 0.7 0.7]); % UCB 
hold on;
plot(as, Q); % Q-values

plot([ex.target ex.target], [-1 1.5], '-', 'color', [0.5 0.5 0.5], 'linewidth', 2);
plot([ex.target - ex.bound ex.target - ex.bound], [-1 1.5], '--', 'color', [0.5 0.5 0.5], 'linewidth', 1);
plot([ex.target + ex.bound ex.target + ex.bound], [-1 1.5], '--', 'color', [0.5 0.5 0.5], 'linewidth', 1);

plot(a, Q(find(abs(as - a) == min(abs(as - a)))), 'o', 'color', 'black', 'markerfacecolor', 'black'); % last action

hold off;
title('Q-values');
xlabel('angle');
ylabel('expected reward');
ylim([-1 1.5]);

% plot basis functions
%
subplot(2,2,2);
plot_w(agent);
title('basis functions, scaled by w');
xlabel('angle');
ylabel('w');

% plot variability
%
subplot(2,2,3);
plot(ex.var);
title('variability');
ylabel('var');
xlabel('trial');

% plot choices
%
subplot(2,2,4);
range = 1:ex.t-1;
h = fill([range flip(range)], [ex.tar(range) + ex.b(range) flip(ex.tar(range) - ex.b(range))], 'blue');
set(h, 'facealpha', 0.3, 'edgecolor', 'none');
hold on;
plot(range(ex.r == 0), ex.a(ex.r == 0), '+', 'color', 'red');
plot(range(ex.r == 1), ex.a(ex.r == 1), '+', 'color', 'green');
plot(ex.tar, 'color', 'blue');
hold off;
xlabel('trial');
ylabel('press angle');
title('actions');
