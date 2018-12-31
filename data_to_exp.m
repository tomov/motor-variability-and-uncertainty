% convert real data to format similar to init_exp()
%
clear all;


load('from_paper/task_learn_curves (1).mat');

nrats = size(targs, 1);


for rat = 1:nrats
    rat
    stationary = 1;

    ex(rat) = rat_to_exp(rat, stationary);
end

%fig_raw;

% glue ex's into single "super-rat"
%
ex_rats = ex;
clear ex;

disp('building super-rat');


ex.tar = [];
ex.b = [];
ex.a = [];
ex.r = [];
ex.clamp = [];

for rat = 1:nrats
    ex.tar = [ex.tar ex_rats(rat).tar];
    ex.b = [ex.b ex_rats(rat).b];
    ex.a = [ex.a ex_rats(rat).a];
    ex.r = [ex.r ex_rats(rat).r];
    ex.clamp = [ex.clamp ex_rats(rat).clamp];
end
