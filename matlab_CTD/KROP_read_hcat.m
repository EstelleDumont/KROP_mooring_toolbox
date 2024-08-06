function HCAT=KROP_read_hcat(moor,mooring_lat,sn,in_dir,nom_depth,p,t,c,ph,flc,tur,oxy,start_year)

%% Function to read SBE19+ data from KROP moorings.
%
% To be used for reading ascii files produced by the KROP standard SeaBird
% processing psa files.
%
% Inputs:
%     moor = KROP mooring ID in format MM_YY-YY (e.g. RF_16-17)
%     mooring_lat = mooring latitude
%     in_dir = input directory
%     sn = hydrocat serial number
%     depth = hydrocat nominal depth on mooring
%     p = pressure sensor installed (0=no, 1=yes)
%     t = temperature sensor installed (0=no, 1=yes) - not used
%     c = conductivity sensor installed (0=no, 1=yes) - not used
%     ph = pH sensor installed (0=no, 1=yes)
%     flc = fluorometer installed (0=no, 1=yes)
%     tur = turbidity sensor installed (0=no, 1=yes)
%     oxy = oxygen sensor installed (0=no, 1=yes)
%     start_year = year at start of datafile (for conversion of recording)
%
% ESDU, SAMS, Jan 19
%%

% Create scan variable (to have first in file)
HCAT.scan(1,1) = 1;

% Work out data filename
in_file = [in_dir '\' moor '_hydrocat_' sn '.asc'];

% Read data according to list of sensors specified
% List below only includes original configuration used in 2020-21, new ones
% can be added to the list in the future. Format is for screen capture of
% data (no hex file available that year).

if p==1 && ph==1 && flc==1 && tur==1 && oxy==1
    [hcat_hdr,HCAT.temp,HCAT.cond,HCAT.pres,HCAT.oxy,HCAT.ph,HCAT.flc,...
        HCAT.tur,~,~,HCAT.sal,~,HCAT.oxy_sat,hcat_date,hcat_time,flag]=...
        textread(in_file,'%s%f%f%f%f%f%f%f%f%f%f%f%f%s%s%f',...
        'delimiter',',','headerlines',1);    
end

% Convert to mtime
hcat_datetime = strcat(hcat_date,'-',hcat_time);
HCAT.mtime = datenum(hcat_datetime,'dd mmm yyyy-HH:MM:SS');
clear hcat_*

% Add Julian day (to keep format consistent with other instruments)
HCAT.jday = HCAT.mtime - datenum(start_year-1,12,31);
 
% Add scan number (to keep format consistent with other instruments)
for s=1:length(HCAT.temp)
    HCAT.scan(s,1) = s;
end

% Add nominal depth
HCAT.nominal_depth=zeros(length(HCAT.scan),1);
HCAT.nominal_depth(:,1) = str2num(nom_depth);

% Convert conductivity from uS/cm to mS/cm
HCAT.cond = HCAT.cond/1000;

% Derive other variables
HCAT.depth = sw_dpth(HCAT.pres,mooring_lat);
HCAT.sigmatheta = sw_pden(HCAT.sal,HCAT.temp,HCAT.pres,0)-1000;

% Recalculate some variables using nominal depth if pressure sensor faulty (e.g. RF_13_14)
if p==3
    
    nominal_pres = sw_pres(HCAT.nominal_depth(1),mooring_lat);
    
    % Prepare arrays
    HCAT.pres=zeros(length(HCAT.scan),1);
    HCAT.depth=zeros(length(HCAT.scan),1);
    HCAT.sal=zeros(length(HCAT.scan),1);
    HCAT.sigmatheta=zeros(length(HCAT.scan),1);
    
    % Fill in values
    HCAT.pres(1:end)=nominal_pres;
    HCAT.depth(1:end)=HCAT.nominal_depth;
    HCAT.sal=sw_salt(HCAT.cond/sw_c3515,HCAT.temp,HCAT.pres);
    HCAT.sigmatheta=sw_pden(HCAT.sal,HCAT.temp,HCAT.pres,0)-1000;

end

