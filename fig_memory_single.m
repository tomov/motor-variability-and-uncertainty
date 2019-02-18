% helper for fig_memory.m
% test whether there is "memory" for past target angles
% see if subject does better if an old target pops up again
%
function [mses, ranges, vlines, y, v, d1, d2, aa, tt, ttar, ttar1, ttar2] = fig_memory_single(ex, rat, nrats)


mses = {[], []};

second_last_tar = NaN;
second_last_cnt = 0;
second_last_start = NaN;
last_tar = NaN;
last_cnt = 0;
last_start = NaN;
tar = NaN;
cnt = 0;
start = NaN;

ranges = {[], []};
vlines = {[], []};

if ismember(rat, [4, 6, 8])
    thresh = 4;
else
    thresh = 1;
end

y = [];
v = [];
d1 = [];
d2 = [];

aa = [];
tt = [];
ttar = [];
ttar1 = [];
ttar2 = [];
 
for t = 1:length(ex.a)
    if tar ~= ex.tar(t)
        % target switched
        second_last_tar = last_tar;
        second_last_cnt = last_cnt;
        second_last_start = last_start;
        last_tar = tar;
        last_cnt = cnt;
        last_start = start;
        tar = ex.tar(t);
        cnt = 1;
        start = t;
    else
        cnt = cnt + 1;
    end


    ntrials_back = 20;
    if second_last_cnt >= 300 && last_cnt >= 300 && cnt == ntrials_back
        % we have enough time points
        trials = t-ntrials_back+1:t;

        mse = nanmean((ex.tar(trials) - ex.a(trials)).^2);
        vv = nanvar(ex.a(trials));

        y = [y; mse];
        v = [v; vv];
        d1 = [d1; abs(tar - last_tar)];
        d2 = [d2; abs(last_tar - second_last_tar)];

        aa = [aa; ex.a(trials)'];
        tt = [tt; (1:ntrials_back)'];
        ttar = [ttar; repmat(tar, ntrials_back, 1)];
        ttar1 = [ttar1; repmat(last_tar, ntrials_back, 1)];
        ttar2 = [ttar2; repmat(second_last_tar, ntrials_back, 1)];

        if abs(second_last_tar - last_tar) > 10
            % -- we weed out nan's when we take the means and sem's
            %{
            ex_a = ex.a(trials);
            which = ~isnan(ex_a);
            ex_tar = ex.tar(trials);
            mse = immse(ex_tar(which), ex_a(which));
            %}

            % the last two targets are far apart
            %
            if second_last_tar >= min(tar, last_tar) && second_last_tar <= max(tar, last_tar) && abs(tar - second_last_tar) <= thresh
                % old target between previous & new target
                %
                mses{1} = [mses{1} mse];
                %fprintf('A: %.3f %.3f %.3f\n', second_last_tar, last_tar, tar);

                ranges{1} = [ranges{1} second_last_start:t+300];
                vlines{1} = [vlines{1} length(ranges{1})];

            elseif tar >= min(second_last_tar, last_tar) && tar <= max(second_last_tar, last_tar) %&& abs(tar - last_tar) > 2 && abs(tar - second_last_tar) > 2
                % new target between old & previous target
                %
                mses{2} = [mses{2} mse];
                %fprintf('B: %.3f %.3f %.3f\n', second_last_tar, last_tar, tar);

                ranges{2} = [ranges{2} second_last_start:t+300];
                vlines{2} = [vlines{2} length(ranges{2})];
            end

        end
    end

    %{
    if second_last_cnt >= 300 && last_cnt >= 300 && cnt == 30
        % we have enough time points
        trials = t-25:t;

        if abs(second_last_tar - last_tar) > 15 
            % the last two targets are far apart
            %
            if second_last_tar >= min(tar, last_tar) && second_last_tar <= max(tar, last_tar) && abs(tar - second_last_tar) <= 5
                % old target between previous & new target
                %
                mse = immse(ex.tar(trials), ex.a(trials));
                mses{1} = [mses{1} mse];
                fprintf('A: %.3f %.3f %.3f\n', second_last_tar, last_tar, tar);

            elseif tar >= min(second_last_tar, last_tar) && tar <= max(second_last_tar, last_tar)
                % new target between old & previous target
                %
                mse = immse(ex.tar(trials), ex.a(trials));
                mses{2} = [mses{2} mse];
                %fprintf('B: %.3f %.3f %.3f\n', second_last_tar, last_tar, tar);
            end

        end
    end
    %}



    %{
    if second_last_cnt >= 300 && last_cnt >= 300 && cnt == 30
        % we have enough time points
        trials = t-25:t;

        if second_last_tar >= -20 && second_last_tar <= -10 && last_tar >= 10 && last_tar <= 20
            % went from left to right, then went...
            %
            if tar >= -20 && tar <= -10
                % back to old target
                %
                mse = immse(ex.tar(trials), ex.a(trials));
                mses{1} = [mses{1} mse];

            elseif tar >= -5 && tar <= 5
                % back to new target between old & previous target
                %
                mse = immse(ex.tar(trials), ex.a(trials));
                mses{2} = [mses{2} mse];
            end

        elseif second_last_tar >= 10 && second_last_tar <= 20 && last_tar >= -20 && last_tar <= -10
            % went from right to left, then went...
            %
            if tar >= 10 && tar <= 20
                % back to old target
                %
                mse = immse(ex.tar(trials), ex.a(trials));
                mses{1} = [mses{1} mse];

            elseif tar >= -5 && tar <= 5
                % back to new target between old & previous target
                %
                mse = immse(ex.tar(trials), ex.a(trials));
                mses{2} = [mses{2} mse];
            end
        end
    end
    %}
end



nansem = @(x) nanstd(x) / sqrt(sum(~isnan(x)));

m = [nanmean(mses{1}) nanmean(mses{2})];
s = [nansem(mses{1}) nansem(mses{2})];


subplot(1, nrats, rat);

% NOTICE THE FLIPS! makes things easier
bar(flip(m));
hold on;
errorbar(flip(m), flip(s), 'LineStyle', 'none', 'color', 'black');
hold off;
xticklabels(flip({'old target', 'new target'}));
xtickangle(30);
if rat == 1
    ylabel('MSE (between press angle and target)');
end

title(['rat ', num2str(rat)]);
