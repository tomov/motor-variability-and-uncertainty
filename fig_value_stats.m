
if length(rs) == 1
    % single clamped r -> don't include in GLM

    formula = 'var ~ 1 + PE';
    result = fitglme(tbl, formula, 'Distribution', 'Normal', 'Link', 'Identity', 'FitMethod', 'Laplace');
    [beta, names, stats] = fixedEffects(result);
    H = [0 1]
    [p, F, DF1, DF2] = coefTest(result, H);
    fprintf('fitglme PE beta = %f (positive is policy gradient), p = %f, F(%d,%d) = %f\n', H * beta, p, DF1, DF2, F);

else
    formula = 'var ~ 1 + PE + r';
    result = fitglme(tbl, formula, 'Distribution', 'Normal', 'Link', 'Identity', 'FitMethod', 'Laplace');
    [beta, names, stats] = fixedEffects(result);
    H = [0 1 0]
    [p, F, DF1, DF2] = coefTest(result, H);
    fprintf('fitglme PE beta = %f (positive is policy gradient), p = %f, F(%d,%d) = %f\n', H * beta, p, DF1, DF2, F);
end


if length(rs) == 1
    % single r => don't include in GLM
    formula = 'var ~ 1 + rr';
    result = fitglme(tbl, formula, 'Distribution', 'Normal', 'Link', 'Identity', 'FitMethod', 'Laplace');
    [beta, names, stats] = fixedEffects(result);
    H = [0 -1]
    [p, F, DF1, DF2] = coefTest(result, H);
    fprintf('fitglme r - rr contrast: = %f (positive is policy gradient), p = %f, F(%d,%d) = %f\n', H * beta, p, DF1, DF2, F);

else
    formula = 'var ~ 1 + r + rr';
    result = fitglme(tbl, formula, 'Distribution', 'Normal', 'Link', 'Identity', 'FitMethod', 'Laplace');
    [beta, names, stats] = fixedEffects(result);
    H = [0 1 -1]
    [p, F, DF1, DF2] = coefTest(result, H);
    fprintf('fitglme r - rr contrast: = %f (positive is policy gradient), p = %f, F(%d,%d) = %f\n', H * beta, p, DF1, DF2, F);
end
