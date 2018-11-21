rng default; % repro

agent = init_agent();
ex = init_exp();

% single conditioned trials
ex.clamp(randsample(ex.n, ex.n * 0.05)) = 1;
ex.clamp(randsample(ex.n, ex.n * 0.05)) = 0;
ex.clamp(1:20) = NaN;
ex.clamp(end-40:end) = NaN;

% block clamps
%rs = [0.1 0.5 0.9];
%for b = 1:ex.nblocks - 1
%    if mod(b,2) == 0
%        r = rs(randi(length(rs)));
%        s = (b - 1) * ex.block_size + 1;
%        e = b * ex.block_size;
%        ex.bclamp(b) = r;
%        ex.clamp(s:e) = r;
%    end
%end

% stationary context
ex.tarclamp(round(ex.n*1/3):round(ex.n*2/3)) = 0;

%figure;

while ~ex.done
    disp(ex.t);

    a = choose_hybrid(agent);
    %a = choose_greedy(agent, 0.9);
    %a = 0;

    r = reward(ex, a);
    agent = update(agent, a, r);
    ex = next_trial(ex, a, r);

    %figs;
    %drawnow;
    %pause(0.01);
end
