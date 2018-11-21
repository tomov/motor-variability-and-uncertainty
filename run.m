
agent = init_agent();
ex = init_exp();

while ~ex.done
    disp(ex.t);

    a = choose_hybrid(agent);
    %a = choose_greedy(agent, 0.9);
    %a = 0;

    [r, extra] = reward(ex, a);
    agent = update(agent, a, r);
    ex = next_trial(ex, a, r, extra);
end
