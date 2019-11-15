function [ax, labels, md, sed, vd, vsd, vn, vsed, cvd, cvsed, stats] = get_variability_control_stats_var(ex, which_subset)

% same as get_variability_control_stats TODO dedupe
% but as f'n of reward variance not perf

if ~exist('which_subset', 'var')
    which_subset = logical(ones(1, ex.n));
end

tau = 5; % TODO fit 


labels = {'11', '01', '10', '00'};

which_bin{1} = [logical([0 0])  ex.clamp(1:end-2) == 1 & ex.clamp(2:end-1) == 1];
which_bin{2} = [logical([0 0])  ex.clamp(1:end-2) == 0 & ex.clamp(2:end-1) == 1];
which_bin{3} = [logical([0 0])  ex.clamp(1:end-2) == 1 & ex.clamp(2:end-1) == 0];
which_bin{4} = [logical([0 0])  ex.clamp(1:end-2) == 0 & ex.clamp(2:end-1) == 0];


for bin = 1:length(which_bin)
    which_b = which_bin{bin} & which_subset;

    which = {(ex.clamp == 1) & which_b, (ex.clamp == 0) & which_b};

    [ax, m{bin}, se{bin}, md{bin}, sed{bin}, ~, vd(bin), vsd(bin), vn(bin), vsed(bin)] = get_single_trial_stats(ex, which);

end

% regulated variability
%
rs = 0;
for s = 1:10
    rs = rs + 1/10 * (1 - exp(-1/tau)) * exp(-(s-1)/tau);
end
%vd = vd / rs; % TODO debug

for bin = 1:length(which_bin)
    cvd(bin) = sum(vd(bin:end)); % TODO do it right / normalize by rs ?
    cvsed(bin) = sqrt(sum(vsd(bin:end).^2)) / sqrt(sum(vn(bin:end)));
end


        % Fig 2B's   regulated variability     unregulated variability TODO ?
        %
        % Delta variability 
        % for each reward rate
stats = [vd          cvd(1)                    nanmean([m{end}{1} m{end}{2}])];
