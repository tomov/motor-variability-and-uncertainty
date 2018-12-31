% test for memory by seeing whether farter targets are learned faster
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

diff = sess_tar(2:end) - sess_tar(1:end-1);
diff = [NaN diff];
diff = abs(diff);

%figure;
%scatter(sess_cnt, diff);

nansem = @(x) nanstd(x) / sqrt(sum(~isnan(x)));
sem = @(x) nanstd(x) / sqrt(length(x));

bin_size = 5;
m = [];
s = [];
for bin = 1:ceil(max(diff) / bin_size)
    d_min = (bin - 1) * bin_size;
    d_max = bin * bin_size;
    which = diff >= d_min & diff < d_max;
    cnts = sess_cnt(which);

    m(bin) = mean(cnts);
    s(bin) = sem(cnts);
end

figure;
bar(m);
hold on;
errorbar(m, s, 'LineStyle', 'none', 'color', 'black');
hold off;

xlabel('distance to new target');
ylabel('# sessions to learn new target');
