% Script to generate info file for specific mooring

% Enter root directory (where all the mooring subfolders are located)
d_root = 'C:\MOORINGS\KROP\REPROCESSING_2018';

% Enter mooring metadata
mooring_id='KF_11_12';
start_date=datenum('27-Sep-2011 00:00:00');
end_date=datenum('08-Sep-2012 08:00:00');
moor_lat_deg = 78; moor_lat_min = 57.754;
moor_lon_deg = 11; moor_lon_min = 45.556;
mooring_depth = 251;

% Enter instruments details. Follow the same order for SNs, depths,
% offsets, etc

% SBE16plus
sbe16p_num      = 1; % number of sbe16 on mooring, 0 if none
sbe16p_sn       = {'5182'}; % if more than one use format {'1111' '1112'}
sbe16p_depth    = {'63.5'}; % if more than 1 use format {'20' '30'}
% Sensor details: 0 = not attached, 1 = attached. If more than one sbe16 on
% the mooring use format [1;1]
sbe16p_p = [1]; % Pressure
sbe16p_t = [1]; % Temperature
sbe16p_c = [1]; % Conductivity
% Offsets determined after intercomparison casts. t = temperature, c =
% conductivity
off_sbe16p_t = [NaN]; % No intercomparison data
off_sbe16p_c = [NaN]; % No intercomparison data
% Cal dates
sbe16p_p_cal_date = {'22-May-2007'};
sbe16p_t_cal_date = {'07-Jun-2007'};
sbe16p_c_cal_date = {'07-Jun-2007'};
% Other sensors
sbe16p_flc = [1]; % Fluorescence
sbe16p_flc_sn = {'2355'};
sbe16p_flc_type = {'Seapoint'};
sbe16p_flc_cal_date = {'08-Feb-2001'};
sbe16p_par = [1]; % PAR
sbe16p_par_sn = {'70190'};
sbe16p_par_type = {'Biospherical'};
sbe16p_par_cal_date = {'21-Jul-2008'};
sbe16p_tur = [0]; % Turbidity
sbe16p_tur_type = {' '};
sbe16p_tur_sn = {' '};
sbe16p_tur_cal_date = {' '};

% SBE37
sbe37_num      = 2; % number of sbe37 on mooring, 0 if none
sbe37_sn       = {'4608' '4610'}; % if more than one use format {'1111' '1112'}
sbe37_depth    = {'53.5'  '239'}; % if more than 1 use format {'20' '30'}
% Pressure sensor: 0 = not attached, 1 = attached. If more than one sbe37 
% on the mooring use format [1;1]
sbe37_p = [1;1]; 
% Offsets determined after intercomparison casts. t = temperature, c =
% conductivity
off_sbe37_t = [NaN;NaN]; % No intercomparison data
off_sbe37_c = [NaN;NaN]; % No intercomparison data
% Cal
sbe37_cal_date = {'19-Feb-2006' '19-Feb-2006'};

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
% ml_num      = 7; % number of minilogs on mooring, 0 if none
% ml_sn       = {'1068' '1443'  '1444'  '1445' '1446' '1448' '1692'};
% ml_depth    = {'73.5' '83.5' '108.5' '133.5'  '160'  '185'  '214'};
% ml_cal_date = {'unknown' 'unknown' 'unknown' 'unknown' 'unknown' 'unknown' 'unknown'};
% % Offsets from temp bath at SAMS Jun-13 > 1068 looking too warm
% off_ml_t = [1.12;0.02;-0.01;0.04;0.12;0;-0.56];
% % Offsets from RF offsets 2010-11 > 1068 looking too cold
% off_ml_t = [0.055;0.07;0.03;0.12;0.07;0.05;-0.44];
% Average ML offset RF 2011 + cal bath 2013
% off_ml_t = [0.59;0.05;0.01;0.08;0.10;0.02;-0.50];
% % Now 1068 too warm at the start, too cold at the end... Give up and remove
% % that one from dataset.
ml_num      = 6; % number of minilogs on mooring, 0 if none
ml_sn       = {'1443'  '1444'  '1445' '1446' '1448' '1692'};
ml_depth    = { '83.5' '108.5' '133.5'  '160'  '185'  '214'};
ml_cal_date = {'unknown' 'unknown' 'unknown' 'unknown' 'unknown' 'unknown'};
% Average ML offset 
off_ml_t = [0.05;0.01;0.08;0.10;0.02;-0.50];

% ESM
esm1_num=0;

% NetCDF attributes
ga_inst = 'UiT University of Tromso, SAMS Scottish Association for Marine Science'; % Insitution
ga_proj = 'KROP'; % Project name(s)
ga_array = 'KROP'; % Mooring array
% Contributors list
ga_cont = 'Jorgen Berge; Finlo Cottier; John Beaton; Estelle Dumont; Colin Griffiths; Daniel Vogedes';
% General comments (applicable to whole mooring / all instruments)
ga_cmt = 'Data looking acceptable';
% Optional: specific instruments comments
ga_cmt_4608 = 'Data looking acceptable. Instrument stopped recording part-way through deployment (probably due to battery).';
ga_cmt_4610 = 'Data looking acceptable. Instrument stopped recording part-way through deployment (probably due to battery).';

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
 