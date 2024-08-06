% Script to generate info file for specific mooring
% Corrected 23-Jun-20 (error in final depths on original design sheet)

% Enter root directory (where all the mooring subfolders are located)
d_root = 'C:\MOORINGS\KROP\REPROCESSING_2018';

% Enter mooring metadata
mooring_id='KF_20_21';
start_date=datenum('12-Sep-2020 16:00:00');
end_date=datenum('22-Aug-2021 08:00:00');
moor_lat_deg = 78; moor_lat_min = 57.570;
moor_lon_deg = 11; moor_lon_min = 49.194;
mooring_depth = 217;

% Enter instruments details. Follow the same order for SNs, depths,
% offsets, etc

% SBE16plus
sbe16p_num      = 0; % number of sbe16 on mooring, 0 if none
sbe16p_sn       = {''}; % if more than one use format {'1111' '1112'}
sbe16p_depth    = {''}; % if more than 1 use format {'20' '30'}
% Sensor details: 0 = not attached, 1 = attached. If more than one sbe16 on
% the mooring use format [1;1]
sbe16p_p = 0; % Pressure
sbe16p_t = 0; % Temperature
sbe16p_c = 0; % Conductivity
% Offsets determined after intercomparison casts. t = temperature, c =
% conductivity
off_sbe16p_t = NaN; 
off_sbe16p_c = NaN; 
% Cal dates
sbe16p_p_cal_date = {''};
sbe16p_t_cal_date = {''};
sbe16p_c_cal_date = {''};
% Other sensors
sbe16p_flc = 0; % Fluorescence
sbe16p_flc_sn = {''};
sbe16p_flc_type = {''};
sbe16p_flc_cal_date = {''};
sbe16p_par = 0; % PAR
sbe16p_par_sn = {''};
sbe16p_par_type = {''};
sbe16p_par_cal_date = {''};
sbe16p_tur = 0; % Turbidity
sbe16p_tur_type = {''};
sbe16p_tur_sn = {''};
sbe16p_tur_cal_date = {''};

% SBE19plus 
sbe19p_num      = 1; % number of sbe16 on mooring, 0 if none
sbe19p_sn       = {'6824'}; % if more than one use format {'1111' '1112'}
sbe19p_depth    = {'30'}; % if more than 1 use format {'20' '30'}
% Sensor details: 0 = not attached, 1 = attached. If more than one sbe16 on
% the mooring use format [1;1]
sbe19p_p = 1; % Pressure
sbe19p_t = 1; % Temperature
sbe19p_c = 1; % Conductivity
% Offsets determined after intercomparison casts. t = temperature, c =
% conductivity
off_sbe19p_t = 0; % Intercomparison Aug 2021
off_sbe19p_c = -0.05; % Intercomparison Aug 2021
% Cal dates
sbe19p_p_cal_date = {'29-Jun-2017'};
sbe19p_t_cal_date = {'05-Jul-2017'};
sbe19p_c_cal_date = {'05-Jul-2017'};
% Other sensors
sbe19p_flc = 1; % Fluorescence
sbe19p_flc_sn = {'1630'};
sbe19p_flc_type = {'WetLabs WETStar'};
sbe19p_flc_cal_date = {'21-Dec-2018'};
sbe19p_par = 1; % PAR
sbe19p_par_sn = {'510'};
sbe19p_par_type = {'Satlantic'};
sbe19p_par_cal_date = {'25-Jun-2014'};
sbe19p_tur = 0; % Turbidity
sbe19p_tur_type = {''};
sbe19p_tur_sn = {''};
sbe19p_tur_cal_date = {''};

% Hydrocat
hcat_num      = 1; % number of HydroCATs on mooring, 0 if none
hcat_sn       = {'30236'}; % if more than one use format {'1111' '1112'}
hcat_depth    = {'29'}; % if more than 1 use format {'20' '30'}
% Sensor details: 0 = not attached, 1 = attached. If more than one sbe16 on
% the mooring use format [1;1]
hcat_p = 1; % Pressure
hcat_t = 1; % Temperature
hcat_c = 1; % Conductivity
% Offsets determined after intercomparison casts. t = temperature, c =
% conductivity
off_hcat_t = NaN; % 2021 intercomparison dat not usable (sampling interval too low)
off_hcat_c = NaN; % 2021 intercomparison dat not usable (sampling interval too low)
% Cal dates
hcat_p_cal_date = {'31-Oct-2017'};
hcat_t_cal_date = {'03-Nov-2017'};
hcat_c_cal_date = {'03-Nov-2017'};
% Other sensors
hcat_oxy = 1; % Dissolved oxygen
hcat_oxy_sn = {'1781'};
hcat_oxy_type = {'SBE63'};
hcat_oxy_cal_date = {'04-Oct-2017'};
hcat_ph = 1; % pH
hcat_ph_sn = {'114'};
hcat_ph_type = {'HydroCAT-pH'};
hcat_ph_cal_date = {'06-Nov-2017'};
hcat_flc = 1; % Fluorescence
hcat_flc_sn = {'108'};
hcat_flc_type = {'WetLabs HCO'};
hcat_flc_cal_date = {'12-Oct-2017'};
hcat_tur = 1; % Turbidity
hcat_tur_type = {'WetLabs HCO'};
hcat_tur_sn = {'108'};
hcat_tur_cal_date = {'12-Oct-2017'};

% ESM-1 + fluo
esm1_num            = 0;
esm1_sn             = {''};
esm1_depth          = {''};
esm1_flc            = ''; % Fluorescence
esm1_flc_sn         = {''};
esm1_flc_type       = {''};
esm1_flc_cal_date   = {''};
esm1_flc_bits       = ''; % logger I/O resolution in bits
esm1_flc_range      = ''; % Options: 1X=150 ug/l, 3X = 50, 10X = 15, 30X=5

% SBE37
sbe37_num      = 3; % number of sbe37 on mooring, 0 if none
sbe37_sn       = {'14867' '14868' '14866'}; % if more than one use format {'1111' '1112'}
sbe37_depth    = {   '35'   '101'   '204'}; % if more than 1 use format {'20' '30'}
% Pressure sensor: 0 = not attached, 1 = attached. If more than one sbe37 
% on the mooring use format [1;1]
sbe37_p = [0;0;0]; 
% Offsets determined after intercomparison casts. t = temperature, c =
% conductivity
off_sbe37_t = [0;0;0]; % Intercomparison Aug 2021
off_sbe37_c = [0;0;0]; % Intercomparison Aug 2021
% Cal
sbe37_cal_date = {'26-Jul-2016' '21-Jul-2016' '16-Jul-2016'};

% SBE56
sbe56_num      = 9; % number of sbe56 on mooring, 0 if none
sbe56_sn       = {'5215' '10012' '10060' '10055' '10059' '10061' '10062' '10066' '10067'};
sbe56_depth    = {'20'   '35.1'  '56'    '78'    '100.9' '114'   '144'   '174'   '203.9'};
% Offsets determined after intercomparison casts. t = temperature, c =
% conductivity
off_sbe56_t = [0;0;0;0;0;0;0;0;0]; % Intercomparison Aug 2021
% Cal
sbe56_cal_date = {'25-Jun-2015' '03-Oct-2019' '25-Sep-2019' '25-Sep-2019' '25-Sep-2019' '25-Sep-2019' '25-Sep-2019' '25-Sep-2019' '25-Sep-2019'};

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
% Optional: specific instruments comments
% e.g. ga_cmt_2166 = 'Data looking acceptable. Bad pressure data, replaced by nominal pressure and depth, derived variables (salinity, sigma-theta) recalculated based on nominal pressure.';
ga_cmt_30236 = 'Instrument stopped recording before mooring recovery (24th Feb 2021)';

% Mooring user setup end

%% Prepare processing subdirectories
d_moor      = [d_root '\' mooring_id];
d_matlab    = [d_root '\processing\matlab_CTD'];
d_moor_bin  = [d_moor '\bin'];
d_sbe16p	= [d_moor_bin '\sbe16p\2_converted'];
d_sbe19p	= [d_moor_bin '\sbe19p\2_converted'];
d_hcat      = [d_moor_bin '\hydrocat\2_converted'];
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
if ~exist(d_plot,'dir'); mkdir(d_plot); end
if ~exist(d_plot_c,'dir'); mkdir(d_plot_c); end
if ~exist(d_plot_o,'dir'); mkdir(d_plot_o); end
if ~exist(d_plot_qc,'dir'); mkdir(d_plot_qc); end
if ~exist(d_plot_pro,'dir'); mkdir(d_plot_pro); end
if ~exist(d_nc,'dir'); mkdir(d_nc); end

eval(['addpath ' d_mat]);
eval(['addpath ' d_root '\processing\matlab_CTD\seawater']);

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
 