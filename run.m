
agent = init_agent();
ex = init_exp();

while ~ex.done
    disp(ex.t);

    a = choose_hybrid(agent);
    r = reward(ex, a);
    agent = update(agent, a, r);
    ex = next_trial(ex, a, r);
end
