function ex = mini_clamp(ex)

    % include mini clamps; make sure to run after block_clamp

    rs = [0 1];
    for t = 30:ex.n-30
        if isnan(ex.clamp(t)) && rand < 0.1
            r = rs(randi(length(rs), 1, 3));
            ex.clamp(t:t+2) = r;
        end
    end
