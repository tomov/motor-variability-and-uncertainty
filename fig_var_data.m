% fig_var but for data -- does outcome variability (e.g. 1100 vs. 1010) predict choice variability 
% copied stuff from  fig_value_data

load rats_all_sess.mat;
rs =  [0.1 0.35 0.75]; % all blocks
%rs =  [0.35]; 

nrats = length(ex_rats);
figure;


g = [];

v_all = [];
cond_all = [];
rat_all = [];
for rat = 1:nrats

    [v, cond, names] = fig_var_single(ex_rats(rat), rat, nrats, rs);

    v_all = [v_all; v];
    cond_all = [cond_all; cond];
    rat_all = [rat_all; repmat(rat, size(v, 1), 1)];
end

% group-level analysis the right way
%
v = v_all;
cond = cond_all;
rat = rat_all;
c = categorical(cond);

tbl = table(v, c, rat);




formula = 'v ~ 1 + 1*c + (1 + 1*c | rat)';

result = fitglme(tbl, formula, 'Distribution', 'Normal', 'Link', 'Identity', 'FitMethod', 'Laplace');

disp(result)

[h,p,ci,stat] = ttest2(v(cond == 1 | cond == 2), v(cond == 3 | cond == 4))
