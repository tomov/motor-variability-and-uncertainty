% fig_sampled helper; see if angles that were sampled longer ago are more likely to be chosen after omission trials 
% 

function [y] = fig_sampled_single(ex, rat, nrats)

    which = ex.clamp == 0;
    bin_width = 1; % 1 degree; maybe 2?
    min_a = -30;
    max_a = 30;

    a_last = []; % last time a was sampled
    oa_last = []; % last time other a was sampled

    ex.t = 1:length(ex.a);

    ix = find(which);
    for i = 1:length(ix)
        t = ix(i) + 1;
        if t > length(ex.t)
            break;
        end
        a = ex.a(t);
        oa = ex.tar(t) - (ex.a(t) - ex.tar(t)); % the "other" action = symmetric action w.r.t. target

        if oa < min_a || oa > max_a 
            continue;
        end

        last_a = find(ex.a >= a - bin_width & ex.a <= a + bin_width & ex.t < t);
        if length(last_a) == 0
            continue;
        end
        last_a = last_a(end); % last time action a was sampled

        last_oa = find(ex.a >= oa - bin_width & ex.a <= oa + bin_width & ex.t < t);
        if length(last_oa) == 0
            continue;
        end
        last_oa = last_oa(end); % last time other action oa was sampled

        a_last = [a_last; t - last_a];
        oa_last = [oa_last; t - last_oa];

        %fprintf('%d: (%f - %f - %f) %d %d\n', t, a, ex.tar(t), oa, t - last_a, t - last_oa);

    end

    save shit.mat

    y = a_last - oa_last;

