function KROP_export_nc_avg(info_file)

% Script to export KROP mooring data (CTD) in NetCDF format - full res
% ESDU, SAMS, Dec19

% NetCDF file creation steps:
%   1) Load data
%   2) Create nc file
%   3) Write variables
%   3) Write file attributes
%   5) Write variable attributes

% Note: currently there are sections of code for each intrument (clearer / 
% easier to write it that way), but in future versions this script could be 
% improved by merging the individual bits of code and make it applicable to
% all instrument types. 

%%% File 2: daily-averaged timeseries for each instrument

% Turn warnings off for empty date strings (when no cal date because sensor doesn't exist)
warning('off','MATLAB:datenum:EmptyDate')


% 1) Load data
I = load(info_file);

% First check if nc files have already been created, if so delete them
% (this script won't overwrite the files and crash)
eval(['cd ' I.d_nc])
nc_list = dir('*avg*.nc');
if ~isempty(nc_list)
    for n = 1:length(nc_list)
        eval(['delete ' nc_list(n).name])   
    end
end
clear nc_list n
eval(['cd ' I.d_matlab])

% Load data
m_mat = [I.d_mat '\' I.mooring_id '_CTD.mat'];
M = load(m_mat);

%% NetCDF attributes:

% Global attributes will be the same for each file and are set by the user in the info file
% For variable attributes we have a list of default values, compiled in KROP_data_att.mat
% It would be very time-consuming for the user to review each attribute for
% each attribute, instead give the option at the start to view and edit only
% the ones they want

% Setup user options
% Processing level (standard options from OceanSites guidelines)
opt_pl = {'Raw instrument data',...
    'Instrument data that has been converted to geophysical values',...
    'Post-recovery calibrations have been applied',...
    'Data has been scaled using contextual information',...
    'Known bad data has been replaced with null values',...
    'Known bad data has been replaced with values based on surrounding data',...
    'Ranges applied, bad data flagged',...
    'Data interpolated',...
    'Data manually reviewed',...
    'Data verified against model or other contextual information',...
    'Other QC process applied '};
ind_pl = [1:length(opt_pl)];
% QC indicators (standard options from OceanSites guidelines)
opt_qc = {'unknown / no QC was performed',...
    'good data, all QC tests passed',...
    'probably good data',...
    'potentially correctable bad data, these data are not to be used without scientific correction or re-calibration',...
    'bad data, data have failed one or more tests',...
    '[not used] ',...
    '[not used] ',...
    'nominal value, data were not observed but reported (e.g. instrument target depth)',...
    'interpolated value, missing data may be interpolated from neighboring data in space or time',...
    'missing value / fill value'};
ind_qc = [0:9];


% Get list of instruments on mooring
list_inst = fieldnames(M.PRO);


% Loop through each instrument
for ind_inst = 1:length(list_inst)
    
    % Get instrument info
    inst = list_inst{ind_inst};
    inst_info = strsplit(inst,'_');
    inst_type = inst_info{1};
    inst_sn = inst_info{2};
    % Set output filetype
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
    
    % Get data
    eval(['data_AVG = M.PRO_avg_daily.' inst ';'])
    
    % Ask user if they want to edit any attributes
    ans_yn = 0;
    while ans_yn == 0
        ans_edt = input(['Do you want to edit any attributes for ' inst_type ' S/N ' inst_sn ' (averaged data)? (y/n)     '],'s');
        if regexp(ans_edt,'y','ignorecase')
            inst_edt = 1;
            ans_yn = 1;
        elseif regexp(ans_edt,'n','ignorecase')
            inst_edt = 0;
            ans_yn = 1;
        end
    end
    
    
    
    %%   2) Create nc file and add metadata
    
    eval(['cd ' I.d_nc])
    ncf = [I.mooring_id '_pro_avg24h_' inst_str '_' inst_sn '.nc'];
    nccreate(ncf,'mooring','DataType','char','Dimensions',{'txt1',1,'txt2',length(I.mooring_id)},'FillValue','');
    ncwrite(ncf,'mooring',I.mooring_id)
    nccreate(ncf,'latitude','DataType','double','FillValue',NaN)
    ncwrite(ncf,'latitude',I.mooring_lat)
    ncwriteatt(ncf,'latitude','geospatial_lat_units','degrees_north');
    nccreate(ncf,'longitude','DataType','double','FillValue',NaN)
    ncwrite(ncf,'longitude',I.mooring_lon)
    ncwriteatt(ncf,'longitude','geospatial_lon_units','degrees_east');
    nccreate(ncf,'bottom_depth','DataType','double','FillValue',NaN)
    ncwrite(ncf,'bottom_depth',I.mooring_depth)
    ncwriteatt(ncf,'bottom_depth','units','meters');
    ncwriteatt(ncf,'bottom_depth','positive','down');
    ncwriteatt(ncf,'bottom_depth','comment','Seafloor depth at mooring site');
    
    
    %% Add global attributes
    
    % Global attributes --> to do: write script to compile metadata
    ga_tit = [I.mooring_id '_pro_avg_' inst_str '_' inst_sn];
    if regexp(inst_type,'ESM1','ignorecase')
        ga_sum = ['24h averaged fluorescence data from ESM-1 logger at ' num2str(data_AVG.nominal_depth(1)) 'm on mooring ' I.mooring_id];
    else
        ga_sum = ['24h averaged post-processed CTD data from ' inst_str ' at ' num2str(data_AVG.nominal_depth(1)) 'm on mooring ' I.mooring_id];
    end
    ga_dt = 'Moored CTD time-series data';
    ga_ft = 'timeSeries';
    ga_src = 'subsurface mooring';
    ga_id = I.mooring_id;
    % Dates in format "2017-08-13T21:00:00Z"
    ga_ts = datestr(I.start_date,'yyyy-mm-ddTHH:MM:SSZ');
    ga_te = datestr(I.end_date,'yyyy-mm-ddTHH:MM:SSZ');
    if regexp(I.mooring_id(1:2),'KF')
        ga_area = 'Kongsfjorden';
    elseif regexp(I.mooring_id(1:2),'RF')
        ga_area = 'Rijpfjorden';
    elseif regexp(I.mooring_id(1:3),'ADF')
        ga_area = 'Adventfjorden';
    elseif regexp(I.mooring_id(1:3),'BIF')
        ga_area = 'Billefjorden';
    elseif regexp(I.mooring_id(1:3),'HOS')
        ga_area = 'Hornsund';
    elseif regexp(I.mooring_id(1:3),'ISF')
        ga_area = 'Isfjorden';
    elseif regexp(I.mooring_id(1:3),'MAF')
        ga_area = 'Magdalenefjorden';
    elseif regexp(I.mooring_id(1:3),'RAF')
        ga_area = 'Ramfjorden';
    end
    ga_lat_min = num2str(I.mooring_lat);
    ga_lat_max = num2str(I.mooring_lat);
    ga_lat_units = 'degrees_north';
    ga_lon_min = num2str(I.mooring_lon);
    ga_lon_max = num2str(I.mooring_lon);
    ga_lon_units = 'degrees_east';
    ga_inst = I.ga_inst;
    ga_array = I.ga_array;
    ga_proj = I.ga_proj;
    ga_cont = I.ga_cont;
    if isfield(I,['ga_cmt_' inst_sn])
        eval(['ga_cmt = I.ga_cmt_' inst_sn ';']);
    else
        ga_cmt = I.ga_cmt;
    end
    
    % Write atttributes
    ncwriteatt(ncf,'/','title',ga_tit);
    ncwriteatt(ncf,'/','summary',ga_sum);
    ncwriteatt(ncf,'/','data_type',ga_dt);
    ncwriteatt(ncf,'/','featureType',ga_ft);
    ncwriteatt(ncf,'/','source',ga_src);
    ncwriteatt(ncf,'/','institution',ga_inst);
    ncwriteatt(ncf,'/','project',ga_proj);
    ncwriteatt(ncf,'/','array',ga_array);
    ncwriteatt(ncf,'/','id',ga_id);
    ncwriteatt(ncf,'/','time_coverage_start',ga_ts);
    ncwriteatt(ncf,'/','time_coverage_end',ga_te);
    ncwriteatt(ncf,'/','area',ga_area);
    ncwriteatt(ncf,'/','geospatial_lat_min',ga_lat_min);
    ncwriteatt(ncf,'/','geospatial_lat_max',ga_lat_max);
    ncwriteatt(ncf,'/','geospatial_lat_units',ga_lat_units);
    ncwriteatt(ncf,'/','geospatial_lon_min',ga_lon_min);
    ncwriteatt(ncf,'/','geospatial_lon_max',ga_lon_max);
    ncwriteatt(ncf,'/','geospatial_lon_units',ga_lon_units);
    ncwriteatt(ncf,'/','contributor_name',ga_cont);
    ncwriteatt(ncf,'/','comment',ga_cmt);
    ncwriteatt(ncf,'/','date_created',datestr(datetime(),'yyyy-mm-ddTHH:MM:SSZ'));
    
    
    %%   3) Write variables data and attributes
    % Note: done here for each specific instrument type separately,
    % although this could be coded as generic to apply to all instrument
    % types.
    
    %%
    if regexp(inst_type,'SBE16p')
        
        % Get position of instrument in info file
        for k=1:length(I.sbe16p_sn); sbe16p_sn_num(k)=str2double(I.sbe16p_sn{k}); end
        j = find(sbe16p_sn_num==str2double(inst_sn));

        
        % Load variable attrbutes template
        ATT = load([I.d_matlab '\KROP_data_att_avg.mat']);
        
        % List all possible variables
        var_list = {'interp_time','scan','nominal_depth','pres','depth',...
            'temp','cond','sal','sigmatheta','flc_V','flc',...
            'par_V','par','tur_V','tur'};
        % List name of export variables
        var_list_new = {'time','scan','nominal_depth','pressure','depth',...
            'temperature','conductivity','salinity','density','fluo_V','fluo',...
            'par_V','par','turbidity_V','turbidity'};
        
        for jj = 1:length(var_list)
            if isfield(data_AVG,var_list{jj})
                var_name = char(var_list{jj});
                if regexp(var_name(1:2),'mt')
                    % Convert matlab time to epoch time
                    var_data = (86400 * (data_AVG.mtime - datenum('01-Jan-1970 00:00:00')));
                else
                    eval(['var_data = data_AVG.' var_list{jj} ';'])
                end
                clear var_name
                var_name_new = var_list_new{jj};
                nccreate(ncf,var_name_new,'DataType','double','Dimensions',{'var1',length(var_data),'var2',1},'FillValue',NaN)
                ncwrite(ncf,var_name_new,var_data)
                
                % Write variable attributes
                % For each sensor variable ask user to check :
                % - sensor_model
                % - sensor_serial_number
                % - sensor_calibration_date
                % - processing level
                % - QC indicator
                % - Comment
                
                % Get calibration dates from info file
                % To start with add attribute as given in info file, then
                % try formatting into standard datetime format
                % (YYYY-MM-DDTHH:MM:SSZ) using try/catch in case the entries
                % are not a recognisable date format (could be 'unknown'
                % if no cal date available)
                
                caldatestr_p = I.sbe16p_p_cal_date{j};
                try caldate_p = datenum(I.sbe16p_p_cal_date{j});
                    caldatestr_p = datestr(caldate_p,'yyyy-mm-ddTHH:MM:SSZ');
                catch
                end
                
                caldatestr_t = I.sbe16p_t_cal_date{j};
                try caldate_t = datenum(I.sbe16p_t_cal_date{j});
                    caldatestr_t = datestr(caldate_t,'yyyy-mm-ddTHH:MM:SSZ');
                catch
                end
                
                caldatestr_c = I.sbe16p_c_cal_date{j};
                try caldate_c = datenum(I.sbe16p_c_cal_date{j});
                    caldatestr_c = datestr(caldate_c,'yyyy-mm-ddTHH:MM:SSZ');
                catch
                end
                
                caldatestr_flc = I.sbe16p_flc_cal_date{j};
                try caldate_flc = datenum(I.sbe16p_flc_cal_date{j});
                    caldatestr_flc = datestr(caldate_flc,'yyyy-mm-ddTHH:MM:SSZ');
                catch
                end
                
                caldatestr_par = I.sbe16p_par_cal_date{j};
                try caldate_par = datenum(I.sbe16p_par_cal_date{j});
                    caldatestr_par = datestr(caldate_par,'yyyy-mm-ddTHH:MM:SSZ');
                catch
                end
                
                caldatestr_tur = I.sbe16p_tur_cal_date{j};
                try caldate_tur = datenum(I.sbe16p_tur_cal_date{j});
                    caldatestr_tur = datestr(caldate_tur,'yyyy-mm-ddTHH:MM:SSZ');
                catch
                end
                
                if jj>3 % First three variables are time, scan and nominal depth --> no need for extra attritbutes
                    
                    def_sensor = 'SBE16plus';
                    
                    if (regexp(var_name_new(1:3),'pre| dep'))
                        eval(['ATT.' var_name_new '.sensor_model = ''' def_sensor ''';'])
                        eval(['ATT.' var_name_new '.sensor_serial_number = ''' inst_sn ''';'])
                        eval(['ATT.' var_name_new '.sensor_calibration_date = ''' caldatestr_p ''';'])
                    elseif (regexp(var_name_new(1:3),'tem'))
                        eval(['ATT.' var_name_new '.sensor_model = ''' def_sensor ''';'])
                        eval(['ATT.' var_name_new '.sensor_serial_number = ''' inst_sn ''';'])
                        eval(['ATT.' var_name_new '.sensor_calibration_date = ''' caldatestr_t ''';'])
                    elseif (regexp(var_name_new(1:3),'con| sal |den'))
                        eval(['ATT.' var_name_new '.sensor_model = ''' def_sensor ''';'])
                        eval(['ATT.' var_name_new '.sensor_serial_number = ''' inst_sn ''';'])
                        eval(['ATT.' var_name_new '.sensor_calibration_date = ''' caldatestr_c ''';'])
                    elseif (regexp(var_name_new(1:3),'flu'))
                        eval(['ATT.' var_name_new '.sensor_model = ''' I.sbe16p_flc_type{j} ' fluorometer installed on ' def_sensor ''';'])
                        eval(['ATT.' var_name_new '.sensor_serial_number = ''' I.sbe16p_flc_sn{j} ''';'])
                        eval(['ATT.' var_name_new '.sensor_calibration_date = ''' caldatestr_flc ''';'])
                    elseif (regexp(var_name_new(1:3),'par'))
                        eval(['ATT.' var_name_new '.sensor_model = ''' I.sbe16p_par_type{j} ' PAR sensor installed on ' def_sensor ''';'])
                        eval(['ATT.' var_name_new '.sensor_serial_number = ''' I.sbe16p_par_sn{j} ''';'])
                        eval(['ATT.' var_name_new '.sensor_calibration_date = ''' caldatestr_par ''';'])
                    elseif (regexp(var_name_new(1:3),'tur'))
                        eval(['ATT.' var_name_new '.sensor_model = ''' I.sbe16p_tur_type{j} ' turbidity sensor installed on ' def_sensor ''';'])
                        eval(['ATT.' var_name_new '.sensor_serial_number = ''' I.sbe16p_tur_sn{j} ''';'])
                        eval(['ATT.' var_name_new '.sensor_calibration_date = ''' caldatestr_tur ''';'])
                    end
                    
                    % Processing level
                    eval(['def_pl = ATT.' var_name_new '.Processing_level;']);
                    if inst_edt == 1
                        disp(' ')
                        disp([def_sensor ' S/N ' inst_sn ' : ' var_name_new ' : Processing level'])
                        disp(['default = ' def_pl])
                        ans_pl=input('Accept default?(y/n)        ','s');
                        while regexp(ans_pl,'n','ignorecase')
                            disp('Select processing level:')
                            for jjj = 1:length((ind_pl))
                                disp([num2str(jjj) ' = ' opt_pl{jjj}])
                            end
                            pick_pl=str2double(input('Select processing level:     ','s'));
                            if (pick_pl>0 && pick_pl<max(ind_pl))
                                ans_pl = 'y';
                                eval(['ATT.' var_name_new '.Processing_level = ''' opt_pl{pick_pl} ''';'])
                            end
                        end
                    end
                    
                    % QC indicator
                    eval(['def_qc = ATT.' var_name_new '.QC_indicator;']);
                    if inst_edt == 1
                        disp(' ')
                        disp([def_sensor ' S/N ' inst_sn ' : ' var_name_new ' : QC indicator'])
                        disp(['default = ' num2str(def_qc) ' ' opt_qc{def_qc+1}])
                        ans_qc=input('Accept default?(y/n)        ','s');
                        while regexp(ans_qc,'n','ignorecase')
                            disp('Select processing level:')
                            for jjj = 1:length((ind_qc))
                                disp([num2str(ind_qc(jjj)) ' = ' opt_qc{jjj}])
                            end
                            pick_qc=str2double(input('Select QC indicator:     ','s'));
                            if (pick_qc>=0 && pick_qc<(max(ind_qc)))
                                ans_qc = 'y';
                                eval(['ATT.' var_name_new '.QC_indicator = ' num2str(pick_qc) ';'])
                            end
                        end
                    end
                    
                    % Comment
                    eval(['def_cm = ATT.' var_name_new '.comment;']);
                    if inst_edt == 1
                        disp(' ')
                        disp([def_sensor ' S/N ' inst_sn ' : ' var_name_new ' : comment'])
                        disp(['default = ' def_cm])
                        ans_cm=input('Accept default?(y/n)        ','s');
                        if regexp(ans_cm,'n','ignorecase')
                            pick_cm = input('Enter comment:     ','s');
                            eval(['ATT.' var_name_new '.comment = ''' pick_cm ''';'])
                        end
                    end
                    
                end
                
                eval(['no_fields = numel(fieldnames(ATT.' var_name_new '));'])
                eval(['field_list = fieldnames(ATT.' var_name_new ');'])
                for jjj = 1:no_fields
                    eval(['ncwriteatt(ncf,''' var_name_new ''',''' field_list{jjj} ''',ATT.' var_name_new '.' field_list{jjj} ');'])
                end
                % Exception: different units for PAR sensors
                if regexp(var_name_new,'par')
                    if regexp(var_name_new,'par_V')
                        ok=0;
                    else
                        if regexp(I.sbe16p_par_type{j},'Satlantic','ignorecase')
                            ok=1; % All good
                        elseif regexp(I.sbe16p_par_type{j},'Biospherical','ignorecase')
                            ncwriteatt(ncf,'par','units',ATT.par_biospherical.units);
                        else
                            disp('PAR sensor model not recognised')
                            break
                        end
                    end
                end
                clear jjj
                clear var_data var_name_new no_fields field_list...
                    caldate* def_sensor ans_pl pick_pl ans_qc pick_qc...
                    ans_cm pick_cm
            end
        end
        clear jj var_l*
        disp('********************')
        
    %%
    elseif regexp(inst_type,'SBE19p')
        
        % Get position of instrument in info file
        for k=1:length(I.sbe19p_sn); sbe19p_sn_num(k)=str2double(I.sbe19p_sn{k}); end
        j = find(sbe19p_sn_num==str2double(inst_sn));
        
        % Load variable attributes template
        ATT = load([I.d_matlab '\KROP_data_att_avg.mat']);
        
        % List all possible variables
        var_list = {'interp_time','scan','nominal_depth','pres','depth',...
            'temp','cond','sal','sigmatheta','flc_V','flc',...
            'par_V','par','tur_V','tur'};
        % List name of export variables
        var_list_new = {'time','scan','nominal_depth','pressure','depth',...
            'temperature','conductivity','salinity','density','fluo_V','fluo',...
            'par_V','par','turbidity_V','turbidity'};
        
        
        for jj = 1:length(var_list)
            if isfield(data_AVG,var_list{jj})
                var_name = char(var_list{jj});
                if regexp(var_name(1:2),'mt')
                    % Convert matlab time to epoch time
                    var_data = (86400 * (data_AVG.mtime - datenum('01-Jan-1970 00:00:00')));
                else
                    eval(['var_data = data_AVG.' var_list{jj} ';'])
                end
                clear var_name
                var_name_new = var_list_new{jj};
                nccreate(ncf,var_name_new,'DataType','double','Dimensions',{'var1',length(var_data),'var2',1},'FillValue',NaN)
                ncwrite(ncf,var_name_new,var_data)
                
                % Write variable attributes
                % For each sensor variable ask user to check :
                % - sensor_model
                % - sensor_serial_number
                % - sensor_calibration_date
                % - processing level
                % - QC indicator
                % - Comment
                
                % Get calibration dates from info file
                % To start with add attribute as given in info file, then
                % try formatting into standard datetime format
                % (YYYY-MM-DDTHH:MM:SSZ) using try/catch in case the entries
                % are not a recognisable date format (could be 'unknown'
                % if no cal date available)
                
                caldatestr_p = I.sbe19p_p_cal_date{j};
                try caldate_p = datenum(I.sbe19p_p_cal_date{j});
                    caldatestr_p = datestr(caldate_p,'yyyy-mm-ddTHH:MM:SSZ');
                catch
                end
                
                caldatestr_t = I.sbe19p_t_cal_date{j};
                try caldate_t = datenum(I.sbe19p_t_cal_date{j});
                    caldatestr_t = datestr(caldate_t,'yyyy-mm-ddTHH:MM:SSZ');
                catch
                end
                
                caldatestr_c = I.sbe19p_c_cal_date{j};
                try caldate_c = datenum(I.sbe19p_c_cal_date{j});
                    caldatestr_c = datestr(caldate_c,'yyyy-mm-ddTHH:MM:SSZ');
                catch
                end
                
                caldatestr_flc = I.sbe19p_flc_cal_date{j};
                try caldate_flc = datenum(I.sbe19p_flc_cal_date{j});
                    caldatestr_flc = datestr(caldate_flc,'yyyy-mm-ddTHH:MM:SSZ');
                catch
                end
                
                caldatestr_par = I.sbe19p_par_cal_date{j};
                try caldate_par = datenum(I.sbe19p_par_cal_date{j});
                    caldatestr_par = datestr(caldate_par,'yyyy-mm-ddTHH:MM:SSZ');
                catch
                end
                
                caldatestr_tur = I.sbe19p_tur_cal_date{j};
                try caldate_tur = datenum(I.sbe19p_tur_cal_date{j});
                    caldatestr_tur = datestr(caldate_tur,'yyyy-mm-ddTHH:MM:SSZ');
                catch
                end
                
                if jj>3 % First three variables are time, scan and nominal depth --> no need for extra attritbutes
                    
                    def_sensor = 'SBE19plus';
                    
                    if (regexp(var_name_new(1:3),'pre| dep'))
                        eval(['ATT.' var_name_new '.sensor_model = ''' def_sensor ''';'])
                        eval(['ATT.' var_name_new '.sensor_serial_number = ''' inst_sn ''';'])
                        eval(['ATT.' var_name_new '.sensor_calibration_date = ''' caldatestr_p ''';'])
                    elseif (regexp(var_name_new(1:3),'tem'))
                        eval(['ATT.' var_name_new '.sensor_model = ''' def_sensor ''';'])
                        eval(['ATT.' var_name_new '.sensor_serial_number = ''' inst_sn ''';'])
                        eval(['ATT.' var_name_new '.sensor_calibration_date = ''' caldatestr_t ''';'])
                    elseif (regexp(var_name_new(1:3),'con| sal |den'))
                        eval(['ATT.' var_name_new '.sensor_model = ''' def_sensor ''';'])
                        eval(['ATT.' var_name_new '.sensor_serial_number = ''' inst_sn ''';'])
                        eval(['ATT.' var_name_new '.sensor_calibration_date = ''' caldatestr_c ''';'])
                    elseif (regexp(var_name_new(1:3),'flu'))
                        eval(['ATT.' var_name_new '.sensor_model = ''' I.sbe19p_flc_type{j} ' fluorometer installed on ' def_sensor ''';'])
                        eval(['ATT.' var_name_new '.sensor_serial_number = ''' I.sbe19p_flc_sn{j} ''';'])
                        eval(['ATT.' var_name_new '.sensor_calibration_date = ''' caldatestr_flc ''';'])
                    elseif (regexp(var_name_new(1:3),'par'))
                        eval(['ATT.' var_name_new '.sensor_model = ''' I.sbe19p_par_type{j} ' PAR sensor installed on ' def_sensor ''';'])
                        eval(['ATT.' var_name_new '.sensor_serial_number = ''' I.sbe19p_par_sn{j} ''';'])
                        eval(['ATT.' var_name_new '.sensor_calibration_date = ''' caldatestr_par ''';'])
                    elseif (regexp(var_name_new(1:3),'tur'))
                        eval(['ATT.' var_name_new '.sensor_model = ''' I.sbe19p_tur_type{j} ' turbidity sensor installed on ' def_sensor ''';'])
                        eval(['ATT.' var_name_new '.sensor_serial_number = ''' I.sbe19p_tur_sn{j} ''';'])
                        eval(['ATT.' var_name_new '.sensor_calibration_date = ''' caldatestr_tur ''';'])
                    end
                    
                    % Processing level
                    eval(['def_pl = ATT.' var_name_new '.Processing_level;']);
                    if inst_edt == 1
                        disp(' ')
                        disp([def_sensor ' S/N ' inst_sn ' : ' var_name_new ' : Processing level'])
                        disp(['default = ' def_pl])
                        ans_pl=input('Accept default?(y/n)        ','s');
                        while regexp(ans_pl,'n','ignorecase')
                            disp('Select processing level:')
                            for jjj = 1:length((ind_pl))
                                disp([num2str(jjj) ' = ' opt_pl{jjj}])
                            end
                            pick_pl=str2double(input('Select processing level:     ','s'));
                            if (pick_pl>0 && pick_pl<max(ind_pl))
                                ans_pl = 'y';
                                eval(['ATT.' var_name_new '.Processing_level = ''' opt_pl{pick_pl} ''';'])
                            end
                        end
                    end
                    
                    % QC indicator
                    eval(['def_qc = ATT.' var_name_new '.QC_indicator;']);
                    if inst_edt == 1
                        disp(' ')
                        disp([def_sensor ' S/N ' inst_sn ' : ' var_name_new ' : QC indicator'])
                        disp(['default = ' num2str(def_qc) ' ' opt_qc{def_qc+1}])
                        ans_qc=input('Accept default?(y/n)        ','s');
                        while regexp(ans_qc,'n','ignorecase')
                            disp('Select processing level:')
                            for jjj = 1:length((ind_qc))
                                disp([num2str(ind_qc(jjj)) ' = ' opt_qc{jjj}])
                            end
                            pick_qc=str2double(input('Select QC indicator:     ','s'));
                            if (pick_qc>=0 && pick_qc<(max(ind_qc)))
                                ans_qc = 'y';
                                eval(['ATT.' var_name_new '.QC_indicator = ' num2str(pick_qc) ';'])
                            end
                        end
                    end
                    
                    % Comment
                    eval(['def_cm = ATT.' var_name_new '.comment;']);
                    if inst_edt == 1
                        disp(' ')
                        disp([def_sensor ' S/N ' inst_sn ' : ' var_name_new ' : comment'])
                        disp(['default = ' def_cm])
                        ans_cm=input('Accept default?(y/n)        ','s');
                        if regexp(ans_cm,'n','ignorecase')
                            pick_cm = input('Enter comment:     ','s');
                            eval(['ATT.' var_name_new '.comment = ''' pick_cm ''';'])
                        end
                    end
                    
                end
                
                eval(['no_fields = numel(fieldnames(ATT.' var_name_new '));'])
                eval(['field_list = fieldnames(ATT.' var_name_new ');'])
                for jjj = 1:no_fields
                    eval(['ncwriteatt(ncf,''' var_name_new ''',''' field_list{jjj} ''',ATT.' var_name_new '.' field_list{jjj} ');'])
                end
                % Exception: different units for PAR sensors
                if regexp(var_name_new,'par')
                    if regexp(var_name_new,'par_V')
                        ok=0;
                    else
                        if regexp(I.sbe19p_par_type{j},'Satlantic','ignorecase')
                            ok=1; % All good
                        elseif regexp(I.sbe19p_par_type{j},'Biospherical','ignorecase')
                            ncwriteatt(ncf,'par','units',ATT.par_biospherical.units);
                        else
                            disp('PAR sensor model not recognised')
                            break
                        end
                    end
                end
                clear jjj
                clear var_data var_name_new no_fields field_list...
                    caldate* def_sensor ans_pl pick_pl ans_qc pick_qc...
                    ans_cm pick_cm
            end
        end
        clear jj var_l*
        disp('********************')
      
        
    %%
    elseif regexp(inst_type,'HCAT')
        
        % Get position of instrument in info file
        for k=1:length(I.hcat_sn); hcat_sn_num(k)=str2double(I.hcat_sn{k}); end
        j = find(hcat_sn_num==str2double(inst_sn));
        
        % Load variable attributes template
        ATT = load([I.d_matlab '\KROP_data_att_avg.mat']);
       
        % List all possible variables
        var_list = {'interp_time','scan','nominal_depth','pres','depth','temp',...
            'cond','sal','sigmatheta','oxy','oxy_sat','ph','flc','tur'};
        % List name of export variables
        var_list_new = {'time','scan','nominal_depth','pressure','depth',...
            'temperature','conductivity','salinity','density',...
            'oxygen','oxygen_saturation','pH','fluo','turbidity'};
        
        
        for jj = 1:length(var_list)
            if isfield(data_AVG,var_list{jj})
                var_name = char(var_list{jj});
                if regexp(var_name(1:2),'mt')
                    % Convert matlab time to epoch time
                    var_data = (86400 * (data_AVG.mtime - datenum('01-Jan-1970 00:00:00')));
                else
                    eval(['var_data = data_AVG.' var_list{jj} ';'])
                end
                clear var_name
                var_name_new = var_list_new{jj};
                nccreate(ncf,var_name_new,'DataType','double','Dimensions',{'var1',length(var_data),'var2',1},'FillValue',NaN)
                ncwrite(ncf,var_name_new,var_data)
                
                % Write variable attributes
                % For each sensor variable ask user to check :
                % - sensor_model
                % - sensor_serial_number
                % - sensor_calibration_date
                % - processing level
                % - QC indicator
                % - Comment
                
                % Get calibration dates from info file
                % To start with add attribute as given in info file, then
                % try formatting into standard datetime format
                % (YYYY-MM-DDTHH:MM:SSZ) using try/catch in case the entries
                % are not a recognisable date format (could be 'unknown'
                % if no cal date available)
                
                caldatestr_p = I.hcat_p_cal_date{j};
                try caldate_p = datenum(I.hcat_p_cal_date{j});
                    caldatestr_p = datestr(caldate_p,'yyyy-mm-ddTHH:MM:SSZ');
                catch
                end
                
                caldatestr_t = I.hcat_t_cal_date{j};
                try caldate_t = datenum(I.hcat_t_cal_date{j});
                    caldatestr_t = datestr(caldate_t,'yyyy-mm-ddTHH:MM:SSZ');
                catch
                end
                
                caldatestr_c = I.hcat_c_cal_date{j};
                try caldate_c = datenum(I.hcat_c_cal_date{j});
                    caldatestr_c = datestr(caldate_c,'yyyy-mm-ddTHH:MM:SSZ');
                catch
                end
                
                caldatestr_oxy = I.hcat_oxy_cal_date{j};
                try caldate_oxy = datenum(I.hcat_oxy_cal_date{j});
                    caldatestr_oxy = datestr(caldate_oxy,'yyyy-mm-ddTHH:MM:SSZ');
                catch
                end
                
                caldatestr_flc = I.hcat_flc_cal_date{j};
                try caldate_flc = datenum(I.hcat_flc_cal_date{j});
                    caldatestr_flc = datestr(caldate_flc,'yyyy-mm-ddTHH:MM:SSZ');
                catch
                end
                
                caldatestr_ph = I.hcat_ph_cal_date{j};
                try caldate_ph = datenum(I.hcat_ph_cal_date{j});
                    caldatestr_ph = datestr(caldate_ph,'yyyy-mm-ddTHH:MM:SSZ');
                catch
                end
                
                caldatestr_tur = I.hcat_tur_cal_date{j};
                try caldate_tur = datenum(I.hcat_tur_cal_date{j});
                    caldatestr_tur = datestr(caldate_tur,'yyyy-mm-ddTHH:MM:SSZ');
                catch
                end
                
                if jj>3 % First three variables are time, scan and nominal depth --> no need for extra attritbutes
                    
                    def_sensor = 'Hydrocat';
                    
                    if (regexp(var_name_new(1:2),'pH')) % Need to list pH first as only 2 characters in name
                        eval(['ATT.' var_name_new '.sensor_model = ''' I.hcat_ph_type{j} ' sensor installed on ' def_sensor ''';'])
                        eval(['ATT.' var_name_new '.sensor_serial_number = ''' I.hcat_ph_sn{j} ''';'])
                        eval(['ATT.' var_name_new '.sensor_calibration_date = ''' caldatestr_ph ''';'])
                    elseif (regexp(var_name_new(1:3),'pre| dep'))
                        eval(['ATT.' var_name_new '.sensor_model = ''' def_sensor ''';'])
                        eval(['ATT.' var_name_new '.sensor_serial_number = ''' inst_sn ''';'])
                        eval(['ATT.' var_name_new '.sensor_calibration_date = ''' caldatestr_p ''';'])
                    elseif (regexp(var_name_new(1:3),'tem'))
                        eval(['ATT.' var_name_new '.sensor_model = ''' def_sensor ''';'])
                        eval(['ATT.' var_name_new '.sensor_serial_number = ''' inst_sn ''';'])
                        eval(['ATT.' var_name_new '.sensor_calibration_date = ''' caldatestr_t ''';'])
                    elseif (regexp(var_name_new(1:3),'con| sal |den'))
                        eval(['ATT.' var_name_new '.sensor_model = ''' def_sensor ''';'])
                        eval(['ATT.' var_name_new '.sensor_serial_number = ''' inst_sn ''';'])
                        eval(['ATT.' var_name_new '.sensor_calibration_date = ''' caldatestr_c ''';'])
                    elseif (regexp(var_name_new(1:3),'oxy')) % for oxygen and oxygen_saturation
                        eval(['ATT.' var_name_new '.sensor_model = ''' I.hcat_oxy_type{j} ' oxygen sensor installed on ' def_sensor ''';'])
                        eval(['ATT.' var_name_new '.sensor_serial_number = ''' I.hcat_oxy_sn{j} ''';'])
                        eval(['ATT.' var_name_new '.sensor_calibration_date = ''' caldatestr_oxy ''';'])
                    elseif (regexp(var_name_new(1:3),'flu'))
                        eval(['ATT.' var_name_new '.sensor_model = ''' I.hcat_flc_type{j} ' fluorometer installed on ' def_sensor ''';'])
                        eval(['ATT.' var_name_new '.sensor_serial_number = ''' I.hcat_flc_sn{j} ''';'])
                        eval(['ATT.' var_name_new '.sensor_calibration_date = ''' caldatestr_flc ''';'])              
                    elseif (regexp(var_name_new(1:3),'tur'))
                        eval(['ATT.' var_name_new '.sensor_model = ''' I.hcat_tur_type{j} ' turbidity sensor installed on ' def_sensor ''';'])
                        eval(['ATT.' var_name_new '.sensor_serial_number = ''' I.hcat_tur_sn{j} ''';'])
                        eval(['ATT.' var_name_new '.sensor_calibration_date = ''' caldatestr_tur ''';'])
                    end
                    
                    % Processing level
                    eval(['def_pl = ATT.' var_name_new '.Processing_level;']);
                    if inst_edt == 1
                        disp(' ')
                        disp([def_sensor ' S/N ' inst_sn ' : ' var_name_new ' : Processing level'])
                        disp(['default = ' def_pl])
                        ans_pl=input('Accept default?(y/n)        ','s');
                        while regexp(ans_pl,'n','ignorecase')
                            disp('Select processing level:')
                            for jjj = 1:length((ind_pl))
                                disp([num2str(jjj) ' = ' opt_pl{jjj}])
                            end
                            pick_pl=str2double(input('Select processing level:     ','s'));
                            if (pick_pl>0 && pick_pl<max(ind_pl))
                                ans_pl = 'y';
                                eval(['ATT.' var_name_new '.Processing_level = ''' opt_pl{pick_pl} ''';'])
                            end
                        end
                    end
                    
                    % QC indicator
                    eval(['def_qc = ATT.' var_name_new '.QC_indicator;']);
                    if inst_edt == 1
                        disp(' ')
                        disp([def_sensor ' S/N ' inst_sn ' : ' var_name_new ' : QC indicator'])
                        disp(['default = ' num2str(def_qc) ' ' opt_qc{def_qc+1}])
                        ans_qc=input('Accept default?(y/n)        ','s');
                        while regexp(ans_qc,'n','ignorecase')
                            disp('Select processing level:')
                            for jjj = 1:length((ind_qc))
                                disp([num2str(ind_qc(jjj)) ' = ' opt_qc{jjj}])
                            end
                            pick_qc=str2double(input('Select QC indicator:     ','s'));
                            if (pick_qc>=0 && pick_qc<(max(ind_qc)))
                                ans_qc = 'y';
                                eval(['ATT.' var_name_new '.QC_indicator = ' num2str(pick_qc) ';'])
                            end
                        end
                    end
                    
                    % Comment
                    eval(['def_cm = ATT.' var_name_new '.comment;']);
                    if inst_edt == 1
                        disp(' ')
                        disp([def_sensor ' S/N ' inst_sn ' : ' var_name_new ' : comment'])
                        disp(['default = ' def_cm])
                        ans_cm=input('Accept default?(y/n)        ','s');
                        if regexp(ans_cm,'n','ignorecase')
                            pick_cm = input('Enter comment:     ','s');
                            eval(['ATT.' var_name_new '.comment = ''' pick_cm ''';'])
                        end
                    end
                    
                end
                
                eval(['no_fields = numel(fieldnames(ATT.' var_name_new '));'])
                eval(['field_list = fieldnames(ATT.' var_name_new ');'])
                for jjj = 1:no_fields
                    eval(['ncwriteatt(ncf,''' var_name_new ''',''' field_list{jjj} ''',ATT.' var_name_new '.' field_list{jjj} ');'])
                end
                % Exception: different units for turbidity sensor -
                % Seapoint uses FTU (default in ATT array), HCO uses NTU
                if regexp(var_name_new,'turbidity')
                    if regexp(var_name_new,'tur_V')
                        ok=0;
                    else
                        if regexp(I.hcat_tur_type{j},'Seapoint','ignorecase')
                            ok=1; % All good
                        elseif regexp(I.hcat_tur_type{j},'WetLabs HCO','ignorecase')
                            ncwriteatt(ncf,'turbidity','units',ATT.turbidity_HCO.units);
                        else
                            disp('PAR sensor model not recognised')
                            break
                        end
                    end
                end
                
                clear jjj
                clear var_data var_name_new no_fields field_list...
                    caldate* def_sensor ans_pl pick_pl ans_qc pick_qc...
                    ans_cm pick_cm
            end
        end
        clear jj var_l*
        disp('********************')
   
                
    %%    
    elseif regexp(inst_type,'SBE37')
        
        % Get position of instrument in info file
        for k=1:length(I.sbe37_sn); sbe37_sn_num(k)=str2double(I.sbe37_sn{k}); end
        j = find(sbe37_sn_num==str2double(inst_sn));
        
        % Load variable attrbutes
        ATT = load([I.d_matlab '\KROP_data_att_avg.mat']);
        
        % List all possible variables
        var_list = {'interp_time','scan','nominal_depth','pres','depth',...
            'temp','cond','sal','sigmatheta'};
        % List name of export variables
        var_list_new = {'time','scan','nominal_depth','pressure','depth',...
            'temperature','conductivity','salinity','density'};
        
        for jj = 1:length(var_list)
            if isfield(data_AVG,var_list{jj})
                var_name = char(var_list{jj});
                if regexp(var_name(1:2),'mt')
                    % Convert matlab time to epoch time
                    var_data = (86400 * (data_AVG.mtime - datenum('01-Jan-1970 00:00:00')));
                else
                    eval(['var_data = data_AVG.' var_list{jj} ';'])
                end
                clear var_name
                var_name_new = var_list_new{jj};
                nccreate(ncf,var_name_new,'DataType','double','Dimensions',{'var1',length(var_data),'var2',1},'FillValue',NaN)
                ncwrite(ncf,var_name_new,var_data)
                
                % Get calibration dates from info file
                % To start with add attribute as given in info file, then
                % try formatting into standard datetime format
                % (YYYY-MM-DDTHH:MM:SSZ) using try/catch in case the entries
                % are not a recognisable date format (could be 'unknown'
                % if no cal date available
                caldatestr = I.sbe37_cal_date{j};
                try caldate = datenum(I.sbe37_cal_date{j});
                    caldatestr = datestr(caldate,'yyyy-mm-ddTHH:MM:SSZ');
                catch
                end
                
                if jj>3 % First three variables are time, scan and nominal depth --> no need for extra attritbutes
                    
                    def_sensor = 'SBE37';
                    if (regexp(var_name_new(1:3),'pre| dep| tem| con| sal| den'))
                        eval(['ATT.' var_name_new '.sensor_model = ''' def_sensor ''';'])
                        eval(['ATT.' var_name_new '.sensor_serial_number = ''' inst_sn ''';'])
                        eval(['ATT.' var_name_new '.sensor_calibration_date = ''' caldatestr ''';'])
                    end
                    
                    % Processing level
                    eval(['def_pl = ATT.' var_name_new '.Processing_level;']);
                    if inst_edt == 1
                        disp(' ')
                        disp([def_sensor ' S/N ' inst_sn ' : ' var_name_new ' : Processing level'])
                        disp(['default = ' def_pl])
                        ans_pl=input('Accept default?(y/n)        ','s');
                        while regexp(ans_pl,'n','ignorecase')
                            disp('Select processing level:')
                            for jjj = 1:length((ind_pl))
                                disp([num2str(jjj) ' = ' opt_pl{jjj}])
                            end
                            pick_pl=str2double(input('Select processing level:     ','s'));
                            if (pick_pl>0 && pick_pl<max(ind_pl))
                                ans_pl = 'y';
                                eval(['ATT.' var_name_new '.Processing_level = ''' opt_pl{pick_pl} ''';'])
                            end
                        end
                    end
                    
                    % QC indicator
                    eval(['def_qc = ATT.' var_name_new '.QC_indicator;']);
                    if inst_edt == 1
                        disp(' ')
                        disp([def_sensor ' S/N ' inst_sn ' : ' var_name_new ' : QC indicator'])
                        disp(['default = ' num2str(def_qc) ' ' opt_qc{def_qc+1}])
                        ans_qc=input('Accept default?(y/n)        ','s');
                        while regexp(ans_qc,'n','ignorecase')
                            disp('Select processing level:')
                            for jjj = 1:length((ind_qc))
                                disp([num2str(ind_qc(jjj)) ' = ' opt_qc{jjj}])
                            end
                            pick_qc=str2double(input('Select QC indicator:     ','s'));
                            if (pick_qc>=0 && pick_qc<(max(ind_qc)))
                                ans_qc = 'y';
                                eval(['ATT.' var_name_new '.QC_indicator = ' num2str(pick_qc) ';'])
                            end
                        end
                    end
                    
                    % Comment
                    eval(['def_cm = ATT.' var_name_new '.comment;']);
                    if inst_edt == 1
                        disp(' ')
                        disp([def_sensor ' S/N ' inst_sn ' : ' var_name_new ' : comment'])
                        disp(['default = ' def_cm])
                        ans_cm=input('Accept default?(y/n)        ','s');
                        if regexp(ans_cm,'n','ignorecase')
                            pick_cm = input('Enter comment:     ','s');
                            eval(['ATT.' var_name_new '.comment = ''' pick_cm ''';'])
                        end
                    end
                    
                end
                
                % Write variable attributes
                eval(['no_fields = numel(fieldnames(ATT.' var_name_new '));'])
                eval(['field_list = fieldnames(ATT.' var_name_new ');'])
                for jjj = 1:no_fields
                    eval(['ncwriteatt(ncf,''' var_name_new ''',''' field_list{jjj} ''',ATT.' var_name_new '.' field_list{jjj} ');'])
                end
                clear jjj
                clear var_data var_name_new no_fields field_list...
                    caldate* def_sensor ans_pl pick_pl ans_qc pick_qc...
                    ans_cm pick_cm
            end
        end
        clear jj var_l*
        disp('********************')
        
        
    %%    
    elseif regexp(inst_type,'SBE56')
        
        % Get position of instrument in info file
        for k=1:length(I.sbe56_sn); sbe56_sn_num(k)=str2double(I.sbe56_sn{k}); end
        j = find(sbe56_sn_num==str2double(inst_sn));
        
        % Load variable attrbutes
        ATT = load([I.d_matlab '\KROP_data_att_avg.mat']);
        
        % List all possible variables
        var_list = {'interp_time','nominal_depth','temp'};
        % List name of export variables
        var_list_new = {'time','nominal_depth','temperature'};
        
        for jj = 1:length(var_list)
            if isfield(data_AVG,var_list{jj})
                var_name = char(var_list{jj});
                if regexp(var_name(1:2),'mt')
                    % Convert matlab time to epoch time
                    var_data = (86400 * (data_AVG.mtime - datenum('01-Jan-1970 00:00:00')));
                else
                    eval(['var_data = data_AVG.' var_list{jj} ';'])
                end
                clear var_name
                var_name_new = var_list_new{jj};
                nccreate(ncf,var_name_new,'DataType','double','Dimensions',{'var1',length(var_data),'var2',1},'FillValue',NaN)
                ncwrite(ncf,var_name_new,var_data)
                
                % Get calibration dates from info file
                % To start with add attribute as given in info file, then
                % try formatting into standard datetime format
                % (YYYY-MM-DDTHH:MM:SSZ) using try/catch in case the entries
                % are not a recognisable date format (could be 'unknown'
                % if no cal date available
                caldatestr = I.sbe56_cal_date{j};
                try caldate = datenum(I.sbe56_cal_date{j});
                    caldatestr = datestr(caldate,'yyyy-mm-ddTHH:MM:SSZ');
                catch
                end
                
                if jj==3 % temp
                    
                    def_sensor = 'SBE56';
                    eval(['ATT.' var_name_new '.sensor_model = ''' def_sensor ''';'])
                    eval(['ATT.' var_name_new '.sensor_serial_number = ''' inst_sn ''';'])
                    eval(['ATT.' var_name_new '.sensor_calibration_date = ''' caldatestr ''';'])
                    
                    % Processing level
                    eval(['def_pl = ATT.' var_name_new '.Processing_level;']);
                    if inst_edt == 1
                        disp(' ')
                        disp([def_sensor ' S/N ' inst_sn ' : ' var_name_new ' : Processing level'])
                        disp(['default = ' def_pl])
                        ans_pl=input('Accept default?(y/n)        ','s');
                        while regexp(ans_pl,'n','ignorecase')
                            disp('Select processing level:')
                            for jjj = 1:length((ind_pl))
                                disp([num2str(jjj) ' = ' opt_pl{jjj}])
                            end
                            pick_pl=str2double(input('Select processing level:     ','s'));
                            if (pick_pl>0 && pick_pl<max(ind_pl))
                                ans_pl = 'y';
                                eval(['ATT.' var_name_new '.Processing_level = ''' opt_pl{pick_pl} ''';'])
                            end
                        end
                    end
                    
                    % QC indicator
                    eval(['def_qc = ATT.' var_name_new '.QC_indicator;']);
                    if inst_edt == 1
                        disp(' ')
                        disp([def_sensor ' S/N ' inst_sn ' : ' var_name_new ' : QC indicator'])
                        disp(['default = ' num2str(def_qc) ' ' opt_qc{def_qc+1}])
                        ans_qc=input('Accept default?(y/n)        ','s');
                        while regexp(ans_qc,'n','ignorecase')
                            disp('Select processing level:')
                            for jjj = 1:length((ind_qc))
                                disp([num2str(ind_qc(jjj)) ' = ' opt_qc{jjj}])
                            end
                            pick_qc=str2double(input('Select QC indicator:     ','s'));
                            if (pick_qc>=0 && pick_qc<(max(ind_qc)))
                                ans_qc = 'y';
                                eval(['ATT.' var_name_new '.QC_indicator = ' num2str(pick_qc) ';'])
                            end
                        end
                    end
                    
                    % Comment
                    eval(['def_cm = ATT.' var_name_new '.comment;']);
                    if inst_edt == 1
                        disp(' ')
                        disp([def_sensor ' S/N ' inst_sn ' : ' var_name_new ' : comment'])
                        disp(['default = ' def_cm])
                        ans_cm=input('Accept default?(y/n)        ','s');
                        if regexp(ans_cm,'n','ignorecase')
                            pick_cm = input('Enter comment:     ','s');
                            eval(['ATT.' var_name_new '.comment = ''' pick_cm ''';'])
                        end
                    end
                    
                end
                
                % Write variable attributes
                eval(['no_fields = numel(fieldnames(ATT.' var_name_new '));'])
                eval(['field_list = fieldnames(ATT.' var_name_new ');'])
                for jjj = 1:no_fields
                    eval(['ncwriteatt(ncf,''' var_name_new ''',''' field_list{jjj} ''',ATT.' var_name_new '.' field_list{jjj} ');'])
                end
                clear jjj
                clear var_data var_name_new no_fields field_list
            end
        end
        clear jj var_l*
        disp('********************')
        
        
    %%
    elseif regexp(inst_type,'ML')
        
        % Get position of instrument in info file
        for k=1:length(I.ml_sn); ml_sn_num(k)=str2double(I.ml_sn{k}); end
        j = find(ml_sn_num==str2double(inst_sn));
        
        % Load variable attrbutes
        ATT = load([I.d_matlab '\KROP_data_att_avg.mat']);
        
        % List all possible variables
        var_list = {'interp_time','nominal_depth','temp'};
        % List name of export variables
        var_list_new = {'time','nominal_depth','temperature'};
        
        % Edit processing level for offsets
        if ~isnan(I.off_ml_t(j)) % an offset has been applied
            ATT.temperature.QC_indicator = 'Post-recovery calibrations have been applied';
        end
        
        for jj = 1:length(var_list)
            if isfield(data_AVG,var_list{jj})
                var_name = char(var_list{jj});
                if regexp(var_name(1:2),'mt')
                    % Convert matlab time to epoch time
                    var_data = (86400 * (data_AVG.mtime - datenum('01-Jan-1970 00:00:00')));
                else
                    eval(['var_data = data_AVG.' var_list{jj} ';'])
                end
                clear var_name
                var_name_new = var_list_new{jj};
                nccreate(ncf,var_name_new,'DataType','double','Dimensions',{'var1',length(var_data),'var2',1},'FillValue',NaN)
                ncwrite(ncf,var_name_new,var_data)
                
                % Get calibration dates from info file
                % To start with add attribute as given in info file, then
                % try formatting into standard datetime format
                % (YYYY-MM-DDTHH:MM:SSZ) using try/catch in case the entries
                % are not a recognisable date format (could be 'unknown'
                % if no cal date available)
                caldatestr = I.ml_cal_date{j};
                try caldate = datenum(I.ml_cal_date{j});
                    caldatestr = datestr(caldate,'yyyy-mm-ddTHH:MM:SSZ');
                catch
                end
                
                if jj==3 % temp
                    
                    def_sensor = 'Vemco minilog';
                    eval(['ATT.' var_name_new '.sensor_model = ''' def_sensor ''';'])
                    eval(['ATT.' var_name_new '.sensor_serial_number = ''' inst_sn ''';'])
                    eval(['ATT.' var_name_new '.sensor_calibration_date = ''' caldatestr ''';'])
                    
                    % Processing level
                    eval(['def_pl = ATT.' var_name_new '.Processing_level;']);
                    if inst_edt == 1
                        disp(' ')
                        disp([def_sensor ' S/N ' inst_sn ' : ' var_name_new ' : Processing level'])
                        disp(['default = ' def_pl])
                        ans_pl=input('Accept default?(y/n)        ','s');
                        while regexp(ans_pl,'n','ignorecase')
                            disp('Select processing level:')
                            for jjj = 1:length((ind_pl))
                                disp([num2str(jjj) ' = ' opt_pl{jjj}])
                            end
                            pick_pl=str2double(input('Select processing level:     ','s'));
                            if (pick_pl>0 && pick_pl<max(ind_pl))
                                ans_pl = 'y';
                                eval(['ATT.' var_name_new '.Processing_level = ''' opt_pl{pick_pl} ''';'])
                            end
                        end
                    end
                    
                    % QC indicator
                    eval(['def_qc = ATT.' var_name_new '.QC_indicator;']);
                    if inst_edt == 1
                        disp(' ')
                        disp([def_sensor ' S/N ' inst_sn ' : ' var_name_new ' : QC indicator'])
                        disp(['default = ' num2str(def_qc) ' ' opt_qc{def_qc+1}]) % list numbering starts at 0!
                        ans_qc=input('Accept default?(y/n)        ','s');
                        while regexp(ans_qc,'n','ignorecase')
                            disp('Select processing level:')
                            for jjj = 1:length((ind_qc))
                                disp([num2str(ind_qc(jjj)) ' = ' opt_qc{jjj}])
                            end
                            pick_qc=str2double(input('Select QC indicator:     ','s'));
                            if (pick_qc>=0 && pick_qc<(max(ind_qc)))
                                ans_qc = 'y';
                                eval(['ATT.' var_name_new '.QC_indicator = ' num2str(pick_qc) ';'])
                            end
                        end
                    end
                    
                    % Comment
                    eval(['def_cm = ATT.' var_name_new '.comment;']);
                    if inst_edt == 1
                        disp(' ')
                        disp([def_sensor ' S/N ' inst_sn ' : ' var_name_new ' : comment'])
                        disp(['default = ' def_cm])
                        ans_cm=input('Accept default?(y/n)        ','s');
                        if regexp(ans_cm,'n','ignorecase')
                            pick_cm = input('Enter comment:     ','s');
                            eval(['ATT.' var_name_new '.comment = ''' pick_cm ''';'])
                        end
                    end
                    
                end
                
                % Write variable attributes
                eval(['no_fields = numel(fieldnames(ATT.' var_name_new '));'])
                eval(['field_list = fieldnames(ATT.' var_name_new ');'])
                for jjj = 1:no_fields
                    eval(['ncwriteatt(ncf,''' var_name_new ''',''' field_list{jjj} ''',ATT.' var_name_new '.' field_list{jjj} ');'])
                end
                clear jjj
                clear var_data var_name_new no_fields field_list
            end
        end
        clear jj var_l*
        disp('********************')
        
        
    %%    
    elseif regexp(inst_type,'ESM1')
        
        % Get position of instrument in info file
        for k=1:length(I.esm1_sn); esm1_sn_num(k)=str2double(I.esm1_sn{k}); end
        j = find(esm1_sn_num==str2double(inst_sn));
        
        % Load variable attrbutes
        ATT = load([I.d_matlab '\KROP_data_att_avg.mat']);
        
        % List all possible variables
        var_list = {'interp_time','nominal_depth','flc_eng','flc'};
        % List name of export variables
        var_list_new = {'time','nominal_depth','fluo_eng','fluo'};
        
        for jj = 1:length(var_list)
            if isfield(data_AVG,var_list{jj})
                var_name = char(var_list{jj});
                if regexp(var_name(1:2),'mt')
                    % Convert matlab time to epoch time
                    var_data = (86400 * (data_AVG.mtime - datenum('01-Jan-1970 00:00:00')));
                else
                    eval(['var_data = data_AVG.' var_list{jj} ';'])
                end
                clear var_name
                var_name_new = var_list_new{jj};
                nccreate(ncf,var_name_new,'DataType','double','Dimensions',{'var1',length(var_data),'var2',1},'FillValue',NaN)
                ncwrite(ncf,var_name_new,var_data)
                
                % Get calibration dates from info file
                % To start with add attribute as given in info file, then
                % try formatting into standard datetime format
                % (YYYY-MM-DDTHH:MM:SSZ) using try/catch in case the entries
                % are not a recognisable date format (could be 'unknown'
                % if no cal date available)
                caldatestr = I.esm1_flc_cal_date{j};
                try caldate = datenum(I.esm1_flc_cal_date{j});
                    caldatestr = datestr(caldate,'yyyy-mm-ddTHH:MM:SSZ');
                catch
                end
                
                if jj>=3 % flc_eng and flc
                    
                    def_sensor = [I.esm1_flc_type{j} ' attached to ESM-1 logger'];
                    eval(['ATT.' var_name_new '.sensor_model = ''' def_sensor ''';'])
                    eval(['ATT.' var_name_new '.sensor_serial_number = ''' I.esm1_flc_sn{j} ''';'])
                    eval(['ATT.' var_name_new '.sensor_calibration_date = ''' caldatestr ''';'])
                    
                    % Processing level
                    eval(['def_pl = ATT.' var_name_new '.Processing_level;']);
                    if inst_edt == 1
                        disp(' ')
                        disp([def_sensor ' S/N ' inst_sn ' : ' var_name_new ' : Processing level'])
                        disp(['default = ' def_pl])
                        ans_pl=input('Accept default?(y/n)        ','s');
                        while regexp(ans_pl,'n','ignorecase')
                            disp('Select processing level:')
                            for jjj = 1:length((ind_pl))
                                disp([num2str(jjj) ' = ' opt_pl{jjj}])
                            end
                            pick_pl=str2double(input('Select processing level:     ','s'));
                            if (pick_pl>0 && pick_pl<max(ind_pl))
                                ans_pl = 'y';
                                eval(['ATT.' var_name_new '.Processing_level = ''' opt_pl{pick_pl} ''';'])
                            end
                        end
                    end
                    
                    % QC indicator
                    eval(['def_qc = ATT.' var_name_new '.QC_indicator;']);
                    if inst_edt == 1
                        disp(' ')
                        disp([def_sensor ' S/N ' inst_sn ' : ' var_name_new ' : QC indicator'])
                        disp(['default = ' num2str(def_qc) ' ' opt_qc{def_qc+1}]) % list numbering starts at 0!
                        ans_qc=input('Accept default?(y/n)        ','s');
                        while regexp(ans_qc,'n','ignorecase')
                            disp('Select processing level:')
                            for jjj = 1:length((ind_qc))
                                disp([num2str(ind_qc(jjj)) ' = ' opt_qc{jjj}])
                            end
                            pick_qc=str2double(input('Select QC indicator:     ','s'));
                            if (pick_qc>=0 && pick_qc<(max(ind_qc)))
                                ans_qc = 'y';
                                eval(['ATT.' var_name_new '.QC_indicator = ' num2str(pick_qc) ';'])
                            end
                        end
                    end
                    
                    % Comment
                    eval(['def_cm = ATT.' var_name_new '.comment;']);
                    if inst_edt == 1
                        disp(' ')
                        disp([def_sensor ' S/N ' inst_sn ' : ' var_name_new ' : comment'])
                        disp(['default = ' def_cm])
                        ans_cm=input('Accept default?(y/n)        ','s');
                        if regexp(ans_cm,'n','ignorecase')
                            pick_cm = input('Enter comment:     ','s');
                            eval(['ATT.' var_name_new '.comment = ''' pick_cm ''';'])
                        end
                    end
                    
                end
                
                % Write variable attributes
                eval(['no_fields = numel(fieldnames(ATT.' var_name_new '));'])
                eval(['field_list = fieldnames(ATT.' var_name_new ');'])
                for jjj = 1:no_fields
                    eval(['ncwriteatt(ncf,''' var_name_new ''',''' field_list{jjj} ''',ATT.' var_name_new '.' field_list{jjj} ');'])
                end
                clear jjj
                clear var_data var_name_new no_fields field_list
            end
        end
        clear jj var_l*
        disp('********************')
        
        
    end
    
    clear inst* ncf ATT data_AVG ga_* ans* def*
    
end


% %%
% % % % % To check nc file:
% ninfo=ncinfo(ncf);
% varinfo = ninfo.Variables;
% varnames = {varinfo.Name};
% for j=1:length(varnames)
%     eval(['NC.' varnames{(j)} '=ncread(ncf,''' varnames{(j)} ''');'])
% end