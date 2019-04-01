load grid3_s=0.013335_q=0.031623_nsess=1000.mat;

nsess = 10000;

agent.Q = agent.Q / 2;
agent.q = agent.q / 2;

filename = sprintf('sim_more_sess_s=%.6f_q=%.6f_nsess=%d.mat', agent.s, agent.q, nsess);
filename

tic;
[ex, agent2] = run(agent, @choose_Thompson, nsess, false);
toc;

save(filename, '-v7.3');
