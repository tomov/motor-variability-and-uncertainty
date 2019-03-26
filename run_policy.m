rng default; % repro

actor = init_policy();
ex = init_exp(1000);

ex = block_clamp(ex);
ex = mini_clamp(ex);
ex = stationary(ex);

actor.s = actor.s_T100;
do_update_s = false;

%figure;

while ~ex.done
    if mod(ex.t, ex.session_size) == 0
        disp(ex.t);
    end

    [x, eps_e, eps_sigma] = choose_policy(actor);

    r = reward(ex, x);
    actor = update_policy(actor, x, eps_e, eps_sigma, r, do_update_s);
    ex = next_trial(ex, x, r);

    %if ex.t >= 250
    %    figs;
    %    drawnow;
    %    pause(0.01);
    %end
end

save run_policy.mat
