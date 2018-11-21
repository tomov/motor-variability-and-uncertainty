function [r, extra] = reward(ex, a)

    if a >= ex.target - ex.bound && a <= ex.target + ex.bound
        r = 1;
    else
        r = 0;
    end

    % single-trial conditioning, 10% of trials
    extra.r_cond = false;
    extra.nor_cond = false;
    if rand < 0.1 && ex.t > 10 && ex.t < ex.n - 30
        if rand < 0.5
            extra.r_cond = true;
            r = 1;
        else
            extra.nor_cond = true;
            r = 0;
        end
    end
