% fig_value but for data
% copied stuff from fig_memory2_data and fig_value

load rats_all_blocks.mat;

clear sgn;

nrats = length(ex_rats);
figure;


g = [];

dvars_all = [];
PEs_all = [];
rat_all = [];
for rat = 1:nrats

    [m, dvars, PEs] = fig_value_single(ex_rats(rat), rat, nrats);
    title(['rat ', num2str(rat)]);

    g = [g m(1) > m(2)]; % null = chance (1 = policy gradient; note we plot them flipped) 

    dvars_all = [dvars_all; dvars];
    PEs_all = [PEs_all; PEs];
    rat_all = [rat_all; repmat(rat, size(PEs, 1), 1)];
end

% group-level analysis the right way
%
dvar = dvars_all;
PE = PEs_all;
rat = rat_all;
sgn(PE > 1e-3) = 1;
sgn(PE < -1e-3) = 2;
sgn(abs(PE) < 1e-3) = 0; % TODO what's the deal with categorical regressors...
sgn = categorical(sgn');
tbl = table(dvar, PE, rat, sgn);

formula = 'dvar ~ 1 + PE + (1 + PE | rat)'; % YES!!
%formula = 'dvar ~ -1 + sgn'; % -1 b/c dvar and PE are already centered at 0

result = fitglme(tbl, formula, 'Distribution', 'Normal', 'Link', 'Identity', 'FitMethod', 'Laplace');

[beta, names, stats] = fixedEffects(result);
H = [0 1]; % for PE
%H = [1 -1]; % for sgn
[p, F, DF1, DF2] = coefTest(result, H);
fprintf('fitglme slope = %f (positive is policy gradient), p = %f, F(%d,%d) = %f\n', H * beta, p, DF1, DF2, F);



% group-level analysis the wrong way
%
p = binopdf(sum(g), length(g), 0.5);
g
sum(g) / length(g)
p


figure;
fig_value_single(ex, 1, 1);
title('superrat');

