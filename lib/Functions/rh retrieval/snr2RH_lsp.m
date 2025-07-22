function [refl_h, id, psd, pks, dsnr, f] = snr2RH_lsp(sinelv, snr, wave_length, hell, hgtlim)

% detrend
p = polyfit(sinelv, snr, 2);
dsnr = snr - polyval(p, sinelv);

rh_lim = hell - hgtlim;
% f_lim = 2*rh_lim./wave_length;
% maxf1 = numel(sinelv) / (2*(max(sinelv)-min(sinelv)));
% prec1 = 0.01;
% ovs = round(wave_length/(2*prec1*(max(sinelv)-min(sinelv))));
% fi = 1:1:f_lim(1);
% [psd,f,~,~,~,~] = fLSPw(sinelv,dsnr,fi,0.05,ovs);
% psd = cell2mat(psd);
% f = cell2mat(f);

if sinelv(2) -  sinelv(1) < 0
    sinelv = flipud(sinelv);
    dsnr = flipud(dsnr);
end
[ofac, hifac] = get_ofac_hifac(asind(sinelv), (wave_length/2), rh_lim(1), 0.01);
maxf = numel(sinelv) / (2*(max(sinelv)-min(sinelv)));
[psd, f] = plomb(dsnr, sinelv, maxf*hifac, round(ofac));
psd = 2 * sqrt(psd / length(sinelv));
refl_h = f.*0.5*wave_length;
vind = refl_h>rh_lim(2) & refl_h<rh_lim(1);
psd = psd(vind);
f = f(vind);
refl_h = refl_h(vind);

[~,id] = max(psd(:));
try
    pks = findpeaks(psd);
catch
    pks = nan;
    return
end
pks = sort(pks);

% model = @(p, x) p(1) * cos(p(2)*x + p(3)) .* exp(p(4) * x);
% p0 = [(max(dsnr)-min(dsnr))/2, 4*pi*refl_h(id)/wave_length, 0, 0];
% lp = [0, 4*pi*rh_lim(2)/wave_length, -pi, 0];
% up = [Inf, 4*pi*rh_lim(1)/wave_length, pi, Inf];
% opts = optimoptions('lsqcurvefit','Algorithm','levenberg-marquardt','Display','off');
% p_fit = lsqcurvefit(model, p0, sinelv, dsnr, lp, up, opts);
% p_fit(2)*wave_length/(4*pi)
% plot(sinelv, model(p_fit, sinelv))
% hold on
% plot(sinelv, dsnr)
% hold off
% dsnr = model(p_fit, sinelv);
% prec1 = 0.001;
% ovs = round(wave_length/(2*prec1*(max(sinelv)-min(sinelv))));
% % fi = 1:1:maxf1;
% [psd,f,~,~,~,~] = fLSPw(sinelv,dsnr,fi,0.05,ovs);
% psd = cell2mat(psd);
% f = cell2mat(f);
% % [psd, f] = plomb(dsnr, sinelv, [], ovs, "power");
% refl_h = f.*0.5*wave_length;
% surface_h = hell - refl_h;
% [~,id] = max(psd(:));
% try
%     pks = findpeaks(psd);
% catch
%     pks = nan;
%     return
% end
% pks = sort(pks);
%% Visual
if 0
    figure
    plot(sinelv, snr, 'LineWidth', 2, 'DisplayName','SNR');
    hold on
    plot(sinelv, polyval(p, sinelv), "LineWidth", 2, 'DisplayName','Polynomial detrending')
    legend('Location','northwest','FontSize',24,'FontWeight','bold','EdgeColor','None')
    box off
    xlabel('sine')
    ylabel('SNR / dB-Hz')
    set(gca, 'FontSize', 24, 'FontWeight','bold', 'LineWidth', 2)
    hold off

    figure
    tiledlayout(1,2,"TileSpacing","loose")
    nexttile
    plot(sinelv, dsnr, 'LineWidth', 2, 'DisplayName','reflected part');
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

    function pd = freq_out(x, ofac, hifac)
        %   x     - sin(elevation angle) / cf
        %   ofac  - oversampling factor
        %   hifac - high frequency factor

        n = length(x);
        xmax = max(x);
        xmin = min(x);
        xdif = xmax - xmin;

        if xdif == 0 || isnan(ofac)
            pd = [];
            return;
        end

        nout = floor(0.5 * ofac * hifac * n);
        if nout == 0
            pd = [];
            return;
        end

        pstart = 1.0 / (xdif * ofac);         % 起始频率 (1/m)
        pstop = hifac * n / (2 * xdif);       % 终止频率 (1/m)

        pd = linspace(pstart, pstop, nout);   % 频率数组
    end

    function [ofac, hifac] = get_ofac_hifac(elevAngles, cf, maxH, desiredPrec)
        %GET_OFAC_HIFAC Computes ofac and hifac for Lomb-Scargle Periodogram
        %
        % Parameters
        % ----------
        % elevAngles : array
        %     Elevation angles in degrees
        % cf : float
        %     Scale factor (typically L-band wavelength / 2) in meters
        % maxH : float
        %     Maximum reflector height in meters
        % desiredPrec : float
        %     Desired precision in reflector height (meters)
        %
        % Returns
        % -------
        % ofac : float
        %     Oversampling factor
        % hifac : float
        %     High frequency factor

        % Convert elevation to sin(elevation)/cf (units: 1/m)
        X = sind(elevAngles) ./ cf;

        N = length(X);           % Number of observations
        W = max(X) - min(X);     % Window length (span) in 1/m

        if W == 0
            warning('Bad window length - which will lead to illegal ofac/hifac calc');
            ofac = 0; hifac = 0;
            return;
        end

        % Characteristic peak width (in meters)
        cpw = 1 / W;

        % Oversampling factor
        ofac = cpw / desiredPrec;

        % Nyquist frequency (based on evenly spaced observations)
        fc = N / (2 * W);

        % High frequency factor
        hifac = maxH / fc;
    end

end