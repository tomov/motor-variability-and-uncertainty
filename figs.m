figure;

% plot Q-values & UCBs
%
subplot(2,2,1);
[~, Q, U] = choose_UCB(agent);
as = agent.a_min : agent.da : agent.a_max;
fill([as flip(as)], [Q + U * agent.UCB_coef flip(Q - U * agent.UCB_coef)], [0.7 0.7 0.7]);
hold on;
plot(as, Q);
hold off;
title('Q-values');
xlabel('angle');
ylabel('expected reward');

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
