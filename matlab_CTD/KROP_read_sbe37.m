function sbe37=KROP_read_sbe37(moor,mooring_lat,sn,in_dir,nom_depth,p,start_year)

%% Function to read SBE37 data from KROP moorings.
%
% To be used for reading ascii files produced by the KROP standard SeaBird
% processing psa files.
%
% Inputs:
%     moor = KROP mooring ID in format MM_YY-YY (e.g. RF_16-17)
%     mooring_lat = mooring latitude
%     in_dir = input directory
%     sn = sbe37 serial number
%     depth = sbe37 nominal depth on mooring
%     p = pressure sensor installed (0=no, 1=yes)
%     start_year = year at start of datafile (for conversion of recording)
%
%
% ESDU, SAMS, Feb 19
%%


% Work out data filename
in_file = [in_dir '\' moor '_sbe37_' sn '.asc'];

% Read data

if p == 1
    
    % Check variable order (sometimes depth is before pres)
    fid=fopen(in_file);
    hdr = fgetl(fid);
    hdr_s = strsplit(hdr,',');
    test_str = hdr_s{3};
    
    if regexp(test_str(1:2),'Pr','ignorecase')
        [sbe37.scan,sbe37.jday,sbe37.pres,sbe37.depth,sbe37.temp,...
            sbe37.cond,sbe37.sal,sbe37.sigmatheta,flag]=...
            textread(in_file,'%f%f%f%f%f%f%f%f%f','delimiter',',','headerlines',1);
    elseif regexp(test_str(1:2),'De','ignorecase')
        [sbe37.scan,sbe37.jday,sbe37.depth,sbe37.pres,sbe37.temp,...
            sbe37.cond,sbe37.sal,sbe37.sigmatheta,flag]=...
            textread(in_file,'%f%f%f%f%f%f%f%f%f','delimiter',',','headerlines',1);
    end
    fclose(fid);
    clear hrd hdr_s test_str
    
    % Add nominal depth
    sbe37.nominal_depth=zeros(length(sbe37.scan),1);
    sbe37.nominal_depth(:,1) = str2num(nom_depth);
    
    % Convert julian day to mtime
    % Get mtime for start of year
    year_start_mtime = datenum(start_year,1,1);
    if any([regexp(moor,'RF_06_07'),regexp(moor,'KF_03_04b')]) % Special case in those files: Jday in files seems to start at 0 that year instead of 1
        sbe37.mtime = year_start_mtime-1 + sbe37.jday +1;
    else
        sbe37.mtime = year_start_mtime-1 + sbe37.jday;
    end
    
    % Calculate salinity and depth if NaN in file (when no hex file
    % available for conversion in SBE software)
    if nansum(sbe37.depth)==0
        sbe37.depth(1:end)=sw_dpth(sbe37.pres,lat);
    end
    if nansum(sbe37.sal)==0
        sbe37.sal=sw_salt(sbe37.cond/sw_c3515,sbe37.temp,sbe37.pres);
    end
    if nansum(sbe37.sigmatheta)==0
        sbe37.sigmatheta=sw_pden(sbe37.sal,sbe37.temp,sbe37.pres,0)-1000;
    end
    
elseif p == 0
    
    [sbe37.scan,sbe37.jday,sbe37.temp,sbe37.cond,flag]=...
        textread(in_file,'%f%f%f%f%f','delimiter',',','headerlines',1);
    
    % Add nominal depth
    sbe37.nominal_depth=zeros(length(sbe37.scan),1);
    sbe37.nominal_depth(:,1) = str2num(nom_depth);
    
    % If no pressure sensor use nominal CTD depth to derive salinity and
    % potential density
    nominal_pres = sw_pres(sbe37.nominal_depth(1),mooring_lat);
    
    % Prepare arrays
    sbe37.pres=zeros(length(sbe37.scan),1);
    sbe37.depth=zeros(length(sbe37.scan),1);
    sbe37.sal=zeros(length(sbe37.scan),1);
    sbe37.sigmatheta=zeros(length(sbe37.scan),1);
    
    % Fill in values
    sbe37.pres(1:end)=nominal_pres;
    sbe37.depth(1:end)=sbe37.nominal_depth;
    sbe37.sal=sw_salt(sbe37.cond/sw_c3515,sbe37.temp,sbe37.pres);
    sbe37.sigmatheta=sw_pden(sbe37.sal,sbe37.temp,sbe37.pres,0)-1000;
    
    % Convert julian day to mtime
    % Get mtime for start of year
    year_start_mtime = datenum(start_year,1,1);
    sbe37.mtime = year_start_mtime-1 + sbe37.jday;
    
elseif p == 2
    
    [sbe37.temp,sbe37.cond,sbe37.pres,sbe37.sal,sbedate,sbetime]=...
        textread(in_file,'%f%f%f%f%s%s','delimiter',',','headerlines',1);
    
    % Convert conductivity from S/m to mS/cm
    sbe37.cond = sbe37.cond*10;
    
    % Convert time
    for k=1:length(sbedate)
        sbe37.mtime(k,1) = datenum([sbedate{k} ' ' sbetime{k}]);
    end
    
    % Recalculate Julian day (working out last day of year BEFORE
    % deployment)
    %     if regexp(moor,'RF_17_18')
    %         sbe37.jday = sbe37.mtime-datenum('31-Dec-2016');
    %     elseif regexp(moor,'RF_18_20')
    %         sbe37.jday = sbe37.mtime-datenum('31-Dec-2017');
    %     end
    sbe37.jday = sbe37.mtime - datenum(str2double(mooring_id(4:5))+1999,12,31);
    
    % Add scan number
    for k=1:length(sbe37.mtime)
        sbe37.scan(k,1) = k;
    end
    
    % Add nominal depth
    sbe37.nominal_depth=zeros(length(sbe37.scan),1);
    sbe37.nominal_depth(:,1) = str2num(nom_depth);
    
    % Derive other variables
    sbe37.depth = sw_dpth(sbe37.pres,mooring_lat);
    sbe37.sigmatheta = sw_pden(sbe37.sal,sbe37.temp,sbe37.pres,0)-1000;
    
    
elseif p == 3 % Bad pressure data
    
    [sbe37.scan,sbe37.jday,sbe37.pres,sbe37.depth,sbe37.temp,...
        sbe37.cond,sbe37.sal,sbe37.sigmatheta,flag]=...
        textread(in_file,'%f%f%f%f%f%f%f%f%f','delimiter',',','headerlines',1);
    
    % Calculate mtime
    year_start_mtime = datenum(start_year,1,1);
    if regexp(moor,'RF_06_07') % Issue in those files: Jday in files seems to start at 0 that year instead of 1
        sbe37.mtime = year_start_mtime-1 + sbe37.jday +1;
    else
        sbe37.mtime = year_start_mtime-1 + sbe37.jday;
    end
    
    % Add nominal depth
    sbe37.nominal_depth=zeros(length(sbe37.scan),1);
    sbe37.nominal_depth(:,1) = str2num(nom_depth);
    
    % Recalculate derived variables
    sbe37.depth = sbe37.nominal_depth;
    sbe37.pres = sw_pres(sbe37.depth,mooring_lat);
    sbe37.sal = sw_salt(sbe37.cond/sw_c3515,sbe37.temp,sbe37.pres);
    sbe37.sigmatheta = sw_pden(sbe37.sal,sbe37.temp,sbe37.pres,0)-1000;
    
end



