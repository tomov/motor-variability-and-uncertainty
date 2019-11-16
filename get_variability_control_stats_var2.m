function [ax, lb, ub, md, sed, vd, vsd, vn, vsed, cvd, cvsed, stats] = get_variability_control_stats_var2(ex, which_subset)

% copy of get_variability_control_stats TODO dedupe
% but as f'n of reward variance not perf

% for fig 2

if ~exist('which_subset', 'var')
    which_subset = logical(ones(1, ex.n));
end

tau = 5; % TODO fit 
vbar = nan(1, ex.n);
for t = 51:ex.n
    vbar(t) = 0;
    for s = 1:50
        vbar(t) = vbar(t) + ex.var(t - s) * exp(-s / tau);
    end
end
vbar = vbar / nanmax(vbar);

Y = prctile(vbar, [1:15:99]);
lb = Y(1:end-1);
ub = Y(2:end);

for bin = 1:length(lb)
    which_bin = (vbar > lb(bin)) & (vbar <= ub(bin)) & which_subset;

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
        %
        % Delta variability 
        % for each reward rate
stats = [vd          cvd(1)                    nanmean([m{end}{1} m{end}{2}])];
