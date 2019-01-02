% helper for fig_memory4.m, similar to fig_memory_single.m
% test whether there is "memory" for past target angles
% see if new target is learned faster when it is closer to old target (i.e. when jump was in direction of old target)
%
function [mses, ranges, vlines] = fig_memory_single(ex, rat, nrats)


mses = {[], []};
dists = {[], []};

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

bin_size = 5;
clear cond;
 
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


    if second_last_cnt >= 600 && last_cnt >= 300 && cnt == 40
        % we have enough time points
        trials = t-39:t;

        if abs(second_last_tar - last_tar) > 0
            mse = immse(ex.tar(trials), ex.a(trials));
            dist = abs(tar - last_tar);

            if last_tar >= min(tar, second_last_tar) && last_tar <= max(tar, second_last_tar)
                % previous target between old & new target (i.e. new target is away from old target)
                %
                mses{1} = [mses{1} mse];
                dists{1} = [dists{1} dist];
                fprintf('A: %.3f %.3f %.3f\n', second_last_tar, last_tar, tar);

                ranges{1} = [ranges{1} second_last_start:t+300];
                vlines{1} = [vlines{1} length(ranges{1})];

            else 
                % the opposite -> new target is closer to old target
                %
                mses{2} = [mses{2} mse];
                dists{2} = [dists{2} dist];
                fprintf('B: %.3f %.3f %.3f\n', second_last_tar, last_tar, tar);

                ranges{2} = [ranges{2} second_last_start:t+300];
                vlines{2} = [vlines{2} length(ranges{2})];
            end

        end
    end

end

subplot(2,nrats,rat);
scatter(dists{1}, mses{1});
lsline;
xlabel('distance');
ylabel('MSE');
title('new target away from old target');


subplot(2,nrats,rat + nrats);
scatter(dists{2}, mses{2});
lsline;
xlabel('distance');
ylabel('MSE');
title('new target towards old target');

%nansem = @(x) nanstd(x) / sqrt(sum(~isnan(x)));
%
%m = [nanmean(mses{1}) nanmean(mses{2})];
%s = [nansem(mses{1}) nansem(mses{2})];
%
%
%subplot(1, nrats, rat);
%
%% NOTICE THE FLIPS! makes things easier
%bar(flip(m));
%hold on;
%errorbar(flip(m), flip(s), 'LineStyle', 'none', 'color', 'black');
%hold off;
%xticklabels(flip({'old target', 'new target'}));
%xtickangle(30);
%if rat == 1
%    ylabel('MSE (between press angle and target)');
%end
%
%title(['rat ', num2str(rat)]);
