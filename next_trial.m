function ex = next_trial(ex, a, r)

    ex.a(ex.t) = a;
    ex.r(ex.t) = r;
    ex.tar(ex.t) = ex.target;
    ex.b(ex.t) = ex.bound;
    if ex.t >= 5
        ex.var(ex.t) = var(ex.a(ex.t-4:ex.t));
    else
        ex.var(ex.t) = NaN;
    end

    % shift boundaries and/or switch target after a session if criteria are met
    if mod(ex.t, ex.session_size) == 0
        %ex.target = rand * (ex.max - ex.min) + ex.min; % <== this is what repros the nice shape of the fig_cond... and comment out all else below

        % set reward boundary to keep reward rate around 35%
        rr = mean(ex.r(ex.t-50:ex.t));
        if rr < 30 || rr > 40
            % distances from target angle on last 50 trials
            a = sort(abs(ex.a(ex.t-50:ex.t) - ex.tar(ex.t-50:ex.t)));
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

            % distances from NEW (!) target angle on last 50 trials
            a = sort(abs(ex.a(ex.t-50:ex.t) - ex.target));
            ex.bound = a(18); % 35 percentile <-- this is what Ashesh did (see fig_cond_data.m)
            %ex.bound = 5;
        end
    end

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
