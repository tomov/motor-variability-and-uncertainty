% test whether there is "memory" for past target angles
% see if subject does better if a past angle is 
%


min_trials = 600; % two sessions

mses = {[], []};

second_last_tar = NaN;
second_last_cnt = 0;
last_tar = NaN;
last_cnt = 0;
tar = NaN;
cnt = 0;
for t = 1:length(ex.a)
    if tar ~= ex.tar(t)
        % target switched
        second_last_tar = last_tar;
        second_last_cnt = last_cnt;
        last_tar = tar;
        last_cnt = cnt;
        tar = ex.tar(t);
        cnt = 1;
    else
        cnt = cnt + 1;
    end


    if second_last_cnt >= 300 && last_cnt >= 300 && cnt >= 20
        % we have enough time points
        trials = t-15:t;

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
end



nansem = @(x) nanstd(x) / sqrt(sum(~isnan(x)));

m = [nanmean(mses{1}) nanmean(mses{2})];
s = [nansem(mses{1}) nansem(mses{2})];

figure;
bar(m);
hold on;
errorbar(m, s, 'LineStyle', 'none', 'color', 'black');
hold off;
xticklabels({'old target', 'new target'});
