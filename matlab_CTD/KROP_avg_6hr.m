function KROP_avg_6hr(info_file)

% Average data every 6 hours (at midnight, 06:00, 12:00 and 18:00)
% ESDU, SAMS, April 19

% Note: currently there are sections of code for each intrument (clearer /
% easier to write it that way), but in future versions this script could be
% improved by merging the individual bits of code and make it applicable to
% all instrument types.


close all
load(info_file)

% Load mooring data
mat_fl = [d_mat '\' mooring_id '_CTD.mat'];
load(mat_fl)

% Setup averaging interval (hours)
interp_int = 6;
% Set first interpolation time at 3 or 9 (am or pm) so that middle of
% interval corresponds to 6 or 12 in all datasets.
% Find closest matching hour AFTER deployment
start_hour = str2double(datestr(start_date,'hh'));
if start_hour<=3
    interp_start_hour = 3;
elseif start_hour<=9
    interp_start_hour = 9;
elseif start_hour<=15
    interp_start_hour = 15;
elseif start_hour<=21
    interp_start_hour = 21;
else
    interp_start_hour = 27;
end
interp_start_time = datenum(datestr(start_date,'dd-mmm-yyyy'))+interp_start_hour/24;
interp_time = [interp_start_time:interp_int/24:end_date];
% Record averaging time as middle of interval
PRO_avg_6hr.interp_time=(interp_time + interp_int/24/2);


%% Average SBE16+
if exist('sbe16p_num','var')
    if sbe16p_num >0
        
        for j = 1:sbe16p_num
            
            % Get variables
            inst = ['SBE16p_' sbe16p_sn{j}];
            eval(['DATA_IN=PRO.' inst ';']);
            
            % First check if data record starts late or ends early, if so
            % adjust averaging start and end date
            if floor(start_date)-floor(DATA_IN.mtime(1))<-1 && end_date-DATA_IN.mtime(end)>1
                interp_time = [floor(DATA_IN.mtime(1)):interp_int/24:floor(DATA_IN.mtime(end))];
            elseif floor(start_date)-floor(DATA_IN.mtime(1))<-1
                interp_time = [floor(DATA_IN.mtime(1)):interp_int/24:floor(end_date)];
            elseif end_date-DATA_IN.mtime(end) >1
                interp_time = [floor(start_date):interp_int/24:floor(DATA_IN.mtime(end))];
            else
                interp_time = [floor(start_date):interp_int/24:end_date];
            end
            
            % Record averaging time as middle of interval
            DATA_OUT.interp_time = (interp_time + interp_int/24/2)';
            
            % Average data
            for ind=1:length(interp_time)
                
                % Get matching data points index
                ind_avg = find(DATA_IN.mtime>=interp_time(ind) & DATA_IN.mtime<(interp_time(ind)+interp_int/24));
                
                % Get list of variables for that instrument (remove despiking params)
                field_list = fieldnames(DATA_IN);
                kk=1;
                for k=1:length(field_list)
                    if regexp(field_list{k},'despiking')
                        kk=kk;
                    else
                        var_list{kk,1} = field_list{k};
                        kk=kk+1;
                    end
                end
                clear field_list k kk
                
                % Average all variables in time index
                for k=1:length(var_list)
                    var_name = var_list {k};
                    eval(['DATA_OUT.' var_name '(ind,1)=nanmean(DATA_IN.' var_name '(ind_avg));']);
                end
                clear var_name
                ind_avg = [];
                
            end
            
            % Save data
            eval(['PRO_avg_6hr.' inst '=DATA_OUT;'])
            clear DATA_IN DATA_OUT inst ind var_list
            
        end
    end
end


%% Average SBE19+
if exist('sbe19p_num','var')
    if sbe19p_num >0
        
        for j = 1:sbe19p_num
            
            % Get variables
            inst = ['SBE19p_' sbe19p_sn{j}];
            eval(['DATA_IN=PRO.' inst ';']);
            
            % First check if data record starts late or ends early, if so
            % adjust averaging start and end date
            if floor(start_date)-floor(DATA_IN.mtime(1))<-1 && end_date-DATA_IN.mtime(end)>1
                interp_time = [floor(DATA_IN.mtime(1)):interp_int/24:floor(DATA_IN.mtime(end))];
            elseif floor(start_date)-floor(DATA_IN.mtime(1))<-1
                interp_time = [floor(DATA_IN.mtime(1)):interp_int/24:floor(end_date)];
            elseif end_date-DATA_IN.mtime(end) >1
                interp_time = [floor(start_date):interp_int/24:floor(DATA_IN.mtime(end))];
            else
                interp_time = [floor(start_date):interp_int/24:end_date];
            end
            
            % Record averaging time as middle of interval
            DATA_OUT.interp_time = (interp_time + interp_int/24/2)';
            
            % Average data
            for ind=1:length(interp_time)
                
                % Get matching data points index
                ind_avg = find(DATA_IN.mtime>=interp_time(ind) & DATA_IN.mtime<(interp_time(ind)+interp_int/24));
                
                % Get list of variables for that instrument (remove despiking params)
                field_list = fieldnames(DATA_IN);
                kk=1;
                for k=1:length(field_list)
                    if regexp(field_list{k},'despiking')
                        kk=kk;
                    else
                        var_list{kk,1} = field_list{k};
                        kk=kk+1;
                    end
                end
                clear field_list k kk
                
                % Average all variables in time index
                for k=1:length(var_list)
                    var_name = var_list {k};
                    eval(['DATA_OUT.' var_name '(ind,1)=nanmean(DATA_IN.' var_name '(ind_avg));']);
                end
                clear var_name
                ind_avg = [];
                
            end
            
            % Save data
            eval(['PRO_avg_6hr.' inst '=DATA_OUT;'])
            clear DATA_IN DATA_OUT inst ind var_list
            
        end
    end
end


%% Average Hydrocat
if exist('hcat_num','var')
    if hcat_num >0
        
        for j = 1:hcat_num
            
            % Get variables
            inst = ['HCAT_' hcat_sn{j}];
            eval(['DATA_IN=PRO.' inst ';']);
            
            % First check if data record starts late or ends early, if so
            % adjust averaging start and end date
            if floor(start_date)-floor(DATA_IN.mtime(1))<-1 && end_date-DATA_IN.mtime(end)>1
                interp_time = [floor(DATA_IN.mtime(1)):interp_int/24:floor(DATA_IN.mtime(end))];
            elseif floor(start_date)-floor(DATA_IN.mtime(1))<-1
                interp_time = [floor(DATA_IN.mtime(1)):interp_int/24:floor(end_date)];
            elseif end_date-DATA_IN.mtime(end) >1
                interp_time = [floor(start_date):interp_int/24:floor(DATA_IN.mtime(end))];
            else
                interp_time = [floor(start_date):interp_int/24:end_date];
            end
            
            % Record averaging time as middle of interval
            DATA_OUT.interp_time = (interp_time + interp_int/24/2)';
            
            % Average data
            for ind=1:length(interp_time)
                
                % Get matching data points index
                ind_avg = find(DATA_IN.mtime>=interp_time(ind) & DATA_IN.mtime<(interp_time(ind)+interp_int/24));
                
                % Get list of variables for that instrument (remove despiking params)
                field_list = fieldnames(DATA_IN);
                kk=1;
                for k=1:length(field_list)
                    if regexp(field_list{k},'despiking')
                        kk=kk;
                    else
                        var_list{kk,1} = field_list{k};
                        kk=kk+1;
                    end
                end
                clear field_list k kk
                
                % Average all variables in time index
                for k=1:length(var_list)
                    var_name = var_list {k};
                    eval(['DATA_OUT.' var_name '(ind,1)=nanmean(DATA_IN.' var_name '(ind_avg));']);
                end
                clear var_name
                ind_avg = [];
                
            end
            
            % Save data
            eval(['PRO_avg_6hr.' inst '=DATA_OUT;'])
            clear DATA_IN DATA_OUT inst ind var_list
            
        end
    end
end


%% Average ESM-1
if exist('esm1_num','var')
    if esm1_num >0
        
        for j = 1:esm1_num
            
            % Get variables
            inst = ['ESM1_' esm1_sn{j}];
            eval(['DATA_IN=PRO.' inst ';']);
            
            % First check if data record starts late or ends early, if so
            % adjust averaging start and end date
            if floor(start_date)-floor(DATA_IN.mtime(1))<-1 && end_date-DATA_IN.mtime(end)>1
                interp_time = [floor(DATA_IN.mtime(1)):interp_int/24:floor(DATA_IN.mtime(end))];
            elseif floor(start_date)-floor(DATA_IN.mtime(1))<-1
                interp_time = [floor(DATA_IN.mtime(1)):interp_int/24:floor(end_date)];
            elseif end_date-DATA_IN.mtime(end) >1
                interp_time = [floor(start_date):interp_int/24:floor(DATA_IN.mtime(end))];
            else
                interp_time = [floor(start_date):interp_int/24:end_date];
            end
            
            % Record averaging time as middle of interval
            DATA_OUT.interp_time = (interp_time + interp_int/24/2)';
            
            % Average data
            for ind=1:length(interp_time)
                
                % Get matching data points index
                ind_avg = find(DATA_IN.mtime>=interp_time(ind) & DATA_IN.mtime<(interp_time(ind)+interp_int/24));
                
                % Get list of variables for that instrument (remove despiking params)
                field_list = fieldnames(DATA_IN);
                kk=1;
                for k=1:length(field_list)
                    if regexp(field_list{k},'despiking')
                        kk=kk;
                    else
                        var_list{kk,1} = field_list{k};
                        kk=kk+1;
                    end
                end
                clear field_list k kk
                
                % Average all variables in time index
                for k=1:length(var_list)
                    var_name = var_list {k};
                    eval(['DATA_OUT.' var_name '(ind,1)=nanmean(DATA_IN.' var_name '(ind_avg));']);
                end
                clear var_name
                ind_avg = [];
                
            end
            
            % Save data
            eval(['PRO_avg_6hr.' inst '=DATA_OUT;'])
            clear DATA_IN DATA_OUT inst ind var_list
            
        end
    end
end


%% Average SBE37
if exist('sbe37_num','var')
    if sbe37_num >0
        
        for j = 1:sbe37_num
            
            % Get variables
            inst = ['SBE37_' sbe37_sn{j}];
            eval(['DATA_IN=PRO.' inst ';']);
            
            % First check if data record starts late or ends early, if so
            % adjust averaging start and end date
            if floor(start_date)-floor(DATA_IN.mtime(1))<-1 && end_date-DATA_IN.mtime(end)>1
                interp_time = [floor(DATA_IN.mtime(1)):interp_int/24:floor(DATA_IN.mtime(end))];
            elseif floor(start_date)-floor(DATA_IN.mtime(1))<-1
                interp_time = [floor(DATA_IN.mtime(1)):interp_int/24:floor(end_date)];
            elseif end_date-DATA_IN.mtime(end) >1
                interp_time = [floor(start_date):interp_int/24:floor(DATA_IN.mtime(end))];
            else
                interp_time = [floor(start_date):interp_int/24:end_date];
            end
            
            % Record averaging time as middle of interval
            DATA_OUT.interp_time = (interp_time + interp_int/24/2)';
            
            % Average data
            for ind=1:length(interp_time)
                
                % Get matching data points index
                ind_avg = find(DATA_IN.mtime>=interp_time(ind) & DATA_IN.mtime<(interp_time(ind)+interp_int/24));
                
                % Get list of variables for that instrument (remove despiking params)
                field_list = fieldnames(DATA_IN);
                kk=1;
                for k=1:length(field_list)
                    if regexp(field_list{k},'despiking')
                        kk=kk;
                    else
                        var_list{kk,1} = field_list{k};
                        kk=kk+1;
                    end
                end
                clear field_list k kk
                
                % Average all variables in time index
                for k=1:length(var_list)
                    var_name = var_list {k};
                    eval(['DATA_OUT.' var_name '(ind,1)=nanmean(DATA_IN.' var_name '(ind_avg));']);
                end
                clear var_name
                ind_avg = [];
                
            end
            
            % Save data
            eval(['PRO_avg_6hr.' inst '=DATA_OUT;'])
            clear DATA_IN DATA_OUT inst ind var_list
            
        end
    end
end


%% Average SBE56
if exist('sbe56_num','var')
    if sbe56_num >0
        
        for j = 1:sbe56_num
            
            % Get variables
            inst = ['SBE56_' sbe56_sn{j}];
            eval(['DATA_IN=PRO.' inst ';']);
            
            % First check if data record starts late or ends early, if so
            % adjust averaging start and end date
            if floor(start_date)-floor(DATA_IN.mtime(1))<-1 && end_date-DATA_IN.mtime(end)>1
                interp_time = [floor(DATA_IN.mtime(1)):interp_int/24:floor(DATA_IN.mtime(end))];
            elseif floor(start_date)-floor(DATA_IN.mtime(1))<-1
                interp_time = [floor(DATA_IN.mtime(1)):interp_int/24:floor(end_date)];
            elseif end_date-DATA_IN.mtime(end) >1
                interp_time = [floor(start_date):interp_int/24:floor(DATA_IN.mtime(end))];
            else
                interp_time = [floor(start_date):interp_int/24:end_date];
            end
            
            % Record averaging time as middle of interval
            DATA_OUT.interp_time = (interp_time + interp_int/24/2)';
            
            % Average data
            
            for ind=1:length(interp_time)
                
                % Get matching data points index
                ind_avg = find(DATA_IN.mtime>=interp_time(ind) & DATA_IN.mtime<(interp_time(ind)+interp_int/24));
                
                % Get list of variables for that instrument (remove despiking params)
                field_list = fieldnames(DATA_IN);
                kk=1;
                for k=1:length(field_list)
                    if regexp(field_list{k},'despiking')
                        kk=kk;
                    else
                        var_list{kk,1} = field_list{k};
                        kk=kk+1;
                    end
                end
                clear field_list k kk
                
                % Average all variables in time index
                for k=1:length(var_list)
                    var_name = var_list {k};
                    eval(['DATA_OUT.' var_name '(ind,1)=nanmean(DATA_IN.' var_name '(ind_avg));']);
                end
                clear var_name
                ind_avg = [];
                
            end
            
            % Save data
            eval(['PRO_avg_6hr.' inst '=DATA_OUT;'])
            clear DATA_IN DATA_OUT inst ind var_list
            
        end
    end
end


%% Average Minilogs
if exist('ml_num','var')
    if ml_num >0
        
        for j = 1:ml_num
            
            % Get variables
            inst = ['ML_' ml_sn{j}];
            eval(['DATA_IN=PRO.' inst ';']);
            
            % First check if data record starts late or ends early, if so
            % adjust averaging start and end date
            if floor(start_date)-floor(DATA_IN.mtime(1))<-1 && end_date-DATA_IN.mtime(end)>1
                interp_time = [floor(DATA_IN.mtime(1)):interp_int/24:floor(DATA_IN.mtime(end))];
            elseif floor(start_date)-floor(DATA_IN.mtime(1))<-1
                interp_time = [floor(DATA_IN.mtime(1)):interp_int/24:floor(end_date)];
            elseif end_date-DATA_IN.mtime(end) >1
                interp_time = [floor(start_date):interp_int/24:floor(DATA_IN.mtime(end))];
            else
                interp_time = [floor(start_date):interp_int/24:end_date];
            end
            
            % Record averaging time as middle of interval
            DATA_OUT.interp_time = (interp_time + interp_int/24/2)';
            
            % Average data
            for ind=1:length(interp_time)
                
                % Get matching data points index
                ind_avg = find(DATA_IN.mtime>=interp_time(ind) & DATA_IN.mtime<(interp_time(ind)+interp_int/24));
                
                % Get list of variables for that instrument (remove despiking params)
                field_list = fieldnames(DATA_IN);
                kk=1;
                for k=1:length(field_list)
                    if regexp(field_list{k},'despiking')
                        kk=kk;
                    else
                        var_list{kk,1} = field_list{k};
                        kk=kk+1;
                    end
                end
                clear field_list k kk
                
                % Average all variables in time index
                for k=1:length(var_list)
                    var_name = var_list {k};
                    eval(['DATA_OUT.' var_name '(ind,1)=nanmean(DATA_IN.' var_name '(ind_avg));']);
                end
                clear var_name
                ind_avg = [];
                
            end
            
            % Save data
            eval(['PRO_avg_6hr.' inst '=DATA_OUT;'])
            clear DATA_IN DATA_OUT inst ind var_list
            
        end
    end
end


%% Save data
save(mat_fl,'PRO_avg_6hr','-append');

