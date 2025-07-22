function [valid, RH_info] = snr2RH_info(elv, snr, azi, time, wave_length, tdatenum, ...
    hell, hgtlim, ...
    cur_sys, cur_band, cur_sat, PNR)

varNames = {'Time','System','BAND','PRN','ROC','MIN_elv','MAX_elv','MEAN_AZI','RH','trop_c', 'PNR'};
varTypes = {'datetime','string','string','double','double','double','double','double','double','double', 'double'};
RH_info = table('Size',[0,length(varNames)],'VariableTypes',varTypes,'VariableNames',varNames);

if exist([num2str(tdatenum), 'TropParameters.mat'],"file") % Batch mode
    load([num2str(tdatenum), 'TropParameters.mat'])
    plat = lla(1);
else
    global Operation_settings
    plat = Operation_settings.station_l(2);
    plon = Operation_settings.station_l(1);
    % tropd
    gpt3_grid = gpt3_5_fast_readGrid;
    curdt = datetime(tdatenum,'convertfrom','datenum');
    curyr = datetime(curdt,'format','yyyy');
    curyr = double(int16(convertTo(curyr,'yyyymmdd') / 10000));
    curday = datetime(curdt,'format','DDD');
    curday = day(curday,'dayofyear');
    curjd  = juliandate(curdt);
    curjd2 = doy2jd(curyr, curday)-2400000.5;
    hgtant = hell;
    dlat(1) = plat*pi/180.d0;
    dlon(1) = plon*pi/180.d0;  
    it = 0;     
    [pant,~,~,tmant,eant,ah,aw,lambda,~] = gpt3_5_fast (curjd2, dlat,dlon, hgtant,it, gpt3_grid);
    [plim(1),tlim(1),~,tmlim(1),elim(1),~,~,~,~] = gpt3_5_fast (curjd2, dlat,dlon, hgtlim(1),it, gpt3_grid);
    [plim(2),tlim(2),~,tmlim(2),elim(2),~,~,~,~] = gpt3_5_fast (curjd2, dlat,dlon, hgtlim(2),it, gpt3_grid);
end

sinelv = sind(elv);

valid = 1;
if isempty(elv) | abs(elv(end)-elv(1)) < 5 | numel(elv) < 10
    valid = 0;
    RH_info = [];
    return
end

% snr = 10.^(snr./20);
[refl_h, id, psd, pks] = snr2RH_lsp(sinelv, snr, wave_length, hell, hgtlim);
if isempty(pks)
    valid = 0;
    RH_info = [];
    return
end

% Tropospheric correction
pre_h = refl_h(id);
hsfc = hell - pre_h;
if hsfc > hgtlim(1) && hsfc < hgtlim(2)
    psfc = interp1(hgtlim,plim,hsfc,'linear');
    tsfc = interp1(hgtlim,tlim,hsfc,'linear');
    tmsfc = interp1(hgtlim,tmlim,hsfc,'linear');
    esfc = interp1(hgtlim,elim,hsfc,'linear');

    % refraction
    dele = (1/60) * 510 * psfc / ((9/5*tsfc+492) * 1010.16) .*cotd(elv+7.31./(elv+4.4));
    elv = elv+dele;

    % delay
    theta = elv;
    thetarefr = [];
    for jj = 1:numel(theta)
        tau = trop_delay_tp(curjd,plat,hell,hsfc,theta(jj),pant,tmant,eant,ah,aw,lambda,psfc,tmsfc,esfc);
        thetarefr(jj) =  theta(jj) + asind( 0.5*tau/pre_h );
    end
    sinelv = sind(thetarefr).';

    [refl_h, id, psd, pks] = snr2RH_lsp(sinelv, snr, wave_length, hell, hgtlim);
    if isempty(pks)
        valid = 0;
        RH_info = [];
        return
    end
end
cur_rh = refl_h(id);  % Final rh
trop_c = cur_rh - pre_h; % Tropospheric correction

% QC
if valid
    % if pks(end) < 5
    %     valid = 0;
    % end
    % if numel(pks) > 1
    %     if pks(end)/pks(end-1) < 1.5 ...
    %             % & refl_h(psd==pks(end)) - refl_h(psd==pks(end-1)) > 1
    %         valid = 0;
    %     end
    % end
    if  cur_rh > hell-hgtlim(1) || cur_rh < hell-hgtlim(2) || max(psd)<PNR *mean(psd)
        valid = 0;
    end
end

if valid == 1
    Time = datetime(tdatenum + mean(time)/86400, 'ConvertFrom', 'datenum');       % datenum
    System = string(cur_sys);
    BAND = string(cur_band);
    PRN = cur_sat;                               % Sat prn
    ROC = tand(mean(elv)) / ...
        (( (pi/180) * (elv(end)-elv(1)) ) /(time(end)-time(1)));  % tan(th)/dth/dt :rate of change
    MIN_elv = min(elv);                          % THETA MIN
    MAX_elv = max(elv);                          % THETA MAX
    MEAN_AZI = mean(azi,'omitnan');              % MEAN AZI
    RH = cur_rh;                                 % slvl
    PNR = max(psd) / mean(psd);
    RH_info = table(Time,System,BAND,PRN,ROC,MIN_elv,MAX_elv,MEAN_AZI,RH,trop_c, PNR);
else    

end
end