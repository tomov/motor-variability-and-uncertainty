% Figure 5
% variability effect in stationary vs. non-stationary target context

%clear all;
%load fig_context.mat

figure;

st = round(ex.n*1/3);
en = round(ex.n*2/3);

a_min = -30;
a_max = 30;

% actions and targets 
%
subplot(2,1,1);
ntrials = 5000;
plot([ex.a(1:ntrials) ex.a(st:st+ntrials) ex.a(en:en+ntrials)], 'o', 'color', 'black', 'markerfacecolor', 'black', 'markersize', 2);
hold on;
plot([ex.tar(1:ntrials) ex.tar(st:st+ntrials) ex.tar(en:en+ntrials)], 'linewidth', 2);
plot([ntrials ntrials], [a_min a_max], '--', 'color', [0.6 0.6 0.6]);
plot([2*ntrials 2*ntrials], [a_min a_max], '--', 'color', [0.6 0.6 0.6]);
hold off;
xlabel('trial');
ylabel('press angle');
title('targets and actions');


ts = 1:ex.n;
which_context = {ts <= st, ...
                 ts > st & ts <= en, ...
                 ts > en};


% performance curves for eacn context
%

% TODO dedupe with fig_perf

tau = 5; % TODO fit 
rbar = nan(1, ex.n);
for t = 51:ex.n
    rbar(t) = 0;
    for s = 1:50
        rbar(t) = rbar(t) + ex.r(t - s) * exp(-s / tau);
    end
end
rbar = rbar / nanmax(rbar);


titles = {'non-stationary 1', 'stationary', 'non-stationary 2'};

blue = [0 0 1];
red = [1 0 0];

% for each context
for con_idx = 1:3

    [ax, lb, ub, md, sed, vd, vsd, vn, vsed, cvd, cvsed, stats] = get_variability_control_stats(ex, which_context{con_idx});

    % plot regulated variability
    %
    subplot(2,3,3+con_idx);

    xs = (lb + ub)/2;

    errorbar(xs, cvd, cvsed, 'color', 'black');
    title(titles{con_idx});
    xlabel('performance estimate');
    ylabel('regulated variability');
    %ylim([-50 520]);
    ylim([-10 50]);
    xlim([0 1]);
end
