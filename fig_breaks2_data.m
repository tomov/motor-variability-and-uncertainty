% fig_breaks but for data
% copied stuff from fig_value_data 

load rats_all_sess.mat;


nrats = length(ex_rats);
figure;


v_all = [];
b_all = [];
m_all = [];
rat_all = [];
for rat = 1:nrats

    [r, p, v, b, m] = fig_breaks2_single(ex_rats(rat), rat, nrats);

    b_all = [b_all; b];
    v_all = [v_all; v];
    m_all = [m_all; m];
    rat_all = [rat_all; repmat(rat, size(v, 1), 1)];
end

% group-level analysis the right way
%
v = v_all; % variability
b = b_all; % log break duration
m = m_all; % MSE
rat = rat_all;

%b = log(b); % optionally b/c clustered near 0
b = tiedrank(b);

tbl = table(rat, v, b, m);

formula = 'v ~ 1 + b + (1 + b | rat)';
result = fitglme(tbl, formula, 'Distribution', 'Normal', 'Link', 'Identity', 'FitMethod', 'Laplace');
[beta, names, stats] = fixedEffects(result);
H = [0 1]
[p, F, DF1, DF2] = coefTest(result, H);
fprintf('(var) fitglme b beta = %f (n.s. is policy gradient), p = %f, F(%d,%d) = %f\n', H * beta, p, DF1, DF2, F);



formula = 'm ~ 1 + b + (1 + b | rat)';
result = fitglme(tbl, formula, 'Distribution', 'Normal', 'Link', 'Identity', 'FitMethod', 'Laplace');
[beta, names, stats] = fixedEffects(result);
H = [0 1]
[p, F, DF1, DF2] = coefTest(result, H);
fprintf('(mse) fitglme b beta = %f (n.s. is policy gradient), p = %f, F(%d,%d) = %f\n', H * beta, p, DF1, DF2, F);


