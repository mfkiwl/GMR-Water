function [M,a,b,cur_band] = Get_combined_observations(Meth_id, cur_sys, inverse_data, indx, cur_sat, varargin)

load('MethodsSettings.mat','MFC','SFC')
%% Triple
if MFC.type == "triple"
    if Meth_id == 3                              % Carrier phase dual/triple frequency combination
        if string(cur_sys) == "GPS"
            L1 = inverse_data{indx, MFC.gps_ComBand(1)};
            L2 = inverse_data{indx, MFC.gps_ComBand(2)};
            L3 = inverse_data{indx, MFC.gps_ComBand(3)};
            lamda1 = get_wave_length(cur_sys, MFC.gps_ComBand{1}, cur_sat);
            lamda2 = get_wave_length(cur_sys, MFC.gps_ComBand{2}, cur_sat);
            lamda3 = get_wave_length(cur_sys, MFC.gps_ComBand{3}, cur_sat);
        elseif string(cur_sys) == "GALILEO"
            L1 = inverse_data{indx, MFC.gal_ComBand(1)};
            L2 = inverse_data{indx, MFC.gal_ComBand(2)};
            L3 = inverse_data{indx, MFC.gal_ComBand(3)};
            lamda1 = get_wave_length(cur_sys, MFC.gal_ComBand{1}, cur_sat);
            lamda2 = get_wave_length(cur_sys, MFC.gal_ComBand{2}, cur_sat);
            lamda3 = get_wave_length(cur_sys, MFC.gal_ComBand{3}, cur_sat);
        elseif string(cur_sys) == "BDS"
            L1 = inverse_data{indx, MFC.bds_ComBand(1)};
            L2 = inverse_data{indx, MFC.bds_ComBand(2)};
            L3 = inverse_data{indx, MFC.bds_ComBand(3)};
            lamda1 = get_wave_length(cur_sys, MFC.bds_ComBand{1}, cur_sat);
            lamda2 = get_wave_length(cur_sys, MFC.bds_ComBand{2}, cur_sat);
            lamda3 = get_wave_length(cur_sys, MFC.bds_ComBand{3}, cur_sat);
        elseif string(cur_sys) == "GLONASS"
            lamda = get_wave_length(cur_sys,'L7',cur_sat);
        end
        yita1 = lamda3^2 - lamda2^2;
        yita2 = lamda1^2 - lamda3^2;
        yita3 = lamda2^2 - lamda1^2;

        kama1 = yita1 * lamda1;
        kama2 = yita2 * lamda2;
        kama3 = yita3 * lamda3;

        M = kama1*L1 + kama2*L2 + kama3*L3;
        cur_band = 'Carrier';
        if string(cur_sys)     == "GPS"
            a = MFC.gps_parameter(1);
            b = MFC.gps_parameter(2);
        elseif string(cur_sys) == "GALILEO"
            a = MFC.gal_parameter(1);
            b = MFC.gal_parameter(2);
        elseif string(cur_sys) == "BDS"
            a = MFC.bds_parameter(1);
            b = MFC.bds_parameter(2);
        end
        return

    elseif Meth_id == 4                         % pseudorange dual/triple frequency combination
        MFC.gps_ComBand = regexprep(MFC.gps_ComBand, '^L', 'C');
        MFC.gal_ComBand = regexprep(MFC.gal_ComBand, '^L', 'C');
        MFC.bds_ComBand = regexprep(MFC.bds_ComBand, '^L', 'C');
        if string(cur_sys) == "GPS"
            C1 = inverse_data{indx, MFC.gps_ComBand(1)};
            C2 = inverse_data{indx, MFC.gps_ComBand(2)};
            C3 = inverse_data{indx, MFC.gps_ComBand(3)};
            lamda1 = get_wave_length(cur_sys, MFC.gps_ComBand{1}, cur_sat);
            lamda2 = get_wave_length(cur_sys, MFC.gps_ComBand{2}, cur_sat);
            lamda3 = get_wave_length(cur_sys, MFC.gps_ComBand{3}, cur_sat);
        elseif string(cur_sys) == "GALILEO"
            C1 = inverse_data{indx, MFC.gal_ComBand(1)};
            C2 = inverse_data{indx, MFC.gal_ComBand(2)};
            C3 = inverse_data{indx, MFC.gal_ComBand(3)};
            lamda1 = get_wave_length(cur_sys, MFC.gal_ComBand{1}, cur_sat);
            lamda2 = get_wave_length(cur_sys, MFC.gal_ComBand{2}, cur_sat);
            lamda3 = get_wave_length(cur_sys, MFC.gal_ComBand{3}, cur_sat);
        elseif string(cur_sys) == "BDS"
            C1 = inverse_data{indx, MFC.bds_ComBand(1)};
            C2 = inverse_data{indx, MFC.bds_ComBand(2)};
            C3 = inverse_data{indx, MFC.bds_ComBand(3)};
            lamda1 = get_wave_length(cur_sys, MFC.bds_ComBand{1}, cur_sat);
            lamda2 = get_wave_length(cur_sys, MFC.bds_ComBand{2}, cur_sat);
            lamda3 = get_wave_length(cur_sys, MFC.bds_ComBand{3}, cur_sat);
        end
        yita1 = lamda3^2 - lamda2^2;
        yita2 = lamda1^2 - lamda3^2;
        yita3 = lamda2^2 - lamda1^2;

        M = yita1*C1 + yita2*C2 + yita3*C3;
        cur_band = 'Pseudorange';
        if string(cur_sys)     == "GPS"
            a = MFC.gps_parameter(1);
            b = MFC.gps_parameter(2);
        elseif string(cur_sys) == "GALILEO"
            a = MFC.gal_parameter(1);
            b = MFC.gal_parameter(2);
        elseif string(cur_sys) == "BDS"
            a = MFC.bds_parameter(1);
            b = MFC.bds_parameter(2);
        end
        return
    end

    %% Dual
elseif MFC.type == "dual"
    if Meth_id == 3                              % Carrier phase dual/triple frequency combination
        if string(cur_sys) == "GPS"
            L1 = inverse_data{indx, MFC.gps_ComBand(1)};
            L2 = inverse_data{indx, MFC.gps_ComBand(2)};
            lamda1 = get_wave_length(cur_sys, MFC.gps_ComBand{1}, cur_sat);
            lamda2 = get_wave_length(cur_sys, MFC.gps_ComBand{2}, cur_sat);
        elseif string(cur_sys) == "GALILEO"
            L1 = inverse_data{indx, MFC.gal_ComBand(1)};
            L2 = inverse_data{indx, MFC.gal_ComBand(2)};
            lamda1 = get_wave_length(cur_sys, MFC.gal_ComBand{1}, cur_sat);
            lamda2 = get_wave_length(cur_sys, MFC.gal_ComBand{2}, cur_sat);
        elseif string(cur_sys) == "BDS"
            L1 = inverse_data{indx, MFC.bds_ComBand(1)};
            L2 = inverse_data{indx, MFC.bds_ComBand(2)};
            lamda1 = get_wave_length(cur_sys, MFC.bds_ComBand{1}, cur_sat);
            lamda2 = get_wave_length(cur_sys, MFC.bds_ComBand{2}, cur_sat);
        elseif string(cur_sys) == "GLONASS"
            L1 = inverse_data{indx, MFC.glo_ComBand(1)};
            L2 = inverse_data{indx, MFC.glo_ComBand(2)};
            lamda1 = get_wave_length(cur_sys,MFC.glo_ComBand{1},cur_sat);
            lamda2 = get_wave_length(cur_sys,MFC.glo_ComBand{2},cur_sat);
        end

        M = lamda1*L1 - lamda2*L2;
        cur_band = 'Carrier';
        if string(cur_sys)     == "GPS"
            a = MFC.gps_parameter(1);
            b = MFC.gps_parameter(2);
        elseif string(cur_sys) == "GALILEO"
            a = MFC.gal_parameter(1);
            b = MFC.gal_parameter(2);
        elseif string(cur_sys) == "BDS"
            a = MFC.bds_parameter(1);
            b = MFC.bds_parameter(2);
        elseif string(cur_sys) == "GLONASS"
            a = MFC.glo_parameter(1);
            b = MFC.glo_parameter(2);
        end
        return

    elseif Meth_id == 4                         % pseudorange dual/triple frequency combination
        MFC.gps_ComBand = regexprep(MFC.gps_ComBand, '^L', 'C');
        MFC.gal_ComBand = regexprep(MFC.gal_ComBand, '^L', 'C');
        MFC.bds_ComBand = regexprep(MFC.bds_ComBand, '^L', 'C');
        if string(cur_sys) == "GPS"
            C1 = inverse_data{indx, MFC.gps_ComBand(1)};
            C2 = inverse_data{indx, MFC.gps_ComBand(2)};
            lamda1 = get_wave_length(cur_sys, MFC.gps_ComBand{1}, cur_sat);
            lamda2 = get_wave_length(cur_sys, MFC.gps_ComBand{2}, cur_sat);
        elseif string(cur_sys) == "GALILEO"
            C1 = inverse_data{indx, MFC.gal_ComBand(1)};
            C2 = inverse_data{indx, MFC.gal_ComBand(2)};
            lamda1 = get_wave_length(cur_sys, MFC.gal_ComBand{1}, cur_sat);
            lamda2 = get_wave_length(cur_sys, MFC.gal_ComBand{2}, cur_sat);
        elseif string(cur_sys) == "BDS"
            C1 = inverse_data{indx, MFC.bds_ComBand(1)};
            C2 = inverse_data{indx, MFC.bds_ComBand(2)};
            lamda1 = get_wave_length(cur_sys, MFC.bds_ComBand{1}, cur_sat);
            lamda2 = get_wave_length(cur_sys, MFC.bds_ComBand{2}, cur_sat);
        elseif string(cur_sys) == "GLONASS"
            C1 = inverse_data{indx, MFC.glo_ComBand(1)};
            C2 = inverse_data{indx, MFC.glo_ComBand(2)};
            lamda1 = get_wave_length(cur_sys, MFC.glo_ComBand{1}, cur_sat);
            lamda2 = get_wave_length(cur_sys, MFC.glo_ComBand{2}, cur_sat);
        end
        M = C1 - C2;
        cur_band = 'Pseudorange';
        if string(cur_sys)     == "GPS"
            a = MFC.gps_parameter(1);
            b = MFC.gps_parameter(2);
        elseif string(cur_sys) == "GALILEO"
            a = MFC.gal_parameter(1);
            b = MFC.gal_parameter(2);
        elseif string(cur_sys) == "BDS"
            a = MFC.bds_parameter(1);
            b = MFC.bds_parameter(2);
        elseif string(cur_sys) == "GLONASS"
            a = MFC.glo_parameter(1);
            b = MFC.glo_parameter(2);
        end
        return
    end
end

if Meth_id == 5                         % Single frequency carrier phase pseudo range combination
    group = varargin{1};
    C1 = inverse_data{indx,group{2}};
    L1 = inverse_data{indx,group{1}};
    lamda1 = get_wave_length(cur_sys,group{1},cur_sat);

    M = C1 - L1*lamda1;
    cur_band = ['CP', group{1}(2:end)];
    if string(cur_sys) == "GPS"
        if string(group{1}(2)) == "1"
            a = SFC.gps_parameter(1,1);
            b = SFC.gps_parameter(1,2);
        elseif string(group{1}(2)) == "2"
            a = SFC.gps_parameter(2,1);
            b = SFC.gps_parameter(2,2);
        elseif string(group{1}(2)) == "5"
            a = SFC.gps_parameter(3,1);
            b = SFC.gps_parameter(3,2);
        end
    elseif string(cur_sys) == "GLONASS"
        if string(group{1}(2)) == "1"
            a = get_wave_length(cur_sys,'L1', cur_sat)/2;
            b = 0;
        elseif string(group{1}(2)) == "2"
            a = get_wave_length(cur_sys,'L2', cur_sat)/2;
            b = 0;
        elseif string(group{1}(2)) == "3"
            a = get_wave_length(cur_sys,'L1', cur_sat)/2;
            b = 0;
        else
            a = nan;
            b = nan;
        end
    elseif string(cur_sys) == "GALILEO"
        if string(group{1}(2)) == "1"
            a = SFC.gal_parameter(1,1);
            b = SFC.gal_parameter(1,2);
        elseif string(group{1}(2)) == "5"
            a = SFC.gal_parameter(2,1);
            b = SFC.gal_parameter(2,2);
        elseif string(group{1}(2)) == "7"
            a = SFC.gal_parameter(3,1);
            b = SFC.gal_parameter(3,2);
        elseif string(group{1}(2)) == "8"
            a = SFC.gal_parameter(4,1);
            b = SFC.gal_parameter(4,2);
        elseif string(group{1}(2)) == "6"
            a = SFC.gal_parameter(5,1);
            b = SFC.gal_parameter(5,2);
        end
    elseif string(cur_sys) == "BDS"
        if string(group{1}(2)) == "2"
            a = SFC.bds_parameter(1,1);
            b = SFC.bds_parameter(1,2);
        elseif string(group{1}(2)) == "1"
            a = SFC.bds_parameter(2,1);
            b = SFC.bds_parameter(2,2);
        elseif string(group{1}(2)) == "5"
            a = SFC.bds_parameter(3,1);
            b = SFC.bds_parameter(3,2);
        elseif string(group{1}(2)) == "7"
            a = SFC.bds_parameter(4,1);
            b = SFC.bds_parameter(4,2);
        elseif string(group{1}(2)) == "8"
            a = SFC.bds_parameter(5,1);
            b = SFC.bds_parameter(5,2);
        elseif string(group{1}(2)) == "6"
            a = SFC.bds_parameter(6,1);
            b = SFC.bds_parameter(6,2);
        end
    end
    return

end