% test for memory by seeing whether frequent targets are easier / more likely to be chosen
%

tar = NaN;
cnt = 0;

sess_tar = [];
sess_cnt = [];

for t = 1:length(ex.a)
    if tar ~= ex.tar(t)
        % target switched
        %
        if ~isnan(tar)
            sess_cnt = [sess_cnt cnt];
            sess_tar = [sess_tar tar];
        end

        tar = ex.tar(t);
        cnt = 1;
    else
        cnt = cnt + 1;
    end
end

sess_cnt = [sess_cnt cnt];
sess_tar = [sess_tar tar];

freq = [NaN NaN];
idx = 1:length(sess_tar);
for i = 3:length(sess_tar)
    old_tars = idx <= i-2 & idx >= i - 50;
    close_tars = abs(sess_tar(i) - sess_tar) < 5;
    f = sum(sess_cnt(close_tars & old_tars)) / sum(sess_cnt(old_tars));
    freq = [freq f];
end

figure;
scatter(sess_cnt, freq);

nansem = @(x) nanstd(x) / sqrt(sum(~isnan(x)));
sem = @(x) nanstd(x) / sqrt(length(x));

bin_size = 0.05;
m = [];
s = [];
for bin = 1:ceil(max(freq) / bin_size)
    f_min = (bin - 1) * bin_size;
    f_max = bin * bin_size;
    which = freq >= f_min & freq < f_max;
    cnts = sess_cnt(which);

    m(bin) = mean(cnts);
    s(bin) = sem(cnts);
end

figure;
bar(m);
hold on;
errorbar(m, s, 'LineStyle', 'none', 'color', 'black');
hold off;

xlabel('frequency of new target among old targets');
ylabel('# sessions to learn new target');
