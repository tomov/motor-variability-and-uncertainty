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

    % switch target every block
    if mod(ex.t, ex.block_size) == 0
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
