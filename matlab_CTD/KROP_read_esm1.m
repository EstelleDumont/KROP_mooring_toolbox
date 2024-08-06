function esm1=KROP_read_esm1(moor,sn,flc,start_year,in_dir,nom_depth,esm1_flc_bits,esm1_flc_range)

%% Function to read ESM-1 data from KROP moorings.
%
% To be used for reading ascii files from ESM-1 loggers
%
% Inputs:
%     moor = KROP mooring ID in format MM_YY-YY (e.g. RF_16-17)
%     in_dir = input directory
%     sn = serial number
%     depth = nominal depth on mooring
%
%
% ESDU, SAMS, Feb 19
%%

% Work out data filename
in_file = [in_dir '\' moor '_ESM1_' sn '.asc'];

% Read data
[jday,esm1.flc_eng,~,~,~,~,~]=textread(in_file,'%f%f%f%f%f%f%f',...
    'delimiter',',','headerlines',1);

% Convert julian day to mtime
% Get mtime for start of year
year_start_mtime = datenum(start_year,1,1);
esm1.mtime = year_start_mtime-1 + jday;

% Add nominal depth
esm1.nominal_depth=zeros(length(jday),1);
esm1.nominal_depth(:,1) = str2num(nom_depth);

% Convert raw readings to chl concentration
esm1.flc = esm1.flc_eng / (2^esm1_flc_bits) * esm1_flc_range;


