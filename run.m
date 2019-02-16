function [ex, agent] = run(params, choicefun, do_plot)

% run simulation with given parameters and choice function
% returns data == ex
%

rng default; % repro

%agent = init_agent(results.x(5,:));
if ~exist('params', 'var') || isempty(params)
    agent = init_agent();
else
    agent = init_agent(params);
end

if ~exist('choicefun', 'var') || isempty(choicefun)
    %choicefun = @choose_Thompson;
    choicefun = @choose_hybrid;
    %choicefun = @choose_UCB;
    %choicefun = @(agent) choose_greedy(agent, 0.9);
end

if ~exist('do_plot', 'var')
    do_plot = false;
end

ex = init_exp();

ex = block_clamp(ex);
ex = mini_clamp(ex);
ex = stationary(ex);
%ex = breaks(ex);

if do_plot
    figure;
end

while ~ex.done
    %disp(ex.t);

    a = choicefun(agent);
    %a = 0;

    r = reward(ex, a);
    agent = update(agent, a, r);

    if ex.breaks(ex.t) > 0
        for i = 1:ex.breaks(ex.t)
            agent = update(agent, 0, NaN);

            %figs;
            %drawnow;
            %pause(0.01);
        end
    end

    ex = next_trial(ex, a, r);

    if do_plot && ex.t >= 250 + 300
        figs;
        drawnow;
        pause(0.01);
    end
end


save run.mat
