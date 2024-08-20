function KROP_export_csv(info_file)

% Function to export raw, processed and daily-averaged data to csv format
% ESDU, SAMS, April 19

close all

% Load mooring metadata
I=load(info_file);

% Load mooring data
mat_fl = [I.d_mat '\' I.mooring_id '_CTD.mat'];
M=load(mat_fl);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Export raw data for each instrument
disp('            Exporting RAW data...');

% Get list of instruments
inst_list = fieldnames(M.RAW);

for jj = 1:length(inst_list)
    
    % Get data
    inst = inst_list{jj};
    eval(['data_raw = M.RAW.' inst ';'])

    % Get instrument type & s/n
    inst_info = strsplit(inst,'_');
    inst_type = inst_info{1}; inst_sn = inst_info{2};
    
    % Get variable names
    fn=fieldnames(data_raw);
    
    % Save as individual variables (needed to create table headings later on)
    for kk = 1:length(fn)
        eval([fn{kk} ' = data_raw.' fn{kk} ';'])
    end
    Datetime = datestr(mtime,'dd-mmm-yyyy HH:MM:SS');
    
    % Build table order, depending on which variables exist
    
    % List all possibe variables, in export order
    list_var = {'scan','jday','pres','depth','temp','cond','sal','sigmatheta',...
        'flc_V','flc','par_V','par','oxy','oxy_sat','ph'};
    exp_hdr = 'Datetime,nominal_depth'; % Start of export header
    ee = length(exp_hdr); % export header length
    
    for gg = 1:length(list_var)
        eval(['var_test = exist(''' list_var{gg} ''',''var'');'])
        if var_test>=1 % if variable exists
            if regexp(inst_type,'ML') 
                if regexp(list_var{gg},'temp') % onlye xport temp, do not export depth record (uncorrected and likely to be bad)
                    % Add variable name to header string
                    exp_hdr(ee+1:ee+length(list_var{gg})+1)=[',' list_var{gg}];
                    % Update header string length
                    ee=ee+length(list_var{gg})+1;
                end
            else
                % Add variable name to header string
                exp_hdr(ee+1:ee+length(list_var{gg})+1)=[',' list_var{gg}];
                % Update header string length
                ee=ee+length(list_var{gg})+1;
            end
        end
    end
    
    % Create table
    eval(['exp_tbl = table(' exp_hdr ');']);
    
    % Build export filename
    if regexp(inst_type,'SBE16p')
        inst_str = 'sbe16p';
    elseif regexp(inst_type,'SBE19p')
        inst_str = 'sbe19p';
    elseif regexp(inst_type,'SBE37')
        inst_str = 'sbe37';
    elseif regexp(inst_type,'SBE56')
        inst_str = 'sbe56';
    elseif regexp(inst_type,'ML')
        inst_str = 'minilog';
    elseif regexp(inst_type,'ESM1')
        inst_str = 'esm1';
    elseif regexp(inst_type,'HCAT')
        inst_str = 'hydrocat';
    else
        inst_str = inst;
    end
    fl_out = [I.d_csv '\' I.mooring_id '_raw_' inst_str '_' inst_sn '.csv'];
    
    % Export data as csv
    writetable(exp_tbl,fl_out);
    
    % Tidy up workspace
    keep I M inst_list jj
    
end

clear inst_list


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Export processed data for each instrument
disp('            Exporting PRO data...');

% Get list of instruments
inst_list = fieldnames(M.RAW);

for jj = 1:length(inst_list)
    
    % Get data
    inst = inst_list{jj};
    eval(['data_pro = M.PRO.' inst ';'])

    % Get instrument type & s/n
    inst_info = strsplit(inst,'_');
    inst_type = inst_info{1}; inst_sn = inst_info{2};
    
    % Get variable names
    fn=fieldnames(data_pro);
    
    % Save as individual variables (needed to create table headings later on)
    for kk = 1:length(fn)
        eval([fn{kk} ' = data_pro.' fn{kk} ';'])
    end
    Datetime = datestr(mtime,'dd-mmm-yyyy HH:MM:SS');
    
    % Build table order, depending on which variables exist
    
    % List all possibe variables, in export order
    list_var = {'scan','jday','pres','depth','temp','cond','sal','sigmatheta',...
        'flc_V','flc','par_V','par','oxy','oxy_sat','ph'};
    exp_hdr = 'Datetime,nominal_depth'; % Start of export header
    ee = length(exp_hdr); % export header length
    
    for gg = 1:length(list_var)
        eval(['var_test = exist(''' list_var{gg} ''',''var'');'])
        if var_test>=1 % if variable exists
            if regexp(inst_type,'ML') 
                if regexp(list_var{gg},'temp') % onlye xport temp, do not export depth record (uncorrected and likely to be bad)
                    % Add variable name to header string
                    exp_hdr(ee+1:ee+length(list_var{gg})+1)=[',' list_var{gg}];
                    % Update header string length
                    ee=ee+length(list_var{gg})+1;
                end
            else
                % Add variable name to header string
                exp_hdr(ee+1:ee+length(list_var{gg})+1)=[',' list_var{gg}];
                % Update header string length
                ee=ee+length(list_var{gg})+1;
            end
        end
    end
    
    % Create table
    eval(['exp_tbl = table(' exp_hdr ');']);
    
    % Build export filename
    % Get instrument type for filename
    if regexp(inst_type,'SBE16p')
        inst_str = 'sbe16p';
    elseif regexp(inst_type,'SBE19p')
        inst_str = 'sbe19p';
    elseif regexp(inst_type,'SBE37')
        inst_str = 'sbe37';
    elseif regexp(inst_type,'SBE56')
        inst_str = 'sbe56';
    elseif regexp(inst_type,'ML')
        inst_str = 'minilog';
    elseif regexp(inst_type,'ESM1')
        inst_str = 'esm1';
    elseif regexp(inst_type,'HCAT')
        inst_str = 'hydrocat';
    else
        inst_str = inst;
    end
    fl_out = [I.d_csv '\' I.mooring_id '_pro_' inst_str '_' inst_sn '.csv'];
    
    % Export data as csv
    writetable(exp_tbl,fl_out);
    
    % Tidy up workspace
    keep I M inst_list jj
    
end

clear inst_list


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Export daily averaged data for each instrument
disp('            Exporting AVG (daily) data...');

% Get list of instruments
inst_list = fieldnames(M.PRO);
% Note: do not use pro_avg_daily structure as it has the field "interp_time"

for jj = 1:length(inst_list)
    
    % Get data
    inst = inst_list{jj};
    eval(['data_avg = M.PRO_avg_daily.' inst ';'])
    
    % Get instrument type & s/n
    inst_info = strsplit(inst,'_');
    inst_type = inst_info{1}; inst_sn = inst_info{2};

    % Get variable names
    fn=fieldnames(data_avg);
    
    % Save as individual variables (needed to create table headings later on)
    for kk = 1:length(fn)
        eval([fn{kk} ' = data_avg.' fn{kk} ';'])
    end
    Datetime = datestr(interp_time,'dd-mmm-yyyy HH:MM:SS'); % Use nominal average time in files
    
    % Build table order, depending on which variables exist
    
    % List all possibe variables, in export order
    list_var = {'scan','jday','pres','depth','temp','cond','sal','sigmatheta',...
        'flc_V','flc','par_V','par','oxy','oxy_sat','ph'};
    exp_hdr = 'Datetime,nominal_depth'; % Start of export header
    ee = length(exp_hdr); % export header length
    
    for gg = 1:length(list_var)
        eval(['var_test = exist(''' list_var{gg} ''',''var'');'])
        if var_test>=1 % if variable exists
            if regexp(inst_type,'ML') 
                if regexp(list_var{gg},'temp') % onlye xport temp, do not export depth record (uncorrected and likely to be bad)
                    % Add variable name to header string
                    exp_hdr(ee+1:ee+length(list_var{gg})+1)=[',' list_var{gg}];
                    % Update header string length
                    ee=ee+length(list_var{gg})+1;
                end
            else
                % Add variable name to header string
                exp_hdr(ee+1:ee+length(list_var{gg})+1)=[',' list_var{gg}];
                % Update header string length
                ee=ee+length(list_var{gg})+1;
            end
        end
    end
    
    % Create table
    eval(['exp_tbl = table(' exp_hdr ');']);
    
    % Build export filename
    if regexp(inst_type,'SBE16p')
        inst_str = 'sbe16p';
    elseif regexp(inst_type,'SBE19p')
        inst_str = 'sbe19p';
    elseif regexp(inst_type,'SBE37')
        inst_str = 'sbe37';
    elseif regexp(inst_type,'SBE56')
        inst_str = 'sbe56';
    elseif regexp(inst_type,'ML')
        inst_str = 'minilog';
    elseif regexp(inst_type,'ESM1')
        inst_str = 'esm1';
    elseif regexp(inst_type,'HCAT')
        inst_str = 'hydrocat';
    else
        inst_str = inst;
    end
    fl_out = [I.d_csv '\' I.mooring_id '_avg_24h_' inst_str '_' inst_sn '.csv'];
    
    % Export data as csv
    writetable(exp_tbl,fl_out);
    
    % Tidy up workspace
    keep I M inst_list jj
    
end

clear inst_list
 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Export temperature grid
disp('            Exporting gridded temperature data...');

% Build export filename
fl_out = [I.d_csv '\' I.mooring_id '_grid_temp.csv'];

% Convert to epoch time
T_out=zeros(1,length(M.PRO_grid_temp.interp_time)+1);
T_out(2:end) = posixtime(datetime(M.PRO_grid_temp.interp_time,'ConvertFrom','datenum'));

% Rearrange export array
DAT_out = nan(length(M.PRO_grid_temp.interp_depth),length(M.PRO_grid_temp.interp_time)+1);
DAT_out(:,1) = M.PRO_grid_temp.interp_depth;
DAT_out(:,2:end) = M.PRO_grid_temp.interp_temp;

% Export data
dlmwrite(fl_out,T_out,'delimiter',',','precision','%.1f');
dlmwrite(fl_out,DAT_out,'delimiter',',','precision','%.3f','-append');
