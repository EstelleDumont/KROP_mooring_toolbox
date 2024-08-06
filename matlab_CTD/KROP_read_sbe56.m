function sbe56=KROP_read_sbe56(moor,sn,in_dir,nom_depth)

%% Function to read SBE56 data from KROP moorings.
%
% To be used for reading ascii files produced by the KROP standard SeaBird
% processing psa files.
%
% Inputs:
%     moor = KROP mooring ID in format MM_YY-YY (e.g. RF_16-17)
%     in_dir = input directory
%     sn = sbe56 serial number
%     depth = sbe56 nominal depth on mooring
%
%
% ESDU, SAMS, Feb 19
%%

% Work out data filename
in_file = [in_dir '\' moor '_sbe56_' sn '.csv'];

% Read data
if regexp(moor,'RF_14_15')
    [~,date1,time1,temp1]=textread(in_file,'%s%s%s%s','delimiter',',','headerlines',12);
else
    [date1,time1,temp1]=textread(in_file,'%s%s%s','delimiter',',','headerlines',12);
end

% Remove double-quotes from cell arrays
date2=strrep(date1,'"','');
time2=strrep(time1,'"','');
temp2=strrep(temp1,'"','');
% Convert to text arrays
date3=char(date2);
time3=char(time2);

% Convert date and time to mtime

% Preallocate arrays
sbe56.mtime=zeros(length(date3),1);
YYYY=zeros(length(date3),1); MM=zeros(length(date3),1); 
DD=zeros(length(date3),1); hh=zeros(length(date3),1);
mm=zeros(length(date3),1); ss=zeros(length(date3),1);

% Extract datetime data
% Extract datetime data
% Test date format --> either dd/mm/yyyy or yyyy-mm-dd or dd-mm-yyyy
test_char = date3(1,3);
if regexp(test_char,'/')
    for k=1:length(date3)
        DD(k,1)     =str2double(date3(k,1:2));
        MM(k,1)     =str2double(date3(k,4:5));
        YYYY(k,1)   =str2double(date3(k,7:10));
        hh(k,1)     =str2double(time3(k,1:2));
        mm(k,1)     =str2double(time3(k,4:5));
        ss(k,1)     =str2double(time3(k,7:8));
    end
elseif regexp(test_char,'-')
    for k=1:length(date3)
        DD(k,1)     =str2double(date3(k,1:2));
        MM(k,1)     =str2double(date3(k,4:5));
        YYYY(k,1)   =str2double(date3(k,7:10));
        hh(k,1)     =str2double(time3(k,1:2));
        mm(k,1)     =str2double(time3(k,4:5));
        ss(k,1)     =str2double(time3(k,7:8));
    end
else
    for k=1:length(date3)
        YYYY(k,1)   =str2double(date3(k,1:4));
        MM(k,1)     =str2double(date3(k,6:7));
        DD(k,1)     =str2double(date3(k,9:10));
        hh(k,1)     =str2double(time3(k,1:2));
        mm(k,1)     =str2double(time3(k,4:5));
        ss(k,1)     =str2double(time3(k,7:8));
    end
end
% Convert to matlab time
sbe56.mtime=datenum(YYYY,MM,DD,hh,mm,ss);

% Too slow! replaced by lines above
% sbe56.mtime=datenum([date2{:} ' ' time2{:}]);
% for k=1:length(date2)
%     datetime_str = [date2{k} ' ' time2{k}];
%     sbe56.mtime(k,1)= datenum(datetime_str);
% end 

% Convert temp data form cell to double
for m=1:length(temp2)
    sbe56.temp(m,1)=str2num(temp2{m});
end

% Add nominal depth
sbe56.nominal_depth=zeros(length(temp1),1);
sbe56.nominal_depth(:,1) = str2num(nom_depth);
