function r = reward(ex, a)

    if a >= ex.target - ex.bound && a <= ex.target + ex.bound
        r = 1;
        if rand < ex.p_reward
            r = 1;
        else
            r = 0;
        end
    else
        r = 0;
    end

    if ~isnan(ex.clamp(ex.t))
        if rand < ex.clamp(ex.t)
            r = 1;
        else
            r = 0;
        end
    end
