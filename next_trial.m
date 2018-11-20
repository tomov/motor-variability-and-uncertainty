function ex = next_trial(ex, a, r)

    ex.a = [ex.a a];
    ex.r = [ex.r r];
    ex.tar = [ex.tar ex.target];

    if mod(ex.t, 50) == 0
        % TODO do it properly
   %     ex.target = rand * (ex.max - ex.min) + ex.min;
    end

    % TODO sessions
    % TODO shifting boundaries
    % TODO nonstationary vs. stationary

    ex.t = ex.t + 1;
    if ex.t > ex.n
        ex.done = true;
    end

end
