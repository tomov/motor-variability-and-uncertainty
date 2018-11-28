function ex = next_trial(ex, a, r)

    ex.a = [ex.a a];
    ex.r = [ex.r r];
    ex.tar = [ex.tar ex.target];
    ex.b = [ex.b ex.bound];
    if ex.t >= 5
        ex.var = [ex.var var(ex.a(ex.t-4:ex.t))];
    else
        ex.var = [ex.var NaN];
    end

    % shift boundaries and/or switch target after a session if criteria are met
    if mod(ex.t, ex.session_size) == 0

        % distances from target angle on last 50 trials
        a = sort(abs(ex.a(end-50:end) - ex.tar(end-50:end)));

        % set reward boundary to keep reward rate around 35%
        rr = mean(ex.r(end-50:end));
        if rr < 30 || rr > 40
            ex.bound = a(18); % 35 percentile
        end

        % switch target if boundary is too small
        if ex.bound < 2.3
            while true
                target = rand * (ex.max - ex.min) + ex.min;
                if abs(target - ex.target) > 2.3 % can't be too close to old target
                    ex.target = target;
                    break;
                end
            end
            %ex.bound = a(18); % 35 percentile <-- this is what Ashesh did?
            ex.bound = 5;
        end
    end

    % TODO sessions
    % TODO shifting boundaries
    % TODO nonstationary vs. stationary

    % next trial
    ex.t = ex.t + 1;
    if ex.t > ex.n
        ex.done = true;
    else
        % target clamp
        if ~isnan(ex.tarclamp(ex.t))
            ex.target = ex.tarclamp(ex.t);
        end
    end
end
