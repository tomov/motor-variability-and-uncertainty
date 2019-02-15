function [loglik, lik, Mu, Covar] = loglik_Thompson(agent, chosen_a)

    % log likelihood for Thompson sampling decison based on Kalman filter values & uncertainteis
    % see choose_Thompson.m
    % 

    % find closest angle
    % => NO NEED TO; we compute it exactly w.r.t the chosen angle, basically using the other (discretized) angles to normalize the probability
    %{
    closest_a = Inf;
    for a = agent.a_min : agent.da : agent.a_max
        if abs(chosen_a - a) < abs(chosen_a - closest_a)
            closest_a = a;
        end
    end
    %}

    % mean and cov matrix of multivariate Gaussian
    % corresponding to P(Q_chosen >= Q1, Q_chosen >= Q2, ...) 
    %                = P(Q_chosen - Q1 >= 0, Q_chosen - Q2 >= 0, ...)
    % note that all linear combos are Gaussians -> it's multivar Gaussian
    % see https://onlinelibrary.wiley.com/doi/pdf/10.1111/tops.12145 Uncertainty and Exploration in a Restless Bandit Problem p. 11
    %
    % Actually I think their thing is exactly right (despite their really crappy notation).
    % 
    % P(u_j >= u_1, u_j >= u_2, ...) = P(u_j - u_1 >= 0, u_j - u_2 >= 0, ...)
    % 
    % The vector (u_j - u_1, u_j - u_2, ...) is multivariate normal since any linear combination of the components is multivariate normal (a normal times a constant is a normal, and a sum of normals is also normal). Then the covariance matrix works out to what they have derived (sigma_j^2 + sigma_k^2 along the diagonal, and sigma_j^2 for the covariance terms).
    %
    Mu = [];
    Covar = [];

    [mu_chosen, sigma_chosen] = get_values(agent, chosen_a); % compute w.r.t. chosen angle TODO make sure this is legit (instead of finding closest discrete angle)

    i = 0;
    for a = agent.a_min : agent.da : agent.a_max
        [mu, sigma] = get_values(agent, a);

        i = i + 1;
        Mu(i) = mu_chosen - mu;
        Covar(i,i) = sigma_chosen^2 + sigma^2;
    end

    Covar(~logical(eye(size(Covar)))) = sigma_chosen^2;

    Lb = zeros(size(Mu));
    Ub = inf(size(Mu));
    lik = mvncdf(Lb, Ub, Mu, Covar);
    loglik = log(lik);

    % TODO optional uncontrolled variability

