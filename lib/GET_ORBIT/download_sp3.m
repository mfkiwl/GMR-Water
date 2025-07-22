function download_sp3(gpsweek,sow,dow,sp3_option,save_path,d,day_num,numday)
jd = gps2jd(gpsweek,sow,0);
time_gps = gpsweek*10 + dow;
gpsweek = num2str(gpsweek);
curdt=datetime(jd,'convertfrom','juliandate');
strday=char(datetime(curdt,'format','DDD'));
stryrl=char(datetime(curdt,'format','yyyy'));

t = 1;
while 1
    try
        ftpobj = ftp('igs.ign.fr');
        cd(ftpobj,strcat('pub/igs/products/mgex/',gpsweek));
        break
    catch
        t = t+1;
    end
    if t == 4
        return
    end
end
ftp_server = 'igs.ign.fr';

if sp3_option == 'CODE'

    filename = strcat('COD0MGXFIN_',stryrl,strday,'0000_01D_05M_ORB.SP3.gz');
    % mget(ftpobj,filename,save_path);
    % gunzip(strcat(save_path,'\',filename),strcat(save_path));
    % delete(strcat(save_path,'\',filename))

    remote_file = ['ftp://', ftp_server, '/',strcat('pub/igs/products/mgex/',gpsweek),'/' filename];
    local_gz = fullfile(save_path, filename);
    curl_cmd = ['curl -o "', local_gz, '" "', remote_file, '"'];

    t = 1;
    while 1
        [status] = system(curl_cmd);
        if ~status
            break
        end
        t = t+1;
        if t == 4
            return
        end
    end

    gunzip(local_gz, save_path);
    delete(local_gz);


    % progress bar
    d.Value = day_num / numday;
    progress = strcat('(',num2str(day_num),'/',num2str(numday),')'); % update progress
    d.Title = strcat('Download progress ',progress);
    d.Message = strcat('File：','COD0MGXFIN_',stryrl,strday,'0000_01D_05M_ORB.SP3',' Saved to: ',save_path,'\',sp3_option);

elseif sp3_option == 'GFZ'

    filename = strcat('GFZ0MGXRAP_',stryrl,strday,'0000_01D_05M_ORB.SP3.gz');
    mget(ftpobj, filename, save_path);
    gunzip(strcat(save_path,'\',filename),strcat(save_path));
    delete(strcat(save_path,'\',filename))

    % progress bar
    d.Value = day_num / numday;
    progress = strcat('(',num2str(day_num),'/',num2str(numday),')');
    d.Title = strcat('Download progress ',progress);
    d.Message = strcat('File：','GFZ0MGXRAP_',stryrl,strday,'0000_01D_05M_ORB.SP3',' Saved to: ',save_path,'\',sp3_option);

elseif sp3_option == 'com'
    
    filename = strcat('com',num2str(time_gps),'.sp3.Z');
    mget(ftpobj,filename,save_path);
    
    % progress bar
    d.Value = day_num / numday;
    progress = strcat('(',num2str(day_num),'/',num2str(numday),')');
    d.Title = strcat('Download progress ',progress);
    d.Message = strcat('file ：','com',num2str(time_gps),'.sp3','Saved to：',save_path,'\',sp3_option);
elseif sp3_option == 'WUM'
   
    filename = strcat('WUM0MGXFIN_',stryrl,strday,'0000_01D_05M_ORB.SP3.gz');
    mget(ftpobj, filename, save_path);
    gunzip(strcat(save_path,'\',filename),strcat(save_path));
    delete(strcat(save_path,'\',filename))

    % progress bar
    d.Value = day_num / numday;
    progress = strcat('(',num2str(day_num),'/',num2str(numday),')');
    d.Title = strcat('Download progress ',progress);
    d.Message = strcat('File：','WUM0MGXFIN_',stryrl,strday,'0000_01D_05M_ORB.SP3',' Saved to: ',save_path,'\',sp3_option);
end
end