clc
clear

init
sett = snr_settings();

sett.opt.gnss_name = 'gps';
sett.opt.freq_name = 'L1';
sett.sfc.bottom_material = 'seawater';
sett.sat.num_obs = 200;
seasfc_rough = 0.001;
sett.sfc.height_std = seasfc_rough;

sett.sat.elev_lim = [5, 25];
sett.ant.model = 'TRM55971.00';
sett.ant.radome = 'NONE';
sett.ref.ignore_vec_apc_arp = true;
sett.bias.phase_interf = 180;

sett.ref.height_ant = 10;
setup = snr_setup (sett);
result = snr_fwd (setup);

[a, b] = genCoefficients(ant_model, radome_mod, gnss_name, freq_name);