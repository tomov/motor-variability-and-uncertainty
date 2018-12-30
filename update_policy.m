function actor = update_policy(actor, x, eps_e, eps_sigma, r, do_update_s)

    % whether we update the variability regulation function s or use the stock one
    if ~exist('do_update_s', 'var')
        do_update_s = true;
    end

    % policy gradient update

    PE = r - actor.rr;
    actor.mu = actor.mu + actor.alpha_mu * PE * eps_e; % average action
    actor.rr = actor.rr + actor.alpha_r * PE; % performance estimate = reward rate

    if do_update_s
        bin = floor(actor.d * actor.rr) + 1; % which bin does the reward rate r bar fall into
        R = eq(1:actor.d, bin);
        actor.E_sigma = actor.lambda * actor.E_sigma + eps_sigma * R;
        actor.s = actor.s + actor.alpha_sigma * PE * actor.E_sigma;
        actor.s(actor.s < 0) = 0; % ensure variability control function >= 0
    end
