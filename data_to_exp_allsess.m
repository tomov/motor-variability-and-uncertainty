% convert real data to format similar to init_exp()
% concatenate all rats into one "super rat"
% for all sessions, inc. block clamp sessions (copy of data_to_exp_blocks.m)
%
clear all;


load('from_paper/task_learn_curves (1).mat');

nrats = size(targs, 1);


for rat = 1:nrats
    rat

    ex(rat) = rat_to_exp_allsess(rat);
end

ex_rats = ex;
clear ex;



ex.tar = [];
ex.b = [];
ex.a = [];
ex.r = [];
ex.var = [];
ex.clamp = [];
ex.bclamp_start = [];
ex.bclamp_dur = [];
ex.bclamp_r = [];
ex.breaks = [];


for rat = 1:nrats
    ex.tar = [ex.tar ex_rats(rat).tar];
    ex.b = [ex.b ex_rats(rat).b];
    ex.a = [ex.a ex_rats(rat).a];
    ex.r = [ex.r ex_rats(rat).r];
    ex.var = [ex.var ex_rats(rat).var];
    ex.clamp = [ex.clamp ex_rats(rat).clamp];
    ex.bclamp_start = [ex.bclamp_start ex_rats(rat).bclamp_start];
    ex.bclamp_dur = [ex.bclamp_dur ex_rats(rat).bclamp_dur];
    ex.bclamp_r = [ex.bclamp_r ex_rats(rat).bclamp_r];
    ex.breaks = [ex.breaks ex_rats(rat).breaks];
end

save rats_all_sess.mat
