% rat performance -- which rat did best


load data.mat;

r = [];
s = [];
for i = 1:length(data)
    r = [r nanmean(data(i).r)];
    s = [s nanstd(data(i).r) / sqrt(sum(~isnan(data(i).r)))];
end

figure;
hold on;
bar(r);
errorbar(r, s, 'color', 'black', 'linestyle', 'none');
hold off;
xlabel('rat');
xticks(1:length(data));
ylabel('avg reward');
