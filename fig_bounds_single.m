% fig_jumps helper; basically copy of fig_memory21_single
% 
% v = variability (all trials) 
% b = boundary size (all trials)
% sess_var = variability (whole sess)
% sess_bound = boundary size (whole sess)

function [v, b, sess_var, sess_bound] = fig_bounds_single(ex, rat, nrats)


    %which = mod(ex.t, ex.session_size) > 5;
    which = logical(ones(size(ex.a)));
    v = ex.var(which)';
    b = ex.b(which)';

    sess_var = [];
    sess_bound = [];
    sess_tar = [];
    sess_cnt = [];

    tar = NaN;

    for t = 1:length(ex.a)
        if tar ~= ex.tar(t)
            % target switched
            %
            if ~isnan(tar)
                sess_cnt = [sess_cnt cnt];
                sess_tar = [sess_tar tar];
                sess_var = [sess_var var(ex.a(t - cnt : t - 1))];
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
    sess_var = [sess_var var(ex.a(t - cnt : t - 1))];
    sess_bound = [sess_bound bound];

    sess_var = sess_var';
    sess_bound = sess_bound';

    %{
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
    %}
