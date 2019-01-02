% test if MSE / variability after break is greater
%
function [mses, vars] = fig_breaks_single(ex, rat, nrats)

mses = {[], []};
vars = {[], []};

for t = ex.session_size : ex.session_size : ex.n-1
    trials = t+1:t+5;

    ex_a = ex.a(trials);
    which = ~isnan(ex_a);
    ex_tar = ex.tar(trials);
    mse = immse(ex_tar(which), ex_a(which));
    vari = var(ex_a(which));

    if ex.breaks(t) > 0
        mses{1} = [mses{1} mse];
        vars{1} = [vars{1} vari];
    else
        mses{2} = [mses{2} mse];
        vars{2} = [vars{2} vari];
    end
end


nansem = @(x) nanstd(x) / sqrt(sum(~isnan(x)));

m = [nanmean(mses{1}) nanmean(mses{2})];
s = [nansem(mses{1}) nansem(mses{2})];

save shit.mat

subplot(1, nrats, rat);
bar(m);
hold on;
errorbar(m, s, 'LineStyle', 'none', 'color', 'black');
hold off;
xticklabels({'after break', 'no break'});
ylabel('MSE');

title(['rat ', num2str(rat)]);
