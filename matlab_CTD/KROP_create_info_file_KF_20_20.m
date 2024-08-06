% Script to generate info file for specific mooring
% Corrected 23-Jun-20 (error in final depths on original design sheet)

% Enter root directory (where all the mooring subfolders are located)
d_root = 'C:\MOORINGS\KROP\REPROCESSING_2018';

% Enter mooring metadata
mooring_id='KF_20_20';
start_date=datenum('13-Jan-2020 16:00:00');
end_date=datenum('06-Sep-2020 18:00:00');
moor_lat_deg = 78; moor_lat_min = 57.594;
moor_lon_deg = 11; moor_lon_min = 49.229;
mooring_depth = 217;

% Enter instruments details. Follow the same order for SNs, depths,
% offsets, etc

% SBE16plus
sbe16p_num      = 1; % number of sbe16 on mooring, 0 if none
sbe16p_sn       = {'5181'}; % if more than one use format {'1111' '1112'}
sbe16p_depth    = {'27'}; % if more than 1 use format {'20' '30'}
% Sensor details: 0 = not attached, 1 = attached. If more than one sbe16 on
% the mooring use format [1;1]
sbe16p_p = 1; % Pressure
sbe16p_t = 1; % Temperature
sbe16p_c = 1; % Conductivity
% Offsets determined after intercomparison casts. t = temperature, c =
% conductivity
off_sbe16p_t = 0; % Intercomparison Sep 2020
off_sbe16p_c = 0; % Intercomparison Sep 2020
% Cal dates
sbe16p_p_cal_date = {'14-Dec-2018'};
sbe16p_t_cal_date = {'15-Jan-2019'};
sbe16p_c_cal_date = {'15-Jan-2019'};
% Other sensors
sbe16p_flc = 1; % Fluorescence
sbe16p_flc_sn = {'2354'};
sbe16p_flc_type = {'Seapoint'};
sbe16p_flc_cal_date = {'11-Jan-2019'};
sbe16p_par = 1; % PAR
sbe16p_par_sn = {'1031'};
sbe16p_par_type = {'Satlantic'};
sbe16p_par_cal_date = {'21-Dec-2018'};
sbe16p_tur = 1; % Turbidity
sbe16p_tur_type = {'Seapoint'};
sbe16p_tur_sn = {'12156'};
sbe16p_tur_cal_date = {'23-Dec-2009'};

% SBE37
sbe37_num      = 0; % number of sbe37 on mooring, 0 if none
sbe37_sn       = {''}; % if more than one use format {'1111' '1112'}
sbe37_depth    = {''}; % if more than 1 use format {'20' '30'}
% Pressure sensor: 0 = not attached, 1 = attached. If more than one sbe37 
% on the mooring use format [1;1]
sbe37_p = []; 
% Offsets determined after intercomparison casts. t = temperature, c =
% conductivity
off_sbe37_t = 0; 
off_sbe37_c = 0; 
% Cal
sbe37_cal_date = {''};

% SBE56
sbe56_num      = 9; % number of sbe56 on mooring, 0 if none
sbe56_sn       = {'10012' '10040' '10055' '10059' '10060' '10061' '10062' '10066' '10067'};
sbe56_depth    = {'20'    '28'    '36'    '81'   '106'    '131'   '156'   '181'   '206' };
% Offsets determined after intercomparison casts. t = temperature, c =
% conductivity
off_sbe56_t = [0;0;0;0;0;0;0;0;0]; %No intercomparison
% Cal
sbe56_cal_date = {'03-Oct-2019' '10-Oct-2019' '25-Sep-2019' '25-Sep-2019' '25-Sep-2019' '25-Sep-2019' '25-Sep-2019' '25-Sep-2019' '25-Sep-2019'};

% Minilogs
ml_num      = 0; % number of minilogs on mooring, 0 if none
ml_sn       = NaN;
ml_depth    = NaN;

% NetCDF attributes
ga_inst = 'UiT University of Tromso, SAMS Scottish Association for Marine Science'; % Insitution
ga_proj = 'KROP'; % Project name(s)
ga_array = 'KROP'; % Mooring array
% Contributors list
ga_cont = 'Jorgen Berge; Finlo Cottier; Estelle Dumont; Daniel Vogedes';
% General comments (whole mooring)
ga_cmt = 'Data looking acceptable';

% Mooring user setup end

%% Prepare processing subdirectories
d_moor      = [d_root '\' mooring_id];
d_moor_bin  = [d_moor '\bin'];
d_sbe16p	= [d_moor_bin '\sbe16p\2_converted'];
d_sbe37     = [d_moor_bin '\sbe37\2_converted'];
d_sbe56     = [d_moor_bin '\sbe56\2_converted'];
d_ml        = [d_moor_bin '\minilog\2_converted'];
d_mat       = [d_moor '\mat'];
d_csv       = [d_moor '\csv\CTD'];
d_plot      = [d_moor '\plots\CTD'];
d_plot_c    = [d_moor '\plots\CTD\1_crop'];
d_plot_o    = [d_moor '\plots\CTD\2_offsets'];
d_plot_qc   = [d_moor '\plots\CTD\3_qc'];
d_plot_pro  = [d_moor '\plots\CTD\4_pro'];
d_nc        = [d_moor '\nc'];

% warning('off','MATLAB:MKDIR:DirectoryExists');
if ~exist(d_mat,'dir'); mkdir(d_mat); end
if ~exist(d_csv,'dir'); mkdir(d_csv); end
if ~exist(d_plot,'dir'); mkdir(d_plot); end
if ~exist(d_plot_c,'dir'); mkdir(d_plot_c); end
if ~exist(d_plot_o,'dir'); mkdir(d_plot_o); end
if ~exist(d_plot_qc,'dir'); mkdir(d_plot_qc); end
if ~exist(d_plot_pro,'dir'); mkdir(d_plot_pro); end
if ~exist(d_nc,'dir'); mkdir(d_nc); end

eval(['addpath ' d_mat]);

% Calcylate lat and lon
mooring_lat = moor_lat_deg + moor_lat_min/60;
mooring_lon = moor_lon_deg + moor_lon_min/60;
clear moor_lat_deg moor_lat_min moor_lon_deg moor_lon_min

% Extract deployment year
start_date_vec = datevec(start_date);
start_year = start_date_vec(1);
clear start_date_vec

% Save file in matlab folder
 save([d_mat '\' mooring_id '_info']);
 