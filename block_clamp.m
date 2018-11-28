function ex = block_clamp(ex)

    % include block clamps; make sure to run after init_exp

    b = logical([]);
    for i = 1:floor(ex.nsessions / 8)
        b = [b ismember(1:8, randsample(8,3))];
    end
    b = [b zeros(1, ex.nsessions - length(b))];

    rs = [0.1 0.35 0.75];
    for s = 1:ex.nsessions
        if b(s)
            r = rs(randi(length(rs)));
            start = randi(50) + 50 + (s - 1) * ex.session_size + 1;
            dur = 100;
            ex.bclamp_start = [ex.bclamp_start start];
            ex.bclamp_dur = [ex.bclamp_dur dur];
            ex.bclamp_r = [ex.bclamp_r r];
            ex.clamp(start : start + dur - 1) = r;
        end
    end
