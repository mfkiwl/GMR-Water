function varargout = main_batch(settings)

%% Settings
start_time   = settings.Time(1);
end_time     = settings.Time(2);
start_date   = datenum(start_time);
end_date     = datenum(end_time);

%% file preparation
load(settings.Station_info_file)

% extract SNR & carrier pseudorange from rinex
if settings.flow(1)
    tic
    disp('-----------------------------STAR RINEX INFO EXTRCATION-----------------------------')
    RINEX_info_EXTRCATION
    disp('---------------------------RINEX INFO EXTRCATION COMPLETED--------------------------')
    toc
end

% Inverse
if settings.flow(2)
    tic
    disp('------------------------------------STAR INVERSE------------------------------------')
    genMethodsSettings(string(settings.station_name))
    Inverse_RH
    delete('MethodsSettings.mat')
    disp('----------------------------------INVERSE COMPLETED---------------------------------')
    toc
end

% Tidal correction & save
if settings.flow(3)
    if settings.methods(2) && sum(settings.methods)==1
        if nargout > 0
            settings.Final_path = [settings.Out_path,'/Final_file'];
            settings.filenumber = 1;
            settings.station_name = station_name;
            settings.antenna_height = sta_asl;

            varargout = {settings};
        end
        return
    end
    tic
    disp('------------------------------TIDAL CORRECTION & SAVE-------------------------------')
    clear RH_info
    RH_path = [settings.Out_path, '/RH_file/'];
    RH_info_all = cell(1, end_date+1-start_date);
    i = 0;
    for tdatenum = start_date:end_date
        RH_file_name = [RH_path,settings.station_name,num2str(tdatenum),'RH_info.mat'];
        RH_file = load(RH_file_name);   RH_info = RH_file.RH_info;
        i = i+1;
        RH_info_all{i} = RH_info;
    end
    RH_info_all = vertcat(RH_info_all{:});
    RH_info_all = sortrows(RH_info_all,"Time");
    RH_info_all(isnan(RH_info_all.RH),:) = [];


    % RH_qc = qc_moving_avg_RH(RH_info_all.Time, RH_info_all.RH, 60);
    % RH_info_all.Time = RH_qc.time;
    % RH_info_all.RH = RH_qc.RH_QC;
    % RH_info_all(isnan(RH_info_all.RH),:) = [];
    % o = RH_info_all.RH>8.3 | RH_info_all.RH<3.8;
    % RH_info_all(o, :) = [];
    [~, RH_info_all, ~,tide_fit] = Tidal_correction(RH_info_all, sta_lat, sta_asl, tide_range);
    while 1
        [~, RH_info_all, ~,tide_fit] = Tidal_correction(RH_info_all, sta_lat, sta_asl, tide_range);
        RH_info_all.ROC = -RH_info_all.ROC;
        v = abs(RH_info_all.RH-tide_fit);
        m = sqrt((v' * v)/(numel(v)-9));
        out = v>6*m | v>1;
        RH_info_all(out, :) = [];

        if sum(out) == 0
            break
        end
    end
    % RH_info_all.tidal_cor = ones(numel(RH_info_all.Time),1);
    
    band = RH_info_all.BAND;
    fp_all = unique(RH_info_all.System+band);
    for fp = 1:numel(fp_all)
        cur_sysband = fp_all(fp);
        RH_fp = RH_info_all(RH_info_all.System+band == cur_sysband,:);

        Final_info.(cur_sysband) = RH_fp;
    end


    carrierStruct = struct();
    pseudorangeStruct = struct();
    cpStruct = struct();
    snrStruct = struct();
    fields = fieldnames(Final_info);
    for i = 1:length(fields)
        field = fields{i};
        if endsWith(field, 'Carrier')
            carrierStruct.(field) = Final_info.(field);
        elseif endsWith(field, 'Pseudorange')
            pseudorangeStruct.(field) = Final_info.(field);
        elseif contains(field, 'CP')
            cpStruct.(field) = Final_info.(field);
        else
            snrStruct.(field) = Final_info.(field);
        end
    end

    %% Save the final file
    settings.filenumber = 0;
    settings.Final_files = {};
    for m = 1:5
        if settings.methods(m)
            if m < 3
                Base = 'SNR';
            else
                Base = 'OBS';
            end
            if m == 1
                meth = 'Spectral';
                data = snrStruct;
            elseif m == 3
                meth = 'Carrier';
                data = carrierStruct;
            elseif m == 4
                meth = 'Pseudorange';
                data = pseudorangeStruct;
            elseif m == 5
                meth = 'CP';
                data = cpStruct;
            end

            final_file_name = [settings.Out_path,'/Final_file/',settings.station_name,'_',...
                char(start_time),'_',char(end_time),'_',Base,'-',meth,'.mat'];
            if ~exist([settings.Out_path,'/Final_file'],"dir")
                mkdir([settings.Out_path,'/Final_file'])
            end
            parsave(final_file_name, data,"Final_info")

            if nargout > 0
                settings.filenumber = settings.filenumber + 1;
                settings.Final_files{settings.filenumber} = [settings.station_name,'_',...
                char(start_time),'_',char(end_time),'_',Base,'-',meth,'.mat'];
            end
        end
    end
    if nargout > 0
        settings.Final_path = [settings.Out_path,'/Final_file'];
        settings.station_name = station_name;
        settings.antenna_height = sta_asl;

        varargout = {settings};
    end
end
disp('---------------------------------------SAVED!!!-------------------------------------')
toc
end


function RH_qc_ts = qc_moving_avg_RH(time, RH, window_minutes)
    
    if isrow(time)
        time = time';
    end
    if isrow(RH)
        RH = RH';
    end

    n = length(RH);
    RH_qc = RH;

    half_window = minutes(window_minutes / 2); 

    for i = 1:n
        t_center = time(i);
        idx_in_window = (time >= (t_center - half_window)) & (time <= (t_center + half_window));
        window_data = RH(idx_in_window);
        window_data = window_data(~isnan(window_data));  
        window_data(window_data==RH(i)) = [];

        if length(window_data) >= 3
            mu = mean(window_data);
            sigma = std(window_data);
            lower = mu - 1.96 * sigma;
            upper = mu + 1.96 * sigma;

            if RH(i) < lower || RH(i) > upper
                RH_qc(i) = NaN;
            end
        end
    end

    RH_qc_ts = timetable(time, RH_qc, 'VariableNames', {'RH_QC'});

    if 0
        figure;
        plot(time, RH, '.-b', 'DisplayName', 'RH'); hold on;
        plot(time, RH_qc, '.-g', 'LineWidth', 1.5, 'DisplayName', 'QC RH');
        outlier_idx = isnan(RH_qc);
        if any(outlier_idx)
            plot(time(outlier_idx), RH(outlier_idx), 'ro', 'MarkerSize', 6, 'DisplayName', '异常值');
        end
        legend;
        grid on;
    end
end
