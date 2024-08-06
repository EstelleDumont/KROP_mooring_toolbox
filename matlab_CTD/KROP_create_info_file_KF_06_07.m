% Script to generate info file for specific mooring

% Enter root directory (where all the mooring subfolders are located)
d_root = 'C:\MOORINGS\KROP\REPROCESSING_2018';

% Enter mooring metadata
mooring_id='KF_06_07';
start_date=datenum('06-Jun-2006 13:00:00');
end_date=datenum('25-Aug-2007 06:00:00');
moor_lat_deg = 79; moor_lat_min = 01.1979;
moor_lon_deg = 11; moor_lon_min = 46.4170;
mooring_depth = 209;

% Enter instruments details. Follow the same order for SNs, depths,
% offsets, etc

% SBE16plus
sbe16p_num      = 0; % number of sbe16 on mooring, 0 if none
sbe16p_sn       = {' '}; % if more than one use format {'1111' '1112'}
sbe16p_depth    = {' '}; % if more than 1 use format {'20' '30'}
% Sensor details: 0 = not attached, 1 = attached. If more than one sbe16 on
% the mooring use format [1;1]
sbe16p_p = []; % Pressure
sbe16p_t = []; % Temperature
sbe16p_c = []; % Conductivity
% Offsets determined after intercomparison casts. t = temperature, c =
% conductivity
off_sbe16p_t = []; % No intercomparison data
off_sbe16p_c = []; % No intercomparison data
% Cal dates
sbe16p_p_cal_date = {' '};
sbe16p_t_cal_date = {' '};
sbe16p_c_cal_date = {' '};
% Other sensors
sbe16p_flc = []; % Fluorescence
sbe16p_flc_sn = {' '};
sbe16p_flc_type = {' '};
sbe16p_flc_cal_date = {' '};
sbe16p_par = []; % PAR
sbe16p_par_sn = {' '};
sbe16p_par_type = {' '};
sbe16p_par_cal_date = {' '};
sbe16p_tur = [0]; % Turbidity
sbe16p_tur_type = {' '};
sbe16p_tur_sn = {' '};
sbe16p_tur_cal_date = {' '};

% ESM-1 + fluo
esm1_num            = 2;
esm1_sn             = {'2337' '2339'};
esm1_depth          = {  '15'   '15'};
esm1_flc            = [1;1]; % Fluorescence
esm1_flc_sn         = {'2354' '2355'};
esm1_flc_type       = {'Seapoint' 'Seapoint'};
esm1_flc_cal_date   = {'08-Feb-2001' '08-Feb-2001'};
esm1_flc_bits       = [16;16]; % logger I/O resolution in bits
esm1_flc_range      = [50;50]; % Options: 1X=150 ug/l, 3X = 50, 10X = 15, 30X=5

% SBE37
sbe37_num      = 2; % number of sbe37 on mooring, 0 if none
sbe37_sn       = {'2166'  '1124'}; % if more than one use format {'1111' '1112'}
sbe37_depth    = {'15.5'   '198'}; % if more than 1 use format {'20' '30'}
% Pressure sensor: 0 = not attached, 1 = attached. If more than one sbe37 
% on the mooring use format [1;1]
sbe37_p = [3;3]; % Bad pressure data on both
% Offsets determined after intercomparison casts. t = temperature, c =
% conductivity
off_sbe37_t = [NaN;NaN];  % No intercomparison data
off_sbe37_c = [NaN;NaN];  % No intercomparison data
% Cal
sbe37_cal_date = {'10-Apr-2002' '07-Jun-1999'};

% SBE56
sbe56_num      = 0; % number of sbe56 on mooring, 0 if none
sbe56_sn       = NaN;
sbe56_depth    = NaN;
% Offsets determined after intercomparison casts. t = temperature, c =
% conductivity
off_sbe56_t = NaN; % From intercomparisons 25 and 29/08/2016
% Cal
sbe56_cal_date = NaN;

% Minilogs
% No data file for 7335
ml_num      = 8; % number of minilogs on mooring, 0 if none
ml_sn       = {'4208' '1106' '7326' '7329' '7331' '7325'  '7337' '7340'};
ml_depth    = {  '13'   '26'   '36'   '57'   '78'  '100' '147.5'  '160'};
ml_p        = [0;0;0;0;0;1;0;0];
ml_cal_date = {'unknown' 'unknown' 'unknown' 'unknown' 'unknown' 'unknown' 'unknown' 'unknown'};
% Offsets from RF 07-08
off_ml_t = [NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN];


% NetCDF attributes
ga_inst = 'UiT University of Tromso, SAMS Scottish Association for Marine Science'; % Insitution
ga_proj = 'KROP'; % Project name(s)
ga_array = 'KROP'; % Mooring array
% Contributors list
ga_cont = 'Jorgen Berge; Finlo Cottier; John Beaton; Estelle Dumont; Colin Griffiths; Daniel Vogedes';
% General comments (whole mooring)
ga_cmt = 'Data looking acceptable';
% Optional: specific instruments comments
ga_cmt_2166 = 'Data looking acceptable. Bad pressure data, replaced by nominal pressure and depth, derived variables (salinity, sigma-theta) recalculated based on nominal pressure.';
ga_cmt_1124 = 'Data looking acceptable. Bad pressure data, replaced by nominal pressure and depth, derived variables (salinity, sigma-theta) recalculated based on nominal pressure.';
% ga_cmt_2337 = 'Data has been converted to ug/l using a cable gain of 3X as recorded in deployment notes, although the cable gain is unconfirmed and converted values could be wrong.';
% ga_cmt_2339 = 'Data has been converted to ug/l using a cable gain of 3X as recorded in deployment notes, although the cable gain is unconfirmed and converted values could be wrong.';

% Mooring user setup end

%% Prepare processing subdirectories
d_moor      = [d_root '\' mooring_id];
d_moor_bin  = [d_moor '\bin'];
d_sbe16p	= [d_moor_bin '\sbe16p\2_converted'];
d_esm1      = [d_moor '\bin\esm1\2_converted'];
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
if ~exist(d_nc,'dir'); mkdir(d_nc); end
if ~exist(d_plot,'dir'); mkdir(d_plot); end
if ~exist(d_plot_c,'dir'); mkdir(d_plot_c); end
if ~exist(d_plot_o,'dir'); mkdir(d_plot_o); end
if ~exist(d_plot_qc,'dir'); mkdir(d_plot_qc); end
if ~exist(d_plot_pro,'dir'); mkdir(d_plot_pro); end

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
 