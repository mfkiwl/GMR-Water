function [refl_h, id, psd, pks] = mp2RH_lsp(sinelv, M, hell, hgtlim, a, b)

rh_lim = hell - hgtlim;
f_lim = rh_lim./a;
fi = f_lim(2):1:f_lim(1);

maxf1 = numel(sinelv) / (2*(max(sinelv)-min(sinelv)));
fi = 1:maxf1;
prec1 = 0.001;
ovs = round(2*a/(2*prec1*(max(sinelv)-min(sinelv))));
% fi = 1:1:maxf1;
[psd,f,~,~,~,~] = fLSPw(sinelv,M,fi,0.05,ovs);
psd = cell2mat(psd);
f = cell2mat(f);

refl_h = f * a + b;
surface_h = hell - refl_h;

% valid_indx = surface_h>hgtlim(1) & surface_h<hgtlim(2);
% refl_h = refl_h(valid_indx);
% psd = psd(valid_indx);
[~,id] = max(psd(:));

try
    pks = findpeaks(psd);
catch
    pks = nan;
    return
end
pks = sort(pks);

%% Visual
if 0
    figure
    plot(sinelv, M, 'LineWidth', 2, 'DisplayName','Multipath');
    hold on
    legend('Location','northwest','FontSize',24,'FontWeight','bold','EdgeColor','None')
    box off
    xlabel('sine')
    ylabel('multipath')
    set(gca, 'FontSize', 24, 'FontWeight','bold', 'LineWidth', 2)
    hold off

    figure
    tiledlayout(1,2,"TileSpacing","loose")
    nexttile
    plot(sinelv, M, 'LineWidth', 2, 'DisplayName','reflected part');
    xlabel('sine')
    legend('Location','northwest','FontSize',24,'FontWeight','bold','EdgeColor','None')
    set(gca, 'FontSize', 24, 'FontWeight','bold', 'LineWidth', 2)
    xlim([min(sinelv), max(sinelv)])
    box off
    nexttile
    plot(refl_h, psd, 'LineWidth',2)
    set(gca, 'FontSize', 24, 'FontWeight','bold', 'LineWidth', 2)
    hold on
    refl_h_peak = refl_h(id);
    plot(refl_h_peak, pks(end), 'ro', 'MarkerSize', 10, 'LineWidth', 2, 'MarkerFaceColor','r');
    text(refl_h_peak, 0, sprintf(' RH=%.2fm', refl_h_peak), ...
        'VerticalAlignment','bottom', 'HorizontalAlignment','right', ...
        'FontSize', 20, 'FontWeight','bold','Color', 'red');
    yLimits = ylim;
    line([refl_h_peak, refl_h_peak], yLimits, 'Color', 'r', 'LineStyle', '--', 'LineWidth', 2);
    xlabel('RH=\lambdaf/2 in meter')
    ylabel('Amplitude')
    box off
end
end