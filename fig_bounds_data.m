% test for thompson by seeing whether farter targets have higher initial rewards 
%

clear;

load rats_all.mat;

nrats = length(ex_rats);
figure;

rs = [];

v_all = [];
b_all = [];
sv_all = [];
sb_all = [];
rat_all = [];
srat_all = [];
for rat = 1:nrats

    stationary = 1;

    [v, b, sv, sb] = fig_bounds_single(ex_rats(rat), rat, nrats);
    %title(['rat ', num2str(rat)]);

    v_all = [v_all; v];
    b_all = [b_all; b];
    rat_all = [rat_all; repmat(rat, size(b, 1), 1)];
    sv_all = [sv_all; sv];
    sb_all = [sb_all; sb];
    srat_all = [srat_all; repmat(rat, size(sb, 1), 1)];
end

% group-level analysis the right way, for # trials to learn / switch
sv = sv_all;
sb = sb_all;
srat = srat_all;
stbl = table(srat, sv, sb);

% group-level analysis for reward 
formula = 'sv ~ 1 + sb + (1 + sb | srat)';

result = fitglme(stbl, formula, 'Distribution', 'Normal', 'Link', 'Identity', 'FitMethod', 'Laplace');

[beta, names, stats] = fixedEffects(result);
names
H = [0 1];
[p, F, DF1, DF2] = coefTest(result, H);
fprintf('fitglme (session-wise; variability) slope = %f (negative is policy gradient), p = %f, F(%d,%d) = %f\n', H * beta, p, DF1, DF2, F);



%{
v = v_all;
b = b_all;
rat = rat_all;
tbl = table(v, rat, b, sv, sb);

% group-level analysis for reward 
formula = 'v ~ 1 + b + (1 + b | rat)';

result = fitglme(tbl, formula, 'Distribution', 'Normal', 'Link', 'Identity', 'FitMethod', 'Laplace');

[beta, names, stats] = fixedEffects(result);
names
H = [0 1];
[p, F, DF1, DF2] = coefTest(result, H);
fprintf('fitglme (variability) slope = %f (negative is policy gradient), p = %f, F(%d,%d) = %f\n', H * beta, p, DF1, DF2, F);

%}
