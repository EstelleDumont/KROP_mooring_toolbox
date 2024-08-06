function sbe16p=KROP_read_sbe16p(moor,mooring_lat,sn,in_dir,nom_depth,p,t,c,flc,par,tur,start_year)

%% Function to read SBE16+ data from KROP moorings.
%
% To be used for reading ascii files produced by the KROP standard SeaBird
% processing psa files.
%
% Inputs:
%     moor = KROP mooring ID in format MM_YY-YY (e.g. RF_16-17)
%     mooring_lat = mooring latitude
%     in_dir = input directory
%     sn = sbe16+ serial number
%     depth = sbe16+ nominal depth on mooring
%     p = pressure sensor installed (0=no, 1=yes)
%     t = temperature sensor installed (0=no, 1=yes) - not used
%     c = conductivity sensor installed (0=no, 1=yes) - not used
%     flc = fluorometer installed (0=no, 1=yes)
%     par = par sensor installed (0=no, 1=yes)
%     tur = turbidity sensor installed (0=no, 1=yes)
%     start_year = year at start of datafile (for conversion of recording)
%
% ESDU, SAMS, Jan 19
%%


% Work out data filename
in_file = [in_dir '\' moor '_sbe16p_' sn '.asc'];

% Read data according to list of sensors specified
% List below only includes configurations used up to 2018, new ones can be
% added to the list in the future.

if p==1 && flc==0 && par==0 && tur==0
    [sbe16p.scan,sbe16p.jday,sbe16p.pres,sbe16p.depth,sbe16p.temp,...
        sbe16p.cond,sbe16p.sal,sbe16p.sigmatheta,flag]=...
        textread(in_file,'%f%f%f%f%f%f%f%f%f','delimiter',',','headerlines',1);
    
elseif p==1 && flc==1 && par==0 && tur==0
    [sbe16p.scan,sbe16p.jday,sbe16p.pres,sbe16p.depth,sbe16p.temp,...
        sbe16p.cond,sbe16p.sal,sbe16p.sigmatheta,sbe16p.flc_V,sbe16p.flc,flag]=...
        textread(in_file,'%f%f%f%f%f%f%f%f%f%f%f','delimiter',',','headerlines',1);
    
elseif p==1 && flc==0 && par==1 && tur==0
    [sbe16p.scan,sbe16p.jday,sbe16p.pres,sbe16p.depth,sbe16p.temp,...
        sbe16p.cond,sbe16p.sal,sbe16p.sigmatheta,sbe16p.par_V,sbe16p.par,flag]=...
        textread(in_file,'%f%f%f%f%f%f%f%f%f%f%f','delimiter',',','headerlines',1);
    
elseif p==1 && flc==1 && par==1 && tur==0
    [sbe16p.scan,sbe16p.jday,sbe16p.pres,sbe16p.depth,sbe16p.temp,...
        sbe16p.cond,sbe16p.sal,sbe16p.sigmatheta,sbe16p.flc_V,...
        sbe16p.flc,sbe16p.par_V,sbe16p.par,flag]=...
        textread(in_file,'%f%f%f%f%f%f%f%f%f%f%f%f%f','delimiter',',','headerlines',1);
    
elseif p==2 && flc==1 && par==1 && tur==0 % ind p=2 = faulty pressure sensor
    [sbe16p.scan,sbe16p.jday,sbe16p.pres,sbe16p.depth,sbe16p.temp,...
        sbe16p.cond,sbe16p.sal,sbe16p.sigmatheta,sbe16p.flc_V,...
        sbe16p.flc,sbe16p.par_V,sbe16p.par,flag]=...
        textread(in_file,'%f%f%f%f%f%f%f%f%f%f%f%f%f','delimiter',',','headerlines',1);
    
elseif p==1 && flc==1 && par==1 && tur==1
    [sbe16p.scan,sbe16p.jday,sbe16p.pres,sbe16p.depth,sbe16p.temp,...
        sbe16p.cond,sbe16p.sal,sbe16p.sigmatheta,sbe16p.flc_V,...
        sbe16p.flc,sbe16p.par_V,sbe16p.par,sbe16p.tur_V,sbe16p.tur,flag]=...
        textread(in_file,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','delimiter',',','headerlines',1);
    
end

% Convert julian day to mtime
% Get mtime for start of year
year_start_mtime = datenum(start_year,1,1);
sbe16p.mtime = year_start_mtime-1 + sbe16p.jday;

% Add nominal depth
sbe16p.nominal_depth=zeros(length(sbe16p.scan),1);
sbe16p.nominal_depth(:,1) = str2num(nom_depth);

% Recalculate some variables using nominal depth if pressure sensor faulty (e.g. RF_13_14)
if p==3
    
    nominal_pres = sw_pres(sbe16p.nominal_depth(1),mooring_lat);
    
    % Prepare arrays
    sbe16p.pres=zeros(length(sbe16p.scan),1);
    sbe16p.depth=zeros(length(sbe16p.scan),1);
    sbe16p.sal=zeros(length(sbe16p.scan),1);
    sbe16p.sigmatheta=zeros(length(sbe16p.scan),1);
    
    % Fill in values
    sbe16p.pres(1:end)=nominal_pres;
    sbe16p.depth(1:end)=sbe16p.nominal_depth;
    sbe16p.sal=sw_salt(sbe16p.cond/sw_c3515,sbe16p.temp,sbe16p.pres);
    sbe16p.sigmatheta=sw_pden(sbe16p.sal,sbe16p.temp,sbe16p.pres,0)-1000;

end

