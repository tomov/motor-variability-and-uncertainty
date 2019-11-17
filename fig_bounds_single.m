% do bigger boundaries predict more variability?
% 
% v = variability (all trials) 
% b = boundary size (all trials)
% sess_var = variability (whole sess)
% sess_bound = boundary size (whole sess)
% sess_bound = reward (whole sess)
% rr = reward rate, rolling (as calculated by policy gradient -- see update_policy.m)
% sess_s = regulated exploratory variability, as calc by choose_policy

function [v, b, sess_var, sess_bound, sess_rew, rr, sess_s] = fig_bounds_single(ex, rat, nrats)

    % TODO hardcoded
    actor.alpha_r = 0.1846;
    actor.s = [7.8102    4.2426    2.4495    2.0000    1.7321    1.0000    0.1000];
    actor.d = 7;

    rr = 0;
    ex.rr = nan(size(ex.a));
    for t = 1:length(ex.a)
        if ~isnan(ex.r(t))
            PE = ex.r(t) - rr;
        else
            PE = -rr; % no resp = no rew
        end
        rr = rr + actor.alpha_r * PE; % actor.alpha_r
        ex.rr(t) = rr;
    end

    %which = mod(ex.t, ex.session_size) > 5;
    which = logical(ones(size(ex.a)));
    v = ex.var(which)';
    rr = ex.rr(which)';
    b = ex.b(which)';

    sess_var = [];
    sess_rew = [];
    sess_bound = [];
    sess_tar = [];
    sess_cnt = [];
    sess_s = [];

    tar = NaN;
    bound = NaN;

    for t = 1:length(ex.a)
        if tar ~= ex.tar(t) || bound ~= ex.b(t) % TODO not good criterion; sometimes we merge two sessions
            % new session
            %
            if ~isnan(tar)

                bin = floor(actor.d * ex.rr(t)) + 1; % which bin does the reward rate r bar fall into
                sigma_e = actor.s(bin);

                sess_cnt = [sess_cnt cnt];
                sess_tar = [sess_tar tar];
                %sess_var = [sess_var var(ex.a(t - 5 : t - 1))];
                %sess_rew = [sess_rew mean(ex.r(t - 5 : t - 1))];
                sess_rew = [sess_rew mean(ex.rr(t-50:t-1))];
                %sess_var = [sess_var var(ex.a(t-round(cnt/2):t-1))];
                sess_var = [sess_var ex.var(t-1)];
                %sess_var = [sess_var var(ex.a(t-cnt:t-1))];
                %cnt
                sess_s = [sess_s sigma_e];
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

    %{
    sess_cnt = [sess_cnt cnt];
    sess_tar = [sess_tar tar];
    %sess_var = [sess_var var(ex.a(t - round(cnt/2) : t - 1))];
    %sess_rew = [sess_rew mean(ex.r(t - round(cnt/2) : t - 1))];
    %sess_var = [sess_var var(ex.a(t - 5 : t - 1))];
    %sess_rew = [sess_rew mean(ex.r(t - 5 : t - 1))];
    sess_var = [sess_var ex.var(t)];
    sess_rew = [sess_rew ex.rr(t-5)];
    sess_bound = [sess_bound bound];
    %}

    sess_var = sess_var';
    sess_rew = sess_rew';
    sess_bound = sess_bound';
    sess_s = sess_s';

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
