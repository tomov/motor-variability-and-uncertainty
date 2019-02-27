% explore grid of parameters

nsess = 1000;

S = logspace(-3, 1, 9);
S = S(2:end-1); % skip ends

Q = logspace(-2, 0, 9);
Q = Q(2:end-1); % skip ends

for i = 1:length(S)
    for j = 1:length(Q)
        s = S(i);
        q = Q(j);
        filename = sprintf('grid2_s=%.6f_q=%.6f_nsess=%d.mat', s, q, nsess);
        disp(filename);
        tic
        [ex, agent] = run([s, q], @choose_Thompson, nsess);
        toc
        save(filename, '-v7.3');
    end
end
