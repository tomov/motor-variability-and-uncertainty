
agent = init_agent();
ex = init_exp();

while ~e.done
    a = choose(agent);
    r = reward(ex, a);
    agent = update(agent, a, r);
    ex = next_trial(ex, a, r);
end
