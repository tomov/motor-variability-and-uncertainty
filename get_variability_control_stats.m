function [ax, lb, ub, md, sed, vd, vsd, vn, vsed, cvd, cvsed, stats] = get_variability_control_stats(ex)

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

for bin = 1:length(lb)
    which_bin = (rbar > lb(bin)) & (rbar <= ub(bin));

    which = {(ex.clamp == 1) & which_bin, (ex.clamp == 0) & which_bin};

    [ax, m{bin}, se{bin}, md{bin}, sed{bin}, ~, vd(bin), vsd(bin), vn(bin), vsed(bin)] = get_single_trial_stats(ex, which);

end

% regulated variability
%
rs = 0;
for s = 1:10
    rs = rs + 1/10 * (1 - exp(-1/tau)) * exp(-(s-1)/tau);
end
%vd = vd / rs; % TODO debug

for bin = 1:length(lb)
    cvd(bin) = sum(vd(bin:end)); % TODO do it right / normalize by rs ?
    cvsed(bin) = sqrt(sum(vsd(bin:end).^2)) / sqrt(sum(vn(bin:end)));
end


        % Fig 2B's   regulated variability     unregulated variability TODO ?
stats = [vd          cvd(1)                    nanmean([m{end}{1} m{end}{2}])];
