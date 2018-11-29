rng default; % repro

actor = init_policy();
ex = init_exp();

ex = block_clamp(ex);
ex = mini_clamp(ex);
%ex = stationary(ex);

%figure;

while ~ex.done
    disp(ex.t);

    [x, eps_e, eps_sigma] = choose_policy(actor);

    r = reward(ex, x);
    actor = update_policy(actor, x, eps_e, eps_sigma, r);
    ex = next_trial(ex, x, r);

    %if ex.t >= 250
    %    figs;
    %    drawnow;
    %    pause(0.01);
    %end
end
