function [ex, agent] = run(params, choicefun, nsessions, do_plot)

% e.g. run with
% [ex, agent] = run([], @choose_softmax, 10, 1)
% [ex, agent] = run([], @choose_UCB, 10, 1)
% [ex, agent] = run([], @choose_Thompson, 10, 1)
% [ex, agent] = run([], @choose_Thompson, 100, 2)
% [ex, agent] = run([], @choose_hybrid, 10, 1)
%
% load fit_params_nstarts=5_fitfun=fit_2params_Thompson_10k_max=3000_skip=10.mat
% TODO this is WRONG!
% [ex, agent] = run(results.x, @choose_Thompson, 10, true);

% run simulation with given parameters and choice function
% returns data == ex
%

rng default; % repro

%agent = init_agent(results.x(5,:));
if ~exist('params', 'var') || isempty(params)
    agent = init_agent();
elseif isstruct(params)
    agent = params; % could pass entire agent instead of params
else % by default, just pass params
    agent = init_agent(params);
end

if ~exist('choicefun', 'var') || isempty(choicefun)
    %choicefun = @choose_Thompson;
    %choicefun = @choose_hybrid;
    %choicefun = @choose_UCB;
    %choicefun = @(agent) choose_greedy(agent, 0.9);
    assert(false, 'no choice function supplied');
end

if ~exist('do_plot', 'var')
    do_plot = 0;
end

if ~exist('nsessions', 'var')
    ex = init_exp();
else
    ex = init_exp(nsessions);
end

ex = block_clamp(ex);
ex = mini_clamp(ex);
ex = stationary(ex);
ex = breaks(ex);

if do_plot > 0
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

    if do_plot == 1 && ex.t >= 250 + 300
        figs;
        drawnow;
        pause(0.001);
    elseif do_plot == 2
        if ex.t >= 1000 && mod(ex.t, 1000) == 0
            figs;
            drawnow;
        end
    end
end


save run.mat
