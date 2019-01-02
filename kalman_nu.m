function [x, P, z_mean, z_var] = kalman(x, P, F, B, u, Q, H, R)

% Same as kalman.m except without an observation => no update (nu)

% Prediction
% Note x and P now correspond to x_hat_t|t-1 and P_t|t-1
%
z_mean = H * x;

x = F * x + B * u;
P = F * P * F' + Q;

z_var = H * P * H' + R; % TODO SAM why use this variance?

