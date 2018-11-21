function ex = next_trial(ex, a, r, extra)

    ex.a = [ex.a a];
    ex.r = [ex.r r];
    ex.tar = [ex.tar ex.target];
    ex.b = [ex.b ex.bound];
    if ex.t >= 5
        ex.var = [ex.var var(ex.a(ex.t-4:ex.t))];
    else
        ex.var = [ex.var NaN];
    end

    ex.r_cond = [ex.r_cond extra.r_cond];
    ex.nor_cond = [ex.nor_cond extra.nor_cond];

    % switch target
    if mod(ex.t, 50) == 0
        % TODO do it properly
        ex.target = rand * (ex.max - ex.min) + ex.min;
    end

    % TODO sessions
    % TODO shifting boundaries
    % TODO nonstationary vs. stationary

    ex.t = ex.t + 1;
    if ex.t > ex.n
        ex.done = true;
    end

end
