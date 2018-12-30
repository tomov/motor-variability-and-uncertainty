% fig_cond.m using actual data
%

load('from_paper/task_learn_curves (1).mat');

rat = 1;
stationary = 1;

tar = targs{rat, stationary};
b = bndWidth{rat, stationary};
nsess = length(tar);


sess_size = 300;
ex.session_size = sess_size;
ex.nsessions = nsess;
ex.n = ex.nsessions * ex.session_size;


% create experiment from data
%
ex.tar = inf(1, sess_size * nsess); % trial-by-trial target
ex.b = inf(1, sess_size * nsess); % trial-by-trial boundary
ex.a = inf(1, sess_size * nsess); % trial-by-trial action / angle of animal
ex.r = inf(1, sess_size * nsess); % trial-by-trial reward
ex.clamp = inf(1, sess_size * nsess); % trial-by-trial mini reward clamps
for s = 1:nsess
    da = angSess{rat, stationary}(s,:);
    r = rewSess{rat, stationary}(s,:);
    clamp = probRewSess{rat, stationary}(s,:);
    for i = 1:sess_size
        t = (s - 1) * sess_size + i;
        ex.tar(t) = tar(s);
        ex.a(t) = da(i) + tar(s);
        ex.b(t) = b(s);
        ex.r(t) = r(i);
        ex.clamp(t) = clamp(i);

        if t >= 5
            ex.var(t) = var(ex.a(t-4:t));
        else
            ex.var(t) = NaN;
        end
    end
end


fig_raw;
