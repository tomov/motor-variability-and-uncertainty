% fig_memory2 helper
% test for memory by seeing whether farter targets are learned faster

function [r, p, x, y, z] = fig_memory2_single(ex, rat, nrats)

    tar = NaN;
    cnt = 0;

    sess_tar = [];
    sess_cnt = [];

    sess_initrew = [];

    for t = 1:length(ex.a)
        if tar ~= ex.tar(t)
            % target switched
            %
            if ~isnan(tar)
                sess_cnt = [sess_cnt cnt];
                sess_tar = [sess_tar tar];
                sess_initrew = [sess_initrew nanmean(rew(1:20))];
            end

            tar = ex.tar(t);
            cnt = 1;
            rew = [ex.r(t)];
        else
            cnt = cnt + 1;
            rew = [rew ex.r(t)];
        end
    end

    sess_cnt = [sess_cnt cnt];
    sess_tar = [sess_tar tar];
    sess_initrew = [sess_initrew nanmean(rew(1:20))];

    diff = sess_tar(2:end) - sess_tar(1:end-1);
    diff = [NaN diff];
    diff = abs(diff);

    %second_half = diff >= nanmedian(diff);
    frac = 0.3;
    d = diff(~isnan(diff));
    d = sort(d);
    idx = round(frac * length(d));
    second_half = diff >= d(idx);

    subplot(2,nrats,rat);
    x = diff(second_half);
    y = sess_cnt(second_half);
    z = sess_initrew(second_half);
    scatter(x, y);
    lsline;
    x = x';
    y = y'; 
    z = z';
    [r, p] = corr(x, y);
    xlabel('distance to new target');
    ylabel('# trials to learn new target');

    nansem = @(x) nanstd(x) / sqrt(sum(~isnan(x)));
    sem = @(x) nanstd(x) / sqrt(length(x));

    bin_size = 5;
    m = [];
    s = [];
    max_bin = ceil(max(diff) / bin_size);
    max_cnt = 0;
    for bin = 1:max_bin
        d_min = (bin - 1) * bin_size;
        d_max = bin * bin_size;
        which = diff >= d_min & diff < d_max;
        cnts = sess_cnt(which);

        m(bin) = mean(cnts);
        s(bin) = sem(cnts);
    end

    subplot(2,nrats,rat+nrats);
    bar(m);
    hold on;
    errorbar(m, s, 'LineStyle', 'none', 'color', 'black');
    med = (max_bin + 1) * frac;
    plot([med med], ylim, '--', 'color', [0.3 0.3 0.3]);
    hold off;
    set(gca, 'xtick', []);

    xlabel('distance to new target');
    ylabel('# trials to learn new target');
