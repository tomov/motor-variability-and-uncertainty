

% plot Q-values & UCBs
%
subplot(2,2,1);
[~, Q, U] = choose_UCB(agent);
as = agent.a_min : agent.da : agent.a_max;
fill([as flip(as)], [Q + U * agent.UCB_coef flip(Q - U * agent.UCB_coef)], [0.7 0.7 0.7]); % UCB 
hold on;
plot(as, Q); % Q-values

plot([ex.target ex.target], [-1 1.5], '-', 'color', [0.5 0.5 0.5], 'linewidth', 2);
plot([ex.target - ex.bound ex.target - ex.bound], [-1 1.5], '--', 'color', [0.5 0.5 0.5], 'linewidth', 1);
plot([ex.target + ex.bound ex.target + ex.bound], [-1 1.5], '--', 'color', [0.5 0.5 0.5], 'linewidth', 1);

plot(a, Q(find(as == a)), 'o', 'color', 'black', 'markerfacecolor', 'black'); % last action

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
plot(ex.a, '+');
hold on;
plot(ex.tar);
hold off;
xlabel('trial');
ylabel('press angle');
title('actions');
