function [ax, r_m, r_se, m, se, stats] = get_block_stats(ex)



ax = -30 : 130;

rs = [0.1 0.35 0.75];

% rewards 
%

for c_idx = 1:3
    bix = find(ex.bclamp_r == rs(c_idx));
    clear r;
    for i = 1:length(bix)
        start = ex.bclamp_start(bix(i));
        d = ex.bclamp_dur(bix(i));
        e = start + d - 1;
        for j = 1:length(ax)
            t = start + ax(j);
            r(i,j) = ex.r(t);
        end
    end

    r_m{c_idx} = mean(r, 1);
    r_s{c_idx} = std(r, 1);
    r_se{c_idx} = r_s{c_idx} / sqrt(size(r, 1)); 

end

% variability
%

for c_idx = 1:3
    bix = find(ex.bclamp_r == rs(c_idx));
    clear v;
    for i = 1:length(bix)
        start = ex.bclamp_start(bix(i));
        for j = 1:length(ax)
            t = start + ax(j);
            v(i,j) = ex.var(t);
        end
    end

    m{c_idx} = mean(v, 1);
    s{c_idx} = std(v, 1);
    se{c_idx} = s{c_idx} / sqrt(size(v, 1)); 
end



base_r = mean([mean(r_m{1}(ax < 0)) mean(r_m{2}(ax < 0)) mean(r_m{3}(ax < 0))]);

base_v = mean([mean(m{1}(ax < 0)) mean(m{2}(ax < 0)) mean(m{3}(ax < 0))]);
low_v = mean(m{1}(ax >= 20 & ax < 100)) - base_v;
med_v = mean(m{2}(ax >= 20 & ax < 100)) - base_v;
hi_v = mean(m{3}(ax >= 20 & ax < 100)) - base_v;

stats = [base_r low_v med_v hi_v];
