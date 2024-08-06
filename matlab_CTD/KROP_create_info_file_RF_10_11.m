% Script to generate info file for specific mooring

% Enter root directory (where all the mooring subfolders are located)
d_root = 'C:\MOORINGS\KROP\REPROCESSING_2018';

% Enter mooring metadata
mooring_id='RF_10_11';
start_date=datenum('20-Sep-2010 23:00:00');
end_date=datenum('30-Aug-2011 22:00:00');
moor_lat_deg = 80; moor_lat_min = 17.223;
moor_lon_deg = 22; moor_lon_min = 15.455;
mooring_depth = 234;

% Enter instruments details. Follow the same order for SNs, depths,
% offsets, etc

% SBE16plus
sbe16p_num      = 1; % number of sbe16 on mooring, 0 if none
sbe16p_sn       = {'5181'}; % if more than one use format {'1111' '1112'}
sbe16p_depth    = {'42.5'}; % if more than 1 use format {'20' '30'}
% Sensor details: 0 = not attached, 1 = attached. If more than one sbe16 on
% the mooring use format [1;1]
sbe16p_p = [1]; % Pressure - ind 2 = faulty sensor (part-way through deployment)
sbe16p_t = [1]; % Temperature
sbe16p_c = [1]; % Conductivity
% Offsets determined after intercomparison casts. t = temperature, c =
% conductivity
off_sbe16p_t = NaN; % no intercomparison data available
off_sbe16p_c = NaN; % no intercomparison data available
% Cal dates and sensor details
sbe16p_p_cal_date = {'22-May-2007'};
sbe16p_t_cal_date = {'07-Jun-2007'};
sbe16p_c_cal_date = {'07-Jun-2007'};
% Other sensors
sbe16p_flc = [1]; % Fluorescence
sbe16p_flc_sn = {'2355'};
sbe16p_flc_type = {'Seapoint'};
sbe16p_flc_cal_date = {'08-Feb-2001'};
sbe16p_par = [1]; % PAR
sbe16p_par_sn = {'70192'};
sbe16p_par_type = {'Biospherical'};
sbe16p_par_cal_date = {'21-Jul-2008'};
sbe16p_tur = [0]; % Turbidity
sbe16p_tur_type = {' '};
sbe16p_tur_sn = {' '};
sbe16p_tur_cal_date = {' '};

% SBE37
sbe37_num      = 2; % number of sbe37 on mooring, 0 if none
sbe37_sn       = {'4608' '4610'}; % if more than one use format {'1111' '1112'}
sbe37_depth    = {'32.5'  '222'}; % if more than 1 use format {'20' '30'}
% Pressure sensor: 0 = not attached, 1 = attached. If more than one sbe37 
% on the mooring use format [1;1]
sbe37_p = [1;1]; 
% Offsets determined after intercomparison cast. t = temperature, c =
% conductivity 
off_sbe37_t = [NaN;NaN]; % no intercomparison data available]; 
off_sbe37_c = [NaN;NaN]; % no intercomparison data available]; 
sbe37_cal_date = {'01-Feb-2006' '01-Feb-2006'}; % from JB's spreadsheet

% SBE56
sbe56_num      = 0; % number of minilogs on mooring, 0 if none
sbe56_sn       = NaN;
sbe56_depth    = NaN;
off_sbe56_t    =[];

% Minilogs
% 1066 and 1600 are  duplicates of SBE and haven't been included in dataset.
ml_num      = 7; % number of sbe56 on mooring, 0 if none
ml_sn       = {'1068' '1443' '1444' '1445'  '1446'  '1448'  '1692'};
ml_depth    = {'52.5' '62.5' '72.5' '82.5' '112.5' '148.5' '188.5'};
ml_cal_date = {'unknown' 'unknown' 'unknown' 'unknown' 'unknown' 'unknown' 'unknown'};
% Offsets determined by CRG (cal baths + temp adjustment to known in-situ minima)
off_ml_t = [0.055; 0.07; 0.03; 0.12; 0.07; 0.05; -0.44];

% NetCDF attributes
ga_inst = 'UiT University of Tromso, SAMS Scottish Association for Marine Science'; % Insitution
ga_proj = 'KROP'; % Project name(s)
ga_array = 'KROP'; % Mooring array
% Contributors list
ga_cont = 'Jorgen Berge; Finlo Cottier; John Beaton; Estelle Dumont; Colin Griffiths; Daniel Vogedes';
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

% Calculate lat and lon
mooring_lat = moor_lat_deg + moor_lat_min/60;
mooring_lon = moor_lon_deg + moor_lon_min/60;
clear moor_lat_deg moor_lat_min moor_lon_deg moor_lon_min

% Extract deployment year
start_date_vec = datevec(start_date);
start_year = start_date_vec(1);
clear start_date_vec

% Save file in matlab folder
 save([d_mat '\' mooring_id '_info']);
 