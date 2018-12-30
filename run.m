rng default; % repro

agent = init_agent();
ex = init_exp();

ex = block_clamp(ex);
ex = mini_clamp(ex);
ex = stationary(ex);

%figure;

while ~ex.done
    disp(ex.t);

    %a = choose_hybrid(agent);
    a = choose_Thompson(agent);
    %a = choose_greedy(agent, 0.9);
    %a = 0;

    r = reward(ex, a);
    agent = update(agent, a, r);
    ex = next_trial(ex, a, r);

    %if ex.t >= 250
    %    figs;
    %    drawnow;
    %    pause(0.01);
    %end
end
