function genMethodsSettings(station_name)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%  for SCOA  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if station_name == "SCOA"

    WinLSP.Enable = 0;
    if WinLSP.Enable
        WinLSP.length = 5;
        WinLSP.gap = 1.5;
        PNR = 2.5;
    else
        PNR = 3.5;
    end
    %% For Carrier phase/pseudo range multi-frequence combination
    MFC.type = "triple"; % triple or dual
    MFC.gps_ComBand = {'L1C', 'L2W', 'L5Q'};
    MFC.gps_parameter = [0.1248 -0.024];

    % MFC.glo_ComBand = ['L1C', 'L2C', ];
    % MFC.glo_parameter = [0.1248 -0.024];

    MFC.gal_ComBand = {'L1C', 'L8Q', 'L7Q'};
    MFC.gal_parameter = [0.1257, -0.0548];

    MFC.bds_ComBand = {'L1P', 'L6I', 'L5P'};
    MFC.bds_parameter = [0.1207, -0.65];

    %% For Carrier phase & pseudo range single frequence combination
    SFC.gps_parameter = [0.0951 -0.0452; % L1
        0.1221 -0.0672; % L2
        0.1277 -0.0582]; % L5

    SFC.glo_parameter = [0.0934 -0.0321; % G1
        0.12 -0.0263; % G2
        0.1242 -0.0646]; % G3

    SFC.gal_parameter = [0.0951 -0.0452; % E1
        0.1277 -0.0582; % E5a
        0.1242 -0.0646; % E5b
        0.1261 -0.1038; % E5
        0.1172 -0.0617]; % E6

    SFC.bds_parameter = [0.0962 -0.0833; % B1-2
        0.0951 -0.0452 %B1
        0.1277 -0.0582; % B2a
        0.1242 -0.0646; % E5b
        0.1261 -0.1038; % B2
        0.1182 -0.0753]; % B3

    save('MethodsSettings.mat',"WinLSP", "PNR", "MFC", "SFC")
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%  for BRST  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if station_name =="BRST"
    WinLSP.Enable = 0;
    if WinLSP.Enable
        WinLSP.length = 8;
        WinLSP.gap = 1;
        PNR = 7;
    else
        PNR = 5;
    end

    %% For Carrier phase/pseudo range multi-frequence combination
    MFC.type = "triple"; % triple or dual
    MFC.gps_ComBand = {'L1C', 'L2W', 'L5X'};
    MFC.gps_parameter = [0.1248 -0.024];

    % MFC.glo_ComBand = ['L1C', 'L2C', ];
    % MFC.glo_parameter = [0.1248 -0.024];

    MFC.gal_ComBand = {'L1X', 'L8I', 'L7X'};
    MFC.gal_parameter = [0.1257, -0.0548];

    MFC.bds_ComBand = {'L1X', 'L6I', 'L5X'};
    MFC.bds_parameter = [0.1207, -0.25];

    %% For Carrier phase & pseudo range single frequence combination
    SFC.gps_parameter = [0.0951 -0.0452; % L1
        0.1221 -0.0672; % L2
        0.1277 -0.0582]; % L5

    SFC.glo_parameter = [0.0934 -0.0321; % G1
        0.12 -0.0263; % G2
        0.1242 -0.0646]; % G3

    SFC.gal_parameter = [0.0951 -0.0452; % E1
        0.1277 -0.0582; % E5a
        0.1242 -0.0646; % E5b
        0.1261 -0.1038; % E5
        0.1172 -0.0617]; % E6

    SFC.bds_parameter = [0.0962 -0.0833; % B1-2
        0.0951 -0.0452 %B1
        0.1277 -0.0582; % B2a
        0.1242 -0.0646; % B2b
        0.1261 -0.1038; % B2
        0.1182 -0.0753]; % B3

    save('MethodsSettings.mat',"WinLSP", "PNR", "MFC", "SFC")
end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%  for AT01  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if station_name =="AT01"
    WinLSP.Enable = 0;
    if WinLSP.Enable
        WinLSP.length = 5;
        WinLSP.gap = 2.5;
    end

    PNR = 4;

    %% For Carrier phase/pseudo range multi-frequence combination
    MFC.type = "dual"; % triple or dual
    % MFC.gps_ComBand = {'L1C', 'L2W', 'L5Q'};
    % MFC.gps_parameter = [0.1248 -0.024];
    MFC.gps_ComBand = {'L1C', 'L2W'};
    MFC.gps_parameter = [0.1248 -0.524];

    MFC.glo_ComBand = {'L1C', 'L2C'};
    MFC.glo_parameter = [0.1248 -0.524];

    % MFC.gal_ComBand = {'L1C', 'L8Q', 'L7Q'};
    % MFC.gal_parameter = [0.1257, -0.0548];
    MFC.gal_ComBand = {'L1C', 'L7Q'};
    MFC.gal_parameter = [0.1257, -0.5548];

    % MFC.bds_ComBand = {'L1P', 'L6I', 'L5P'};
    % MFC.bds_parameter = [0.1207, -0.25];
    MFC.bds_ComBand = {'L1P', 'L6I'};
    MFC.bds_parameter = [0.1207, -0.525];

    %% For Carrier phase & pseudo range single frequence combination
    SFC.gps_parameter = [get_wave_length("GPS", 'L1')/2 0; % L1
        get_wave_length("GPS", 'L2')/2 0; % L2
        get_wave_length("GPS", 'L5')/2 0]; % L5

    SFC.glo_parameter = [0.0934 -0.0321; % G1
        0.12 -0.0263; % G2
        0.1242 -0.0646]; % G3

    SFC.gal_parameter = [get_wave_length("GALILEO", 'L1')/2 0; % E1
        get_wave_length("GALILEO", 'L5')/2 0; % E5a
        get_wave_length("GALILEO", 'L7')/2 0; % E5b
        get_wave_length("GALILEO", 'L8')/2 0; % E5
        get_wave_length("GALILEO", 'L6')/2 0]; % E6

    SFC.bds_parameter = [get_wave_length("BDS", 'L2')/2 0; % B1-2
        get_wave_length("BDS", 'L1')/2 0; %B1
        get_wave_length("BDS", 'L5')/2 0; % B2a
        get_wave_length("BDS", 'L7')/2 0; % B2b
        get_wave_length("BDS", 'L8')/2 0; % B2
        get_wave_length("BDS", 'L6')/2 0]; % B3

    save('MethodsSettings.mat',"WinLSP", "PNR", "MFC", "SFC")
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%  for BUR2  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if station_name =="BUR2"
    WinLSP.Enable = 0;
    if WinLSP.Enable
        WinLSP.length = 5;
        WinLSP.gap = 2.5;
    end

    PNR = 3.5;

    %% For Carrier phase/pseudo range multi-frequence combination
    MFC.type = "triple"; % triple or dual
    MFC.gps_ComBand = {'L1C', 'L2W', 'L5Q'};
    MFC.gps_parameter = [0.1248 -0.024];

    % MFC.glo_ComBand = ['L1C', 'L2C', ];
    % MFC.glo_parameter = [0.1248 -0.024];

    MFC.gal_ComBand = {'L1C', 'L8Q', 'L7Q'};
    MFC.gal_parameter = [0.1257, -0.0548];

    MFC.bds_ComBand = {'L1P', 'L6I', 'L5P'};
    MFC.bds_parameter = [0.1207, -0.25];

    %% For Carrier phase & pseudo range single frequence combination
    SFC.gps_parameter = [get_wave_length("GPS", 'L1')/2 0; % L1
        get_wave_length("GPS", 'L2')/2 0; % L2
        get_wave_length("GPS", 'L5')/2 0]; % L5

    SFC.glo_parameter = [0.0934 -0.0321; % G1
        0.12 -0.0263; % G2
        0.1242 -0.0646]; % G3

    SFC.gal_parameter = [get_wave_length("GALILEO", 'L1')/2 0; % E1
        get_wave_length("GALILEO", 'L5')/2 0; % E5a
        get_wave_length("GALILEO", 'L7')/2 0; % E5b
        get_wave_length("GALILEO", 'L8')/2 0; % E5
        get_wave_length("GALILEO", 'L6')/2 0]; % E6

    SFC.bds_parameter = [get_wave_length("BDS", 'L2')/2 0; % B1-2
        get_wave_length("BDS", 'L1')/2 0; %B1
        get_wave_length("BDS", 'L5')/2 0; % B2a
        get_wave_length("BDS", 'L7')/2 0; % B2b
        get_wave_length("BDS", 'L8')/2 0; % B2
        get_wave_length("BDS", 'L6')/2 0]; % B3

    save('MethodsSettings.mat',"WinLSP", "PNR", "MFC", "SFC")
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%  for SC02  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if station_name == "SC02"

    WinLSP.Enable = 0;
    if WinLSP.Enable
        WinLSP.length = 5;
        WinLSP.gap = 2.5;
        PNR = 2.5;
    else
        PNR = 5;
    end
    %% For Carrier phase/pseudo range multi-frequence combination
    % Triple Carrier1
    % MFC.type = "triple"; % triple or dual
    % MFC.gps_ComBand = {'L1C', 'L2W', 'L5Q'};
    % MFC.gps_parameter = [0.1248 -0.024];
   
    % MFC.gal_ComBand = {'L1C', 'L8Q', 'L7Q'};
    % MFC.gal_parameter = [0.1257, -0.0548];
    % 
    % MFC.bds_ComBand = {'L1P', 'L6I', 'L5P'};
    % MFC.bds_parameter = [0.1207, 0.075];

    % Triple Carrier2
    % MFC.type = "triple"; % triple or dual
    % MFC.gps_ComBand = {'L1C', 'L2W', 'L5Q'};
    % MFC.gps_parameter = [0.1248 -0.024];
   
    % MFC.gal_ComBand = {'L1C', 'L8Q', 'L7Q'};
    % MFC.gal_parameter = [0.1257, -0.0548];
    % 
    % MFC.bds_ComBand = {'L1P', 'L6I', 'L5P'};
    % MFC.bds_parameter = [0.1207, 0.075];

    % Dual Carrier
    % MFC.type = "dual"; % triple or dual
    % MFC.gps_ComBand = {'L1C', 'L2W', 'L5Q'};
    % MFC.gps_parameter = [0.1248 -0.124];
    % 
    % MFC.glo_ComBand = {'L1C', 'L2C'};
    % MFC.glo_parameter = [0.1248 -0.124];
    % 
    % MFC.gal_ComBand = {'L1C', 'L8Q', 'L7Q'};
    % MFC.gal_parameter = [0.1257, -0.0548];
    % 
    % MFC.bds_ComBand = {'L1P', 'L6I', 'L5P'};
    % MFC.bds_parameter = [0.1207, -0.25];

    % Triple Paeudorange
    % MFC.type = "triple"; % triple or dual
    % MFC.gps_ComBand = {'C1C', 'C2W', 'C5Q'};
    % MFC.gps_parameter = [0.1248 -0.024];
    % 
    % MFC.gal_ComBand = {'C1C', 'C8Q', 'C7Q'};
    % MFC.gal_parameter = [0.1257, -0.0548];
    % 
    % MFC.bds_ComBand = {'C1P', 'C6I', 'C5P'};
    % MFC.bds_parameter = [0.1207, 0.075];

    % Dual Paeudorange
    MFC.type = "dual"; % triple or dual
    MFC.gps_ComBand = {'C1C', 'C2W'};
    MFC.gps_parameter = [0.1248 -0.024];

    MFC.glo_ComBand = {'C1C', 'C2C'};
    MFC.glo_parameter = [0.1248 -0.124];

    MFC.gal_ComBand = {'C1C', 'C8Q'};
    MFC.gal_parameter = [0.1257, -0.0548];

    MFC.bds_ComBand = {'C1P', 'C6I'};
    MFC.bds_parameter = [0.1207, 0.075];

    %% For Carrier phase & pseudo range single frequence combination
    SFC.gps_parameter = [get_wave_length("GPS", 'L1')/2 0; % L1
        get_wave_length("GPS", 'L2')/2 0; % L2
        get_wave_length("GPS", 'L5')/2 0]; % L5

    % SFC.glo_parameter = [0.0934 -0.0321; % G1
    %     0.12 -0.0263; % G2
    %     0.1242 -0.0646]; % G3

    SFC.gal_parameter = [get_wave_length("GALILEO", 'L1')/2 0; % E1
        get_wave_length("GALILEO", 'L5')/2 0; % E5a
        get_wave_length("GALILEO", 'L7')/2 0; % E5b
        get_wave_length("GALILEO", 'L8')/2 0; % E5
        get_wave_length("GALILEO", 'L6')/2 0]; % E6

    SFC.bds_parameter = [get_wave_length("BDS", 'L2')/2 0; % B1-2
        get_wave_length("BDS", 'L1')/2 0; %B1
        get_wave_length("BDS", 'L5')/2 0; % B2a
        get_wave_length("BDS", 'L7')/2 0; % B2b
        get_wave_length("BDS", 'L8')/2 0; % B2
        get_wave_length("BDS", 'L6')/2 0]; % B3

    save('MethodsSettings.mat',"WinLSP", "PNR", "MFC", "SFC")
end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%  for MAYG  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if station_name == "MAYG"

    WinLSP.Enable = 0;
    if WinLSP.Enable
        WinLSP.length = 7;
        WinLSP.gap = 1;
        PNR = 2.5;
    else
        PNR = 3;
    end
    %% For Carrier phase/pseudo range multi-frequence combination
    MFC.type = "triple"; % triple or dual
    MFC.gps_ComBand = {'L1C', 'L2W', 'L5Q'};
    MFC.gps_parameter = [0.1248 -0.024];

    % MFC.glo_ComBand = ['L1C', 'L2C', ];
    % MFC.glo_parameter = [0.1248 -0.024];

    MFC.gal_ComBand = {'L1C', 'L8Q', 'L7Q'};
    MFC.gal_parameter = [0.1257, -0.0548];

    MFC.bds_ComBand = {'L1P', 'L6I', 'L5P'};
    MFC.bds_parameter = [0.1207, -0.25];

    %% For Carrier phase & pseudo range single frequence combination
    SFC.gps_parameter = [get_wave_length("GPS", 'L1')/2 0; % L1
        get_wave_length("GPS", 'L2')/2 0; % L2
        get_wave_length("GPS", 'L5')/2 0]; % L5

    % SFC.glo_parameter = [0.0934 -0.0321; % G1
    %     0.12 -0.0263; % G2
    %     0.1242 -0.0646]; % G3

    SFC.gal_parameter = [get_wave_length("GALILEO", 'L1')/2 0; % E1
        get_wave_length("GALILEO", 'L5')/2 0; % E5a
        get_wave_length("GALILEO", 'L7')/2 0; % E5b
        get_wave_length("GALILEO", 'L8')/2 0; % E5
        get_wave_length("GALILEO", 'L6')/2 0]; % E6

    SFC.bds_parameter = [get_wave_length("BDS", 'L2')/2 0; % B1-2
        get_wave_length("BDS", 'L1')/2 0; %B1
        get_wave_length("BDS", 'L5')/2 0; % B2a
        get_wave_length("BDS", 'L7')/2 0; % B2b
        get_wave_length("BDS", 'L8')/2 0; % B2
        get_wave_length("BDS", 'L6')/2 0]; % B3

    save('MethodsSettings.mat',"WinLSP", "PNR", "MFC", "SFC")
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%  for HKQT  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if station_name == "HKQT"

    WinLSP.Enable = 0;
    if WinLSP.Enable
        WinLSP.length = 4;
        WinLSP.gap = 2;
        PNR = 2.5;
    else
        PNR = 3;
    end
    %% For Carrier phase/pseudo range multi-frequence combination
    MFC.type = "triple"; % triple or dual
    MFC.gps_ComBand = {'L1C', 'L2W', 'L5Q'};
    MFC.gps_parameter = [0.1248 -0.024];

    % MFC.glo_ComBand = ['L1C', 'L2C', ];
    % MFC.glo_parameter = [0.1248 -0.024];

    MFC.gal_ComBand = {'L1C', 'L8Q', 'L7Q'};
    MFC.gal_parameter = [0.1257, -0.0548];

    MFC.bds_ComBand = {'L1P', 'L6I', 'L5P'};
    MFC.bds_parameter = [0.1207, -0.25];

    %% For Carrier phase & pseudo range single frequence combination
    SFC.gps_parameter = [get_wave_length("GPS", 'L1')/2 0; % L1
        get_wave_length("GPS", 'L2')/2 0; % L2
        get_wave_length("GPS", 'L5')/2 0]; % L5

    % SFC.glo_parameter = [0.0934 -0.0321; % G1
    %     0.12 -0.0263; % G2
    %     0.1242 -0.0646]; % G3

    SFC.gal_parameter = [get_wave_length("GALILEO", 'L1')/2 0; % E1
        get_wave_length("GALILEO", 'L5')/2 0; % E5a
        get_wave_length("GALILEO", 'L7')/2 0; % E5b
        get_wave_length("GALILEO", 'L8')/2 0; % E5
        get_wave_length("GALILEO", 'L6')/2 0]; % E6

    SFC.bds_parameter = [get_wave_length("BDS", 'L2')/2 0; % B1-2
        get_wave_length("BDS", 'L1')/2 0; %B1
        get_wave_length("BDS", 'L5')/2 0; % B2a
        get_wave_length("BDS", 'L7')/2 0; % B2b
        get_wave_length("BDS", 'L8')/2 0; % B2
        get_wave_length("BDS", 'L6')/2 0]; % B3

    save('MethodsSettings.mat',"WinLSP", "PNR", "MFC", "SFC")
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%  for MNIS  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if station_name == "MNIS"

    WinLSP.Enable = 0;
    if WinLSP.Enable
        WinLSP.length = 4;
        WinLSP.gap = 2;
        PNR = 2.5;
    else
        PNR = 3;
    end
    %% For Carrier phase/pseudo range multi-frequence combination
    MFC.type = "triple"; % triple or dual
    MFC.gps_ComBand = {'L1C', 'L2W', 'L5Q'};
    MFC.gps_parameter = [0.1248 -0.024];

    % MFC.glo_ComBand = ['L1C', 'L2C', ];
    % MFC.glo_parameter = [0.1248 -0.024];

    MFC.gal_ComBand = {'L1C', 'L8Q', 'L7Q'};
    MFC.gal_parameter = [0.1257, -0.0548];

    MFC.bds_ComBand = {'L1P', 'L6I', 'L5P'};
    MFC.bds_parameter = [0.1207, -0.25];

    %% For Carrier phase & pseudo range single frequence combination
    SFC.gps_parameter = [get_wave_length("GPS", 'L1')/2 0; % L1
        get_wave_length("GPS", 'L2')/2 0; % L2
        get_wave_length("GPS", 'L5')/2 0]; % L5

    % SFC.glo_parameter = [0.0934 -0.0321; % G1
    %     0.12 -0.0263; % G2
    %     0.1242 -0.0646]; % G3

    SFC.gal_parameter = [get_wave_length("GALILEO", 'L1')/2 0; % E1
        get_wave_length("GALILEO", 'L5')/2 0; % E5a
        get_wave_length("GALILEO", 'L7')/2 0; % E5b
        get_wave_length("GALILEO", 'L8')/2 0; % E5
        get_wave_length("GALILEO", 'L6')/2 0]; % E6

    SFC.bds_parameter = [get_wave_length("BDS", 'L2')/2 0; % B1-2
        get_wave_length("BDS", 'L1')/2 0; %B1
        get_wave_length("BDS", 'L5')/2 0; % B2a
        get_wave_length("BDS", 'L7')/2 0; % B2b
        get_wave_length("BDS", 'L8')/2 0; % B2
        get_wave_length("BDS", 'L6')/2 0]; % B3

    save('MethodsSettings.mat',"WinLSP", "PNR", "MFC", "SFC")
end
end