function ABC_UCB(eps, nsess)

    while true
        % params(1) = s = observation noise variance = 0.01
        % params(2) = q = process/transition/diffusion noise variance = 0.1
        % params(3) = sigma = variance of basis functions (Gaussians) = 4
        % params(4) = D = # of basis functions = 10

        params(1) = exprnd(1);
        params(2) = exprnd(1);
        params(3) = unifrnd(1,30);
        params(4) = round(unifrnd(2,15));
        params(5) = exprnd(10); % ??
        params(6) = exprnd(10); % ??

        params

        try

            tic
            [ex, agent] = run(params, @choose_UCB, nsess);

            [S, S_real] = ABC_get_stats(ex);
            toc

            d = pdist([S; S_real], 'euclidean');

            d

            if d < eps
                disp('YES!');

                filename = sprintf('ABC_UCB_eps=%.2f_nsess=%d_params=[%s].mat', eps, nsess, sprintf('%.5f_', params));
                filename

                save(filename, '-v7.3');
            end

        catch err
            disp(err)
        end
    end
