function r = reward(ex, a)

    % deliver reward if agent took action (angle) a and it is within the bounds 
    if a >= ex.target - ex.bound && a <= ex.target + ex.bound
        r = get_reward(ex);
    else
        r = 0;
    end

    if ~isnan(ex.clamp(ex.t))
        % clamped trial
        if rand < ex.clamp(ex.t)
            r = get_reward(ex);
        else
            r = 0;
        end
    end
end

% draw reward stochastically -> rats only pressed successfully on 81% of trials
%
function r = get_reward(ex)
    if rand < ex.p_reward
        r = 1;
    else
        r = 0;
    end
end
