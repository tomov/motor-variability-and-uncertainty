% fig_breaks but for policy
% fake -- we don't really use breaks in policy gradient!

load('archive/thompson_300000_nonstationary_breaks.mat');
b = ex.breaks;

load policy_T=100_300000_nonstationary.mat;
ex.breaks = b; % use breaks from thompson; TODO hack but doesn't matter

figure;
[mses, vars] = fig_breaks_single(ex, 1, 1);

title('policy gradient');
