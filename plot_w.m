function plot_w(agent, scaled)

    if ~exist('scaled', 'var')
        scaled = true;
    end

    a = agent.a_min : agent.da : agent.a_max;
    for i = 1:agent.D
        y = agent.basis{i}(a);
        if scaled
            y = y * agent.w(i);
        end
        plot(a, y);
        if i == 1
            hold on;
        end
    end

    hold off;
