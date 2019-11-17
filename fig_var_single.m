% test whether outcome variability influences choice variability
% copied stuff from fig_value_single.m

function [v, cond, names] = fig_var_single(ex, rat, nrats, rs, figtitle)



in_block = logical(zeros(size(ex.a)));

bix = find(ismember(ex.bclamp_r, rs));
for i = 1:length(ex)
    s = ex.bclamp_start(bix(i));
    dur = ex.bclamp_dur(bix(i));

    in_block(s : s + dur - 1) = 1;
end

which{1} = [logical([0 0 0 0]) ex.r(1:end-4) == 1 & ex.r(2:end-3) == 1 & ex.r(3:end-2) == 0 & ex.r(4:end-1) == 0 & in_block(1:end-4) & in_block(2:end-3) & in_block(3:end-2) & in_block(4:end-1)];
which{2} = [logical([0 0 0 0]) ex.r(1:end-4) == 0 & ex.r(2:end-3) == 0 & ex.r(3:end-2) == 1 & ex.r(4:end-1) == 1 & in_block(1:end-4) & in_block(2:end-3) & in_block(3:end-2) & in_block(4:end-1)];
which{3} = [logical([0 0 0 0]) ex.r(1:end-4) == 0 & ex.r(2:end-3) == 1 & ex.r(3:end-2) == 0 & ex.r(4:end-1) == 1 & in_block(1:end-4) & in_block(2:end-3) & in_block(3:end-2) & in_block(4:end-1)];
which{4} = [logical([0 0 0 0]) ex.r(1:end-4) == 1 & ex.r(2:end-3) == 0 & ex.r(3:end-2) == 1 & ex.r(4:end-1) == 0 & in_block(1:end-4) & in_block(2:end-3) & in_block(3:end-2) & in_block(4:end-1)];

names = {'1100', '0011', '0101', '1010'};

v = [];
cond = [];
for i = 1:length(which)
    v = [v ex.var(find(which{i}) + 5)];
    cond = [cond i*ones(size(find(which{i})))];
end

v = v';
cond = cond';
