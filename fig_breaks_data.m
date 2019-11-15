% fig_breaks but for data
% copied stuff from fig_value_data 

% TODO actually change accordingly

%load rats_all_blocks.mat;
%
%
%nrats = length(ex_rats);
%figure;
%
%
%g = [];
%
%dvars_all = [];
%PEs_all = [];
%rat_all = [];
%r_all = [];
%rr_all = [];
%for rat = 1:nrats
%
%    [m, dvars, PEs, r, rr] = fig_breaks_single(ex_rats(rat), rat, nrats);
%    title(['rat ', num2str(rat)]);
%
%    g = [g m(1) > m(2)]; % null = chance (1 = policy gradient; note we plot them flipped) 
%
%    dvars_all = [dvars_all; dvars];
%    PEs_all = [PEs_all; PEs];
%    rat_all = [rat_all; repmat(rat, size(PEs, 1), 1)];
%    r_all = [r_all; r];
%    rr_all = [rr_all; rr];
%end
%
%% group-level analysis the right way
%%
%dvar = dvars_all;
%PE = PEs_all;
%rat = rat_all;
%r = r_all;
%rr = rr_all;
%tbl = table(dvar, PE, rat, r, rr);
%
%formula = 'dvar ~ 1 + PE + r + (1 + PE + r | rat)';
%result = fitglme(tbl, formula, 'Distribution', 'Normal', 'Link', 'Identity', 'FitMethod', 'Laplace');
%[beta, names, stats] = fixedEffects(result);
%H = [0 1 0]
%[p, F, DF1, DF2] = coefTest(result, H);
%fprintf('fitglme PE beta = %f (positive is policy gradient), p = %f, F(%d,%d) = %f\n', H * beta, p, DF1, DF2, F);
%
%
%formula = 'dvar ~ 1 + r + rr + (1 + r + rr | rat)';
%result = fitglme(tbl, formula, 'Distribution', 'Normal', 'Link', 'Identity', 'FitMethod', 'Laplace');
%[beta, names, stats] = fixedEffects(result);
%H = [0 1 -1]
%[p, F, DF1, DF2] = coefTest(result, H);
%fprintf('fitglme r - rr contrast: = %f (positive is policy gradient), p = %f, F(%d,%d) = %f\n', H * beta, p, DF1, DF2, F);
%
%
%
%% group-level analysis the wrong way
%%
%p = binopdf(sum(g), length(g), 0.5);
%g
%sum(g) / length(g)
%p
%
%
%figure;
%fig_value_single(ex, 1, 1);
%title('superrat');
%