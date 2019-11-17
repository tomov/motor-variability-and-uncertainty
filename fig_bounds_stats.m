
% session-wise
%
if ismember('rat', stbl.Properties.VariableNames)
    formula = 'sv ~ 1 + sb + (1 + sb | srat)';
else
    formula = 'sv ~ 1 + sb';
end

result = fitglme(stbl, formula, 'Distribution', 'Normal', 'Link', 'Identity', 'FitMethod', 'Laplace');

[beta, names, stats] = fixedEffects(result);
names
H = [0 1];
[p, F, DF1, DF2] = coefTest(result, H);
fprintf('fitglme (session-wise; variability) slope = %f (negative is policy gradient), p = %f, F(%d,%d) = %f\n', H * beta, p, DF1, DF2, F);



% trial-wise WRONG -- independence assumption
%
%{

if ismember('rat', tbl.Properties.VariableNames)
    formula = 'v ~ 1 + b + (1 + b | rat)';
else
    formula = 'sv ~ 1 + sb';
end

result = fitglme(tbl, formula, 'Distribution', 'Normal', 'Link', 'Identity', 'FitMethod', 'Laplace');

[beta, names, stats] = fixedEffects(result);
names
H = [0 1];
[p, F, DF1, DF2] = coefTest(result, H);
fprintf('fitglme (variability) slope = %f (negative is policy gradient), p = %f, F(%d,%d) = %f\n', H * beta, p, DF1, DF2, F);

%}
