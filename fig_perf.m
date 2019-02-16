% Figure 2
% plot single-trial variability effect (fig_cond) as function of (recent) past performance = performance estimate

%clear all;
%load fig_cond.mat

figure;

tau = 5; % TODO fit 
rbar = nan(1, ex.n);
for t = 51:ex.n
    rbar(t) = 0;
    for s = 1:50
        rbar(t) = rbar(t) + ex.r(t - s) * exp(-s / tau);
    end
end
rbar = rbar / nanmax(rbar);

lb = [0 0.14 0.29 0.43 0.57 0.71 0.86];
ub = [0.14 0.29 0.43 0.57 0.71 0.86 1];

blue = [0 0 1];
red = [1 0 0];

clear vb;
for bin = 1:length(lb)
    which_bin = (rbar > lb(bin)) & (rbar <= ub(bin));

    which = {(ex.clamp == 1) & which_bin, (ex.clamp == 0) & which_bin};

    ax = -10:15;
    hold on;
    clear v;
    clear hh;
    clear n;
    clear m;
    clear s;
    clear se;
    % TODO dedupe with fig_cond
    for c_idx = 1:2
        ix = find(which{c_idx});
        for i = 1:length(ix)
            for j = 1:length(ax)
                t = ix(i) + ax(j);
                v(i,j) = ex.var(t);
                if ax(j) >= 0 && ax(j) < 5
                    v(i,j) = NaN;
                end
            end
            vb{bin, c_idx}(i) = var(ex.a(ix(i) : ix(i) + 5)); % TODO 10
        end

        n{c_idx} = size(v, 1);
        m{c_idx} = mean(v, 1);
        s{c_idx} = std(v, 1);
        se{c_idx} = std(v, 1) / sqrt(size(v,1));
    end
    vd(bin) = mean(vb{bin, 2}) - mean(vb{bin, 1});
    vsd(bin) = sqrt(var(vb{bin, 2}) + var(vb{bin, 1}));
    vn(bin) = length(vb{bin, 2}) + length(vb{bin, 1});
    vsed(bin) = vsd(bin) / sqrt(vn(bin));

    subplot(3,4,bin+1);
    md = m{2} - m{1};
    sed = sqrt(s{1}.^2 + s{2}.^2) / sqrt(n{1} + n{2}); 

    color{bin} = blue * (7 - bin)/6 + red * (bin - 1) / 6;
    plot(ax, md, 'color', color{bin});
    hold on;

    w = ax < 0;
    h = fill([ax(w) flip(ax(w))], [md(w) + sed(w) flip(md(w) - sed(w))], color{bin});
    set(h, 'facealpha', 0.3, 'edgecolor', 'none');

    w = ax >= 5;
    h = fill([ax(w) flip(ax(w))], [md(w) + sed(w) flip(md(w) - sed(w))], color{bin});
    set(h, 'facealpha', 0.3, 'edgecolor', 'none');
    hold off;

    ylim([-25 50]);
    %ylim([-5 20]);
    title(sprintf('%.2f-%.2f', lb(bin), ub(bin)));

    if bin == 6
        xlabel('trials from condition');
    end
    if bin == 1
        ylabel('\Delta variability (no reward - reward)');
    end
end


% plot population plot (Figure 2C)
%
subplot(3,4,9);
xs = (lb + ub)/2;
hold on;
for bin = 1:length(lb)
    h = bar(xs(bin), vd(bin), 0.08);
    set(h, 'facecolor', color{bin});
end
errorbar(xs, vd, vsed, 'color', 'black', 'linestyle', 'none');
hold off;
xlim([-0.05 1.05]);
xlabel('performance estimate');
ylabel('\Delta variability');


% plot regulated variability
%
rs = 0;
for s = 1:10
    rs = rs + 1/10 * (1 - exp(-1/tau)) * exp(-(s-1)/tau);
end
%vd = vd / rs; % TODO debug

for bin = 1:length(lb)
    cvd(bin) = sum(vd(bin:end)); % TODO do it right / normalize by rs
    cvsed(bin) = sqrt(sum(vsd(bin:end).^2)) / sqrt(sum(vn(bin:end)));
end

subplot(3,4,10);
errorbar(xs, cvd, cvsed, 'color', 'black');
ylim([0 500]);
%ylim([-5 40]);
xlabel('performance estimate');
ylabel('regulated variability');
