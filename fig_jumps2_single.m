% fig_jumps2 helper; basically copy of fig_jumps
% uses learning (i.e. rr(end) - rr(begin))
% 

function [r, p, x, y, b] = fig_jumps2_single(ex, rat, nrats)

    tar = NaN;
    cnt = 0;

    sess_tar = [];
    sess_cnt = [];

    sess_begin_rew = [];
    sess_end_rew = [];
    sess_bound = []; % starting bound

    for t = 1:length(ex.a)
        if tar ~= ex.tar(t)
            % target switched
            %
            if ~isnan(tar)
                sess_cnt = [sess_cnt cnt];
                sess_tar = [sess_tar tar];
                sess_begin_re = [sess_begin_rew nanmean(rew(1:20))];
                sess_end_rew = [sess_end_rew nanmean(rew(201:220))];
                sess_bound = [sess_bound bound];
            end

            tar = ex.tar(t);
            cnt = 1;
            rew = [ex.r(t)];
            bound = ex.b(t);
        else
            cnt = cnt + 1;
            rew = [rew ex.r(t)];
        end
    end

    sess_cnt = [sess_cnt cnt];
    sess_tar = [sess_tar tar];
    sess_begin_rew = [sess_begin_rew nanmean(rew(1:20))];
    sess_end_rew = [sess_end_rew nanmean(rew(201:220))];
    sess_bound = [sess_bound bound];
    sess_delta_rew = sess_end_rew - sess_begin_rew;

    diff = sess_tar(2:end) - sess_tar(1:end-1);
    diff = [NaN diff];
    diff = abs(diff);

    %second_half = diff >= nanmedian(diff);
    frac = 0.3;
    d = diff(~isnan(diff));
    d = sort(d);
    idx = round(frac * length(d));
    second_half = diff >= d(idx);

    second_half(2:end) = 1; % <--- consider all trials

    subplot(2,nrats,rat);
    x = diff(second_half);
    %y = sess_cnt(second_half);
    %y = sess_begin_rew(second_half);
    y = sess_delta_rew(second_half);
    b = sess_bound(second_half);
    scatter(x, y);
    lsline;
    x = x';
    y = y'; 
    b = b';
    [r, p] = corr(x, y);

    xlabel('distance to new target');
    ylabel('learning = rr during first 20 trials -- rr during last 20 trials of block');

    nansem = @(x) nanstd(x) / sqrt(sum(~isnan(x)));
    sem = @(x) nanstd(x) / sqrt(length(x));

    bin_size = 5;
    m = [];
    s = [];
    max_bin = ceil(max(diff) / bin_size);
    max_delta_rew = 0;
    for bin = 1:max_bin
        d_min = (bin - 1) * bin_size;
        d_max = bin * bin_size;
        which = diff >= d_min & diff < d_max;
        delta_rews = sess_delta_rew(which);

        m(bin) = nanmean(delta_rews);
        s(bin) = sem(delta_rews);
    end

    save shit.mat

    subplot(2,nrats,rat+nrats);
    bar(m);
    hold on;
    errorbar(m, s, 'LineStyle', 'none', 'color', 'black');
    med = (max_bin + 1) * frac;
    %plot([med med], ylim, '--', 'color', [0.3 0.3 0.3]);
    hold off;
    set(gca, 'xtick', []);

    xlabel('distance to new target');
    ylabel('learning = rr during last 20 trials -- rr during first 20 trials of block');
