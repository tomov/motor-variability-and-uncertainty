% test for thompson by seeing whether farter targets have higher initial rewards 
%

%clear;

load rats_all.mat;

nrats = length(ex_rats);
figure;

rs = [];

v_all = [];
b_all = [];
sv_all = [];
sb_all = [];
sr_all = [];
rat_all = [];
srat_all = [];
for rat = 1:nrats

    stationary = 1;

    [v, b, sv, sb, sr] = fig_bounds_single(ex_rats(rat), rat, nrats);
    %title(['rat ', num2str(rat)]);

    v_all = [v_all; v];
    b_all = [b_all; b];
    rat_all = [rat_all; repmat(rat, size(b, 1), 1)];
    sv_all = [sv_all; sv];
    sb_all = [sb_all; sb];
    sr_all = [sr_all; sr];
    srat_all = [srat_all; repmat(rat, size(sb, 1), 1)];
end

sv = sv_all;
sb = sb_all;
sr = sr_all;
srat = srat_all;
stbl = table(srat, sv, sb, sr);


v = v_all;
b = b_all;
rat = rat_all;
tbl = table(v, rat, b);

fig_bounds_stats
