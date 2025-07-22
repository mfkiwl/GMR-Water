function [a, b] = genCoefficients(ant_model, radome_mod, gnss_name, freq_name)
init
sett = snr_settings();

sett.opt.gnss_name = gnss_name;
sett.opt.freq_name = freq_name;
sett.sfc.bottom_material = 'seawater';
sett.sat.num_obs = 200;
seasfc_rough = 0.001;
sett.sfc.height_std = seasfc_rough;

sett.sat.elev_lim = [5, 15];
sett.ant.model = ant_model;
sett.ant.radome = radome_mod;
sett.ref.ignore_vec_apc_arp = true;
sett.bias.phase_interf = 180;

num = 0;
for a_h = 10:0.2:20
    num = num +1;
    sett.ref.height_ant = a_h;
    sett.opt.freq_name = 'L1';
    setup = snr_setup (sett);
    result1 = snr_fwd (setup);
    carrier_multipath1 = result1.carrier_error;
    sett.opt.freq_name = 'L2';
    setup = snr_setup (sett);
    result2 = snr_fwd (setup);
    carrier_multipath2 = result2.carrier_error;
    sett.opt.freq_name = 'L5';
    setup = snr_setup (sett);
    result5 = snr_fwd (setup);
    carrier_multipath5 = result5.carrier_error;

    carrier_multipath = result.carrier_error;
    code_multipath = result.code_error;
    snr = result.snr_db;
    p = polyfit(1:numel(snr) ,snr, 2);
    dsnr = snr - polyval(p, 1:numel(snr))';
    CMC = carrier_multipath-code_multipath;

    elv = linspace(sett.sat.elev_lim(1),sett.sat.elev_lim(2) , sett.sat.num_obs);
    sinelv = sind(elv);
    maxf1 = numel(sinelv) / (2*(max(sinelv)-min(sinelv)));
    [psd1,f1] = plomb(CMC,sinelv,maxf1,20);
    [psd2,f2] = plomb(dsnr,sinelv,maxf1,20);
    [psd3,f3] = plomb(carrier_multipath,sinelv,maxf1,20);
    [psd4,f4] = plomb(code_multipath,sinelv,maxf1,20);
    % [~,id] = max(psd(:));
    % maxf(num) = f(id);
end

h = 10:0.2:20;
p = polyfit(maxf, h, 1);
a = p(1);
b = p(2);
end