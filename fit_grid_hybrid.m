% explore grid of parameters

nsess = 1000;

S = logspace(-3, -2, 9);

Q = logspace(-2, 0, 9);

for i = 1:length(S)
    for j = 1:length(Q)
        s = S(i);
        q = Q(j);
        filename = sprintf('hybrid_grid2_sigma=dx3_s=%.6f_q=%.6f_nsess=%d.mat', s, q, nsess);
        disp(filename);
        tic
        [ex, agent] = run([s, q], @choose_hybrid, nsess);
        toc
        save(filename, '-v7.3');
    end
end