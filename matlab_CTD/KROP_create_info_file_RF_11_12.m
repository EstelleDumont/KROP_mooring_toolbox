% Script to generate info file for specific mooring

% Enter root directory (where all the mooring subfolders are located)
d_root = 'C:\MOORINGS\KROP\REPROCESSING_2018';

% Enter mooring metadata
mooring_id='RF_11_12';
start_date=datenum('01-Sep-2011 04:00:00');
end_date=datenum('28-Sep-2012 03:00:00');
moor_lat_deg = 80; moor_lat_min = 18.011;
moor_lon_deg = 22; moor_lon_min = 17.663;
mooring_depth = 231;

% Enter instruments details. Follow the same order for SNs, depths,
% offsets, etc

% SBE16plus
sbe16p_num      = 1; % number of sbe16 on mooring, 0 if none
sbe16p_sn       = {'6066'}; % if more than one use format {'1111' '1112'}
sbe16p_depth    = {'37'}; % if more than 1 use format {'20' '30'}
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
sbe16p_p_cal_date = {'19-Jun-2008'};
sbe16p_t_cal_date = {'19-Jun-2008'};
sbe16p_c_cal_date = {'19-Jun-2008'};
% Other sensors
sbe16p_flc = [1]; % Fluorescence
sbe16p_flc_sn = {'3129'};
sbe16p_flc_type = {'Seapoint'};
sbe16p_flc_cal_date = {'17-Apr-2009'};
sbe16p_par = [1]; % PAR
sbe16p_par_sn = {'70254'};
sbe16p_par_type = {'Biospherical'};
sbe16p_par_cal_date = {'19-Oct-2009'};
sbe16p_tur = [0]; % Turbidity
sbe16p_tur_type = {' '};
sbe16p_tur_sn = {' '};
sbe16p_tur_cal_date = {' '};

% SBE37
sbe37_num      = 1; % number of sbe37 on mooring, 0 if none
sbe37_sn       = {'5511'}; % if more than one use format {'1111' '1112'}
sbe37_depth    = { '218'}; % if more than 1 use format {'20' '30'}
% Pressure sensor: 0 = not attached, 1 = attached. If more than one sbe37 
% on the mooring use format [1;1]
sbe37_p = [1;1]; 
% Offsets determined after intercomparison cast. t = temperature, c =
% conductivity 
off_sbe37_t = [0]; % 2010 intercomparison
off_sbe37_c = [0]; % 2010 intercomparison
sbe37_cal_date = {'01-Aug-2007'}; % From JB's table

% SBE56
sbe56_num      = 0; % number of minilogs on mooring, 0 if none
sbe56_sn       = NaN;
sbe56_depth    = NaN;
off_sbe56_t    =[];

% Minilogs
% Note: M/L 1621 is duplicate of sbe16+, removed from dataset
ml_num      = 7; 
ml_sn       = {'1613' '1626' '1627' '1630' '1684' '1685' '1690'};
ml_depth    = {  '27'   '47'   '57'   '77'  '113'  '146'  '186'};
ml_cal_date = {'unknown' 'unknown' 'unknown' 'unknown' 'unknown' 'unknown' 'unknown'};
% Offsets determined by CRG (cal baths + temp adjustment to known in-situ minima)
off_ml_t = [0.06;0.07;0.09;0.01;-0.46;-0.41;-0.38];

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
 