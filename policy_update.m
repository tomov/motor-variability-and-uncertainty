function actor = policy_update(actor, x, eps_e, eps_sigma, r)

    % policy gradient update

    PE = r - actor.rr;
    actor.mu = actor.mu + actor.alpha_mu * PE * eps_e; % average action
    actor.rr = actor.rr + actor.alpha_r * PE; % performance estimate = reward rate

    bin = floor(actor.d * actor.rr) + 1; % which bin does the reward rate r bar fall into
    R = eq(1:actor.d, bin);
    actor.E_sigma = actor.lambda * actor.E_sigma + eps_sigma * R;
    actor.s = actor.s + actor.alpha_siga * PE * actor.E_sigma;
