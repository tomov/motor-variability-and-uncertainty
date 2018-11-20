function x = activations(agent, a)

    for i = 1:agent.D
        x(i,:) = agent.basis{i}(a);
    end
