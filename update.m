function agent = update(agent, a, r)

    x = activations(agent, a);

    if ~isnan(r)
        % kalman filter:            obs, state,   state cov., trans. model, control, control, process/transition noise cov., obs. model, ob.s noise var.
        [agent.w, agent.C] = kalman(r,   agent.w, agent.C,    eye(agent.D), 0,       0,       agent.Q                      , x'        , agent.s);
    else
        % kalman filter without an observation (r)
        [agent.w, agent.C] = kalman_nu(agent.w, agent.C,    eye(agent.D), 0,       0,       agent.Q                      , x'        , agent.s);
    end

end
