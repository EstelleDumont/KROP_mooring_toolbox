function [start2,stop2,lat2,lon2,adcpdepth2,wdepth2,orient2,ice2,icepct2]=extract_metadata(filename)

load(filename);

start2 = datestr(start,0);
stop2 = datestr(stop,0);
adcpdepth2 = num2str(adcp_depth);
wdepth2= num2str(w_depth);


lat2 = num2str((abs(lat_deg) + abs(lat_min/60)) * (lat_deg/abs(lat_deg)));
lon2 = num2str((abs(long_deg) + abs(long_min/60)) * (long_deg/abs(long_deg)));

orient2 = config.orientation;

if sum(ice_cover)<0;
    ice2=-1;
    icepct2=NaN;
elseif sum(ice_cover)==0;   
    ice2 = 0;
    icepct2 = NaN;
elseif sum(ice_cover)>0;
    ice2 = 1;
    % Calculate % of ice cover
    ind = find (ice_cover == 1);
    icepct2 = length(ind)*100/length(mtime_all);


end;