


% don't look at dvar -- it's selecting for cases where reward rate was lower/higher to begin with

if length(rs) == 1
    % single clamped r -> don't include in GLM
    formula = 'var ~ 1 + PE';
    result = fitglme(tbl, formula, 'Distribution', 'Normal', 'Link', 'Identity', 'FitMethod', 'Laplace');
    [beta, names, stats] = fixedEffects(result);
    H = [0 1]
    [p, F, DF1, DF2] = coefTest(result, H);
    fprintf('fitglme PE beta = %f (positive is policy gradient), p = %f, F(%d,%d) = %f\n', H * beta, p, DF1, DF2, F);


    if ismember('rat', tbl.Properties.VariableNames)
        formula = 'var ~ 1 + PE + (1 + PE | rat)';
        result = fitglme(tbl, formula, 'Distribution', 'Normal', 'Link', 'Identity', 'FitMethod', 'Laplace');
        [beta, names, stats] = fixedEffects(result);
        H = [0 1]
        [p, F, DF1, DF2] = coefTest(result, H);
        fprintf('(mixed effects fit) fitglme PE beta = %f (positive is policy gradient), p = %f, F(%d,%d) = %f\n', H * beta, p, DF1, DF2, F);


        c = categorical(PE > 0);
        tbl = [tbl table(c)];

        formula = 'var ~ 1 + c + (1 + c | rat)';
        result = fitglme(tbl, formula, 'Distribution', 'Normal', 'Link', 'Identity', 'FitMethod', 'Laplace');
        [beta, names, stats] = fixedEffects(result);
        H = [0 1]
        [p, F, DF1, DF2] = coefTest(result, H);
        fprintf('(mixed effects fit) fitglme PE beta = %f (positive is policy gradient), p = %f, F(%d,%d) = %f\n', H * beta, p, DF1, DF2, F);
    end

else
    formula = 'var ~ 1 + PE + r';
    result = fitglme(tbl, formula, 'Distribution', 'Normal', 'Link', 'Identity', 'FitMethod', 'Laplace');
    [beta, names, stats] = fixedEffects(result);
    H = [0 1 0]
    [p, F, DF1, DF2] = coefTest(result, H);
    fprintf('fitglme PE beta = %f (positive is policy gradient), p = %f, F(%d,%d) = %f\n', H * beta, p, DF1, DF2, F);
    
    if ismember('rat', tbl.Properties.VariableNames)
        formula = 'var ~ 1 + PE + r + (1 + PE + r | rat)';
        result = fitglme(tbl, formula, 'Distribution', 'Normal', 'Link', 'Identity', 'FitMethod', 'Laplace');
        [beta, names, stats] = fixedEffects(result);
        H = [0 1 0]
        [p, F, DF1, DF2] = coefTest(result, H);
        fprintf('(mixed) fitglme PE beta = %f (positive is policy gradient), p = %f, F(%d,%d) = %f\n', H * beta, p, DF1, DF2, F);
    end
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

    if ismember('rat', tbl.Properties.VariableNames)
        formula = 'var ~ 1 + r + rr + (1 + r + rr | rat)';
        result = fitglme(tbl, formula, 'Distribution', 'Normal', 'Link', 'Identity', 'FitMethod', 'Laplace');
        [beta, names, stats] = fixedEffects(result);
        H = [0 1 -1]
        [p, F, DF1, DF2] = coefTest(result, H);
        fprintf('(mixed) fitglme r - rr contrast: = %f (positive is policy gradient), p = %f, F(%d,%d) = %f\n', H * beta, p, DF1, DF2, F);
    end
end

