% fig_memory21 helper
% test for memory by seeing whether farter targets are learned faster
% similar to fig_memory2 helper but split in 2 bins rather than 10

function [r, m, dist_cat, sess_cnt] = fig_memory2_single(ex, rat, nrats)

    tar = NaN;
    cnt = 0;

    sess_tar = [];
    sess_cnt = [];

    for t = 1:length(ex.a)
        if tar ~= ex.tar(t)
            % target switched
            %
            if ~isnan(tar)
                sess_cnt = [sess_cnt cnt];
                sess_tar = [sess_tar tar];
            end

            tar = ex.tar(t);
            cnt = 1;
        else
            cnt = cnt + 1;
        end
    end

    sess_cnt = [sess_cnt cnt];
    sess_tar = [sess_tar tar];

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
    scatter(x, y);
    lsline;
    [r, p] = corr(x', y');
    xlabel('distance to new target');
    ylabel('# sessions to learn new target');

    nansem = @(x) nanstd(x) / sqrt(sum(~isnan(x)));
    sem = @(x) nanstd(x) / sqrt(length(x));




    bin_size = (max(diff) - min(diff)) / 2 + 1;
    m = [];
    s = [];
    max_bin = ceil(max(diff) / bin_size);
    max_cnt = 0;
    dist_cat = []; % distance category aka bin for each target
    for bin = 1:max_bin
        d_min = (bin - 1) * bin_size + min(diff);
        d_max = bin * bin_size + min(diff);
        which = diff >= d_min & diff < d_max;
        cnts = sess_cnt(which);

        dist_cat(which) = bin;

        m(bin) = mean(cnts);
        s(bin) = sem(cnts);
    end

    subplot(2,nrats,rat+nrats);
    bar(m);
    hold on;
    errorbar(m, s, 'LineStyle', 'none', 'color', 'black');
    %med = (max_bin + 1) * frac;
    %plot([med med], ylim, '--', 'color', [0.3 0.3 0.3]);
    hold off;
    set(gca, 'xtick', []);

    xlabel('distance to new target');
    ylabel('# sessions to learn new target');

    dist_cat = categorical(dist_cat');
    sess_cnt = sess_cnt';
