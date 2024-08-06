function sbe19p=KROP_read_sbe19p(moor,mooring_lat,sn,in_dir,nom_depth,p,t,c,flc,par,tur,start_year)

%% Function to read SBE19+ data from KROP moorings.
%
% To be used for reading ascii files produced by the KROP standard SeaBird
% processing psa files.
%
% Inputs:
%     moor = KROP mooring ID in format MM_YY-YY (e.g. RF_16-17)
%     mooring_lat = mooring latitude
%     in_dir = input directory
%     sn = sbe19+ serial number
%     depth = sbe19+ nominal depth on mooring
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
in_file = [in_dir '\' moor '_sbe19p_' sn '.asc'];

% Read data according to list of sensors specified
% List below only includes configurations used up to 2018, new ones can be
% added to the list in the future.

if p==1 && flc==0 && par==0 && tur==0
    [sbe19p.scan,sbe19p.jday,sbe19p.pres,sbe19p.depth,sbe19p.temp,...
        sbe19p.cond,sbe19p.sal,sbe19p.sigmatheta,flag]=...
        textread(in_file,'%f%f%f%f%f%f%f%f%f','delimiter',',','headerlines',1);
    
elseif p==1 && flc==1 && par==0 && tur==0
    [sbe19p.scan,sbe19p.jday,sbe19p.pres,sbe19p.depth,sbe19p.temp,...
        sbe19p.cond,sbe19p.sal,sbe19p.sigmatheta,sbe19p.flc_V,sbe19p.flc,flag]=...
        textread(in_file,'%f%f%f%f%f%f%f%f%f%f%f','delimiter',',','headerlines',1);
    
elseif p==1 && flc==0 && par==1 && tur==0
    [sbe19p.scan,sbe19p.jday,sbe19p.pres,sbe19p.depth,sbe19p.temp,...
        sbe19p.cond,sbe19p.sal,sbe19p.sigmatheta,sbe19p.par_V,sbe19p.par,flag]=...
        textread(in_file,'%f%f%f%f%f%f%f%f%f%f%f','delimiter',',','headerlines',1);
    
elseif p==1 && flc==1 && par==1 && tur==0
    [sbe19p.scan,sbe19p.jday,sbe19p.pres,sbe19p.depth,sbe19p.temp,...
        sbe19p.cond,sbe19p.sal,sbe19p.sigmatheta,sbe19p.flc_V,...
        sbe19p.flc,sbe19p.par_V,sbe19p.par,flag]=...
        textread(in_file,'%f%f%f%f%f%f%f%f%f%f%f%f%f','delimiter',',','headerlines',1);
    
elseif p==2 && flc==1 && par==1 && tur==0 % ind p=2 = faulty pressure sensor
    [sbe19p.scan,sbe19p.jday,sbe19p.pres,sbe19p.depth,sbe19p.temp,...
        sbe19p.cond,sbe19p.sal,sbe19p.sigmatheta,sbe19p.flc_V,...
        sbe19p.flc,sbe19p.par_V,sbe19p.par,flag]=...
        textread(in_file,'%f%f%f%f%f%f%f%f%f%f%f%f%f','delimiter',',','headerlines',1);
    
elseif p==1 && flc==1 && par==1 && tur==1
    [sbe19p.scan,sbe19p.jday,sbe19p.pres,sbe19p.depth,sbe19p.temp,...
        sbe19p.cond,sbe19p.sal,sbe19p.sigmatheta,sbe19p.flc_V,...
        sbe19p.flc,sbe19p.par_V,sbe19p.par,sbe19p.tur_V,sbe19p.tur,flag]=...
        textread(in_file,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','delimiter',',','headerlines',1);
    
end

% Convert julian day to mtime
% Get mtime for start of year
year_start_mtime = datenum(start_year,1,1);
sbe19p.mtime = year_start_mtime-1 + sbe19p.jday;

% Add nominal depth
sbe19p.nominal_depth=zeros(length(sbe19p.scan),1);
sbe19p.nominal_depth(:,1) = str2num(nom_depth);

% Recalculate some variables using nominal depth if pressure sensor faulty (e.g. RF_13_14)
if p==3
    
    nominal_pres = sw_pres(sbe19p.nominal_depth(1),mooring_lat);
    
    % Prepare arrays
    sbe19p.pres=zeros(length(sbe19p.scan),1);
    sbe19p.depth=zeros(length(sbe19p.scan),1);
    sbe19p.sal=zeros(length(sbe19p.scan),1);
    sbe19p.sigmatheta=zeros(length(sbe19p.scan),1);
    
    % Fill in values
    sbe19p.pres(1:end)=nominal_pres;
    sbe19p.depth(1:end)=sbe19p.nominal_depth;
    sbe19p.sal=sw_salt(sbe19p.cond/sw_c3515,sbe19p.temp,sbe19p.pres);
    sbe19p.sigmatheta=sw_pden(sbe19p.sal,sbe19p.temp,sbe19p.pres,0)-1000;

end

