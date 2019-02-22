% fig_jumps helper; basically copy of fig_memory21_single
% 

function [r, p, x, y, b] = fig_jumps_single(ex, rat, nrats)

    tar = NaN;
    cnt = 0;

    sess_tar = [];
    sess_cnt = [];

    sess_initrew = [];
    sess_bound = [];

    for t = 1:length(ex.a)
        if tar ~= ex.tar(t)
            % target switched
            %
            if ~isnan(tar)
                sess_cnt = [sess_cnt cnt];
                sess_tar = [sess_tar tar];
                sess_initrew = [sess_initrew nanmean(rew(1:20))];
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
    sess_initrew = [sess_initrew nanmean(rew(1:20))];
    sess_bound = [sess_bound bound];

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
    y = sess_initrew(second_half);
    b = sess_bound(second_half);
    scatter(x, y);
    lsline;
    x = x';
    y = y'; 
    b = b';
    [r, p] = corr(x, y);

    xlabel('distance to new target');
    ylabel('avg reward during first 20 trials');

    nansem = @(x) nanstd(x) / sqrt(sum(~isnan(x)));
    sem = @(x) nanstd(x) / sqrt(length(x));

    bin_size = 5;
    m = [];
    s = [];
    max_bin = ceil(max(diff) / bin_size);
    max_initrew = 0;
    for bin = 1:max_bin
        d_min = (bin - 1) * bin_size;
        d_max = bin * bin_size;
        which = diff >= d_min & diff < d_max;
        initrews = sess_initrew(which);

        m(bin) = mean(initrews);
        s(bin) = sem(initrews);
    end

    subplot(2,nrats,rat+nrats);
    bar(m);
    hold on;
    errorbar(m, s, 'LineStyle', 'none', 'color', 'black');
    med = (max_bin + 1) * frac;
    %plot([med med], ylim, '--', 'color', [0.3 0.3 0.3]);
    hold off;
    set(gca, 'xtick', []);

    xlabel('distance to new target');
    ylabel('avg reward during first 20 trials');
