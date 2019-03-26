% fig_value but for policy

load policy_T=100_300000_nonstationary.mat;

%rs =  [0.1 0.35 0.75]; % all blocks
rs =  [0.35]; % middle blocks only

figure;
[m, dvars, PEs, r, rr] = fig_value_single(ex, 1, 1, rs, 'policy gradient');



% group-level analysis the right way
%
dvar = dvars;
PE = PEs;
tbl = table(dvar, PE, r, rr);

if length(rs) == 1
    % single clamped r -> don't include in GLM

    formula = 'dvar ~ 1 + PE';
    result = fitglme(tbl, formula, 'Distribution', 'Normal', 'Link', 'Identity', 'FitMethod', 'Laplace');
    [beta, names, stats] = fixedEffects(result);
    H = [0 1]
    [p, F, DF1, DF2] = coefTest(result, H);
    fprintf('fitglme PE beta = %f (positive is policy gradient), p = %f, F(%d,%d) = %f\n', H * beta, p, DF1, DF2, F);

else
    formula = 'dvar ~ 1 + PE + r';
    result = fitglme(tbl, formula, 'Distribution', 'Normal', 'Link', 'Identity', 'FitMethod', 'Laplace');
    [beta, names, stats] = fixedEffects(result);
    H = [0 1 0]
    [p, F, DF1, DF2] = coefTest(result, H);
    fprintf('fitglme PE beta = %f (positive is policy gradient), p = %f, F(%d,%d) = %f\n', H * beta, p, DF1, DF2, F);
end


if length(rs) == 1
    % single r => don't include in GLM
    formula = 'dvar ~ 1 + rr';
    result = fitglme(tbl, formula, 'Distribution', 'Normal', 'Link', 'Identity', 'FitMethod', 'Laplace');
    [beta, names, stats] = fixedEffects(result);
    H = [0 -1]
    [p, F, DF1, DF2] = coefTest(result, H);
    fprintf('fitglme r - rr contrast: = %f (positive is policy gradient), p = %f, F(%d,%d) = %f\n', H * beta, p, DF1, DF2, F);

else
    formula = 'dvar ~ 1 + r + rr';
    result = fitglme(tbl, formula, 'Distribution', 'Normal', 'Link', 'Identity', 'FitMethod', 'Laplace');
    [beta, names, stats] = fixedEffects(result);
    H = [0 1 -1]
    [p, F, DF1, DF2] = coefTest(result, H);
    fprintf('fitglme r - rr contrast: = %f (positive is policy gradient), p = %f, F(%d,%d) = %f\n', H * beta, p, DF1, DF2, F);
end
