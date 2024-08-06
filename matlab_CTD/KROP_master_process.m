%% KROP master processing script
% Note: the info file must be created before running this script.
% ESDU, SAMS, Jan 19

clear; close all;

tic

disp(' ')
disp('***************************************************************')
disp('Welcome to the KROP CTD processing toolbox')
disp('Before starting the processing you need to have created')
disp('and edited the script ''KROP_create_info_file_MM_YY_YY.m''')
disp('(e.g. ''KROP_create_info_file_RF_11_12.m'').')
disp('If you haven''t hit Ctrl+C now and do that first.')
disp('Happy processing!')
disp('****************************************************************')
disp(' ')

%% 0 - Get processor name (for log
processor_id=input('Who''s processing the data?      ','s');

%% 1 - Generate info file compiling the mooring metadata
mooring_id=input('Mooring ID? (e.g. RF_11_12)     ','s');
disp(' ')

% Log processing
proc_log = [pwd '\processing_logs\' mooring_id '_processing_log.txt'];
eval(['diary ' proc_log])
disp('*** Processing log opened ***');

disp(' ')
disp(['Mooring ID:     ' mooring_id]);
disp(['Processed by:   ' processor_id]);
disp(['Date:           ' datestr(now(),'dd-mmm-yy')]);
disp(' ')

disp('Step 1: Reading metadata and creating info file...');
eval(['KROP_create_info_file_' mooring_id ]);
disp('Done')
disp(' ')


%% 2 - Read data from each instrument
%   (the script will call the relevant  individual subfunctions to read in the files)
disp('Step 2: Reading instruments data...');
info_file = [d_mat '\' mooring_id '_info.mat'];
KROP_read_data(info_file)
disp('Done')
disp(' ')
% Data saved in structure 'RAW'


%% 3 - Crop datasets according to mooring deployment and recovery times
disp('Step 3: Cropping data...');
KROP_crop(info_file)
carryon=input('Happy with crop times?(Y/N)        ','s');
if regexp(carryon,'N')
    disp('Processing stopped')
    return
elseif regexp(carryon,'n')
    disp('Processing stopped')
    return
end
disp('Done')
disp(' ')
% Data saved in structure 'RAW2'
% Plots saved in ...\plots\1_crop


%% 4 - Apply T & C offsets from intercomparison casts
disp('Step 4: Applying instrument offsets...');
KROP_apply_offsets(info_file)
disp('Done')
disp(' ')
close all
% Data saved in structure 'RAW3'
% Plots saved in ...\plots\2_offsets


%% 5 - Despiking
disp('Step 5a: Despiking data - rough...');
KROP_qc_rough(info_file)
% Data saved in structure 'RAW4'
disp('Done')
disp('Step 5b: Despiking data - fine...');
KROP_qc_fine(info_file)
disp('Done')
disp(' ')
close all
% Data saved in structure 'PRO'
% Plots saved in ...\plots\3_qc


%% 6 - Averaging (all variables, daily and 6-hourly)
disp('Step 6: Averaging data...');
KROP_avg_daily(info_file)
KROP_avg_6hr(info_file)
disp('Done')
disp(' ')
% Data saved in structure 'PRO_avg_daily' and 'PRO_avg_6hr'


%% 7 - Gridding of temp data (6-hours, 1m-bin)
disp('Step 7: Gridding temperature data...');
KROP_grid_temp(info_file)
disp('Done')
disp(' ')
% Data saved in structure 'PRO_grid_temp'


%% 8 - Plots
disp('Step 8: Plotting data...');
KROP_plot_mooring(info_file)
disp('Done')
disp(' ')
% Plots saved in ...\plots\4_pro


%% 9 - Export to csv
disp('Step 9: Exporting data to csv...');
KROP_export_csv(info_file)
disp('Done')
disp(' ')


%% 10 - Export to NetCDF
disp('Step 10: Exporting data to NetCDF...');
KROP_export_nc(info_file)
eval(['cd ' d_root '\processing\matlab_CTD'])
KROP_export_nc_avg(info_file)
disp('Done')
disp(' ')


%%
toc

diary off
disp('*** Processing log closed ***');

eval(['cd ' d_root '\processing\matlab_CTD'])
