function agent = update(agent, a, r)

    x = activations(agent, a);

    % kalman filter:            obs, state,   state cov., trans. model, control, control, process/transition noise cov., obs. model, ob.s noise var.
    [agent.w, agent.c] = kalman(r,   agent.w, agent.C,    eye(agent.D), 0,       0,       agent.Q                      , x'        , agent.s);

end
