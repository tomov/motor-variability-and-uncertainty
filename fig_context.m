% Figure 5

clear all;
load fig_context.mat

figure;

st = round(ex.n*1/3);
en = round(ex.n*2/3);

% actions and targets 
%
subplot(2,1,1);
plot([ex.a(1:5000) ex.a(st:st+5000) ex.a(en:en+5000)], '+');
hold on;
plot([ex.tar(1:5000) ex.tar(st:st+5000) ex.tar(en:en+5000)]);
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

lb = [0 0.14 0.29 0.43 0.57 0.71 0.86];
ub = [0.14 0.29 0.43 0.57 0.71 0.86 1];

titles = {'non-stationary 1', 'stationary', 'non-stationary 2'};

blue = [0 0 1];
red = [1 0 0];

% for each context
for con_idx = 1:3

    clear vb;
    % for each performance bin
    for bin = 1:length(lb)
        which_bin = (rbar > lb(bin)) & (rbar <= ub(bin)) & which_context{con_idx};

        which = {(ex.clamp == 1) & which_bin, (ex.clamp == 0) & which_bin};

        ax = -10:15;
        clear v;

        % reward vs. no reward
        for c_idx = 1:2
            ix = find(which{c_idx});
            for i = 1:length(ix)
                for j = 1:length(ax)
                    t = ix(i) + ax(j);
                    v(i,j) = ex.var(t);
                    if ax(j) >= 0 && ax(j) < 5
                        v(i,j) = NaN;
                    end
                end
                vb{bin, c_idx}(i) = var(ex.a(ix(i) : ix(i) + 5)); % TODO 10
            end

        end
        vd(bin) = mean(vb{bin, 2}) - mean(vb{bin, 1});
        vsd(bin) = sqrt(var(vb{bin, 2}) + var(vb{bin, 1}));
        vsed(bin) = vsd(bin) / sqrt(length(vb{bin, 2}) + length(vb{bin, 1}));
    end


    subplot(2,3,3+con_idx);

    % plot population plot (Figure 2C)
    %
    xs = (lb + ub)/2;
    errorbar(xs, vd, vsed, 'color', 'black');
    xlabel('performance estimate');
    ylabel('\Delta variability');
    title(titles{con_idx});
    ylim([-200 400]);
end
