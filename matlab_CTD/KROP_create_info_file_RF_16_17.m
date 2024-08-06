% Script to generate info file for specific mooring

% Enter root directory (where all the mooring subfolders are located)
d_root = 'C:\MOORINGS\KROP\REPROCESSING_2018';

% Enter mooring metadata
mooring_id='RF_16_17';
start_date=datenum('27-Aug-2016 15:00:00');
end_date=datenum('12-Aug-2017 07:00:00');
moor_lat_deg = 80; moor_lat_min = 17.649;
moor_lon_deg = 22; moor_lon_min = 17.921;
mooring_depth = 237;

% Enter instruments details. Follow the same order for SNs, depths,
% offsets, etc

% SBE16plus
sbe16p_num      = 1; % number of sbe16 on mooring, 0 if none
sbe16p_sn       = {'6101'}; % if more than one use format {'1111' '1112'}
sbe16p_depth    = {'44'}; % if more than 1 use format {'20' '30'}
% Sensor details: 0 = not attached, 1 = attached. If more than one sbe16 on
% the mooring use format [1;1]
sbe16p_p = 1; % Pressure
sbe16p_t = 1; % Temperature
sbe16p_c = 1; % Conductivity
% Offsets determined after intercomparison casts. t = temperature, c =
% conductivity
off_sbe16p_t = 0;
off_sbe16p_c = 0;
% Cal dates and sensor details
sbe16p_p_cal_date = {'13-Jun-2012'};
sbe16p_t_cal_date = {'15-Jun-2012'};
sbe16p_c_cal_date = {'15-Jun-2012'}; % con file says 2015, that's a typo
% Other sensors
sbe16p_flc = 1; % Fluorescence
sbe16p_flc_sn = {'1443'};
sbe16p_flc_type = {'WetLabs WETstar'};
sbe16p_flc_cal_date = {'21-Jun-2012'};
sbe16p_par = 1; % PAR
sbe16p_par_sn = {'509'};
sbe16p_par_type = {'Satlantic'};
sbe16p_par_cal_date = {'25-Jun-2014'};
sbe16p_tur = 0; % Turbidity
sbe16p_tur_type = {' '};
sbe16p_tur_sn = {' '};
sbe16p_tur_cal_date = {' '};

% SBE37
sbe37_num      = 2; % number of sbe37 on mooring, 0 if none
sbe37_sn       = {'7248' '9114'}; % if more than one use format {'1111' '1112'}
sbe37_depth    = {'34' '224'}; % if more than 1 use format {'20' '30'}
% Pressure sensor: 0 = not attached, 1 = attached. If more than one sbe37 
% on the mooring use format [1;1]
sbe37_p = [0;1]; 
% Offsets determined after intercomparison casts. t = temperature, c =
% conductivity
off_sbe37_t = [0;0];
off_sbe37_c = [0;0];
sbe37_cal_date = {'29-Jul-2015' '26-Jun-2011'};

% SBE56
sbe56_num      = 9; % number of sbe56 on mooring, 0 if none
sbe56_sn       = {'2444' '2445' '2447' '2650' '2656' '2657' '2658' '2659' '2660'};
sbe56_depth    = {'34.1' '44.1' '54'   '65'   '86'   '110'  '144'  '174'  '224.1' };
sbe56_cal_date = {'15-Mar-13' '15-Mar-13' '15-Mar-13' '31-Jul-13' '31-Jul-13' '31-Jul-13' '31-Jul-13' '31-Jul-13' '31-Jul-13'};
% Note: removed S/N 2667 @ 34m as it was a duplicate , very high sampling rate
% Offsets determined after intercomparison casts. t = temperature, c =
% conductivity
off_sbe56_t = [0;0;0;0;0;0;0;0;0];

% Minilogs
ml_num      = 0; % number of minilogs on mooring, 0 if none
ml_sn       = NaN;
ml_depth    = NaN;

% NetCDF attributes
ga_inst = 'UiT University of Tromso, SAMS Scottish Association for Marine Science'; % Insitution
ga_proj = 'KROP'; % Project name(s)
ga_array = 'KROP'; % Mooring array
% Contributors list
ga_cont = 'Jorgen Berge; Finlo Cottier; John Beaton; Estelle Dumont; Daniel Vogedes';
% General comments (whole mooring)
ga_cmt = 'Data looking acceptable';

% Mooring user setup end

%% Prepare processing subdirectories
d_moor      = [d_root '\' mooring_id];
d_sbe16p	= [d_moor '\bin\sbe16p\2_converted'];
d_sbe37     = [d_moor '\bin\sbe37\2_converted'];
d_sbe56     = [d_moor '\bin\sbe56\2_converted'];
d_ml        = [d_moor '\bin\minilog\2_converted'];
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
 