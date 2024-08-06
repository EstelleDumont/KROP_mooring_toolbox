function ml=KROP_read_minilog(moor,sn,start_year,in_dir,nom_depth,ml_p)

%% Function to read minilog data from KROP moorings.
%
% To be used for reading ascii files produced by the KROP standard SeaBird
% processing psa files.
%
% Inputs:
%     moor = KROP mooring ID in format MM_YY-YY (e.g. RF_16-17)
%     in_dir = input directory
%     sn = minilog serial number
%     depth = minilog nominal depth on mooring
%
%
% ESDU, SAMS, Feb 19
%%

% Work out data filename
in_file = [in_dir '\' moor '_minilog_' sn '.asc'];

% Read data
% Different formats according to date and sensors
if regexp(moor(1:2),'RF')
    if start_year<=2007
        if ml_p ==0
            [date_str,time_str,temp]=textread(in_file,'%s%s%f','delimiter',',','headerlines',7);
            date_num = split(date_str,'-');
            YYYY = str2double(date_num(:,3));
            MM = str2double(date_num(:,2));
            DD = str2double(date_num(:,1));
            time_num = split(time_str,':');
            hh = str2double(time_num(:,1));
            mm = str2double(time_num(:,2));
            ss = str2double(time_num(:,3));
        else
            [date_str,time_str,temp,depth]=textread(in_file,'%s%s%f%f','delimiter',',','headerlines',7);
            date_num = split(date_str,'-');
            YYYY = str2double(date_num(:,3));
            MM = str2double(date_num(:,2));
            DD = str2double(date_num(:,1));
            time_num = split(time_str,':');
            hh = str2double(time_num(:,1));
            mm = str2double(time_num(:,2));
            ss = str2double(time_num(:,3));
        end
    elseif start_year<=2009
        if ml_p ==0
            [date_str,time_str,temp]=textread(in_file,'%s%s%f','delimiter',',','headerlines',7);
            date_num = split(date_str,'-');
            YYYY = str2double(date_num(:,1));
            MM = str2double(date_num(:,2));
            DD = str2double(date_num(:,3));
            time_num = split(time_str,':');
            hh = str2double(time_num(:,1));
            mm = str2double(time_num(:,2));
            ss = str2double(time_num(:,3));
        else
            [date_str,time_str,temp,depth]=textread(in_file,'%s%s%f%f','delimiter',',','headerlines',7);
            date_num = split(date_str,'-');
            YYYY = str2double(date_num(:,1));
            MM = str2double(date_num(:,2));
            DD = str2double(date_num(:,3));
            time_num = split(time_str,':');
            hh = str2double(time_num(:,1));
            mm = str2double(time_num(:,2));
            ss = str2double(time_num(:,3));
        end
    else
        [DD,MM,YYYY,hh,mm,ss,temp,~]=textread(in_file,'%f%f%f%f%f%f%f%f','delimiter',',','headerlines',8);
    end
    
elseif regexp(moor(1:2),'KF')
    if start_year<=2006
        if ml_p ==0
            [date_str,time_str,temp]=textread(in_file,'%s%s%f','delimiter',',','headerlines',7);
            date_num = split(date_str,'-');
            YYYY = str2double(date_num(:,3));
            MM = str2double(date_num(:,2));
            DD = str2double(date_num(:,1));
            time_num = split(time_str,':');
            hh = str2double(time_num(:,1));
            mm = str2double(time_num(:,2));
            ss = str2double(time_num(:,3));
        else
            [date_str,time_str,temp,depth]=textread(in_file,'%s%s%f%f','delimiter',',','headerlines',7);
            date_num = split(date_str,'-');
            YYYY = str2double(date_num(:,3));
            MM = str2double(date_num(:,2));
            DD = str2double(date_num(:,1));
            time_num = split(time_str,':');
            hh = str2double(time_num(:,1));
            mm = str2double(time_num(:,2));
            ss = str2double(time_num(:,3));
        end
    elseif start_year==2010
        [DD,MM,YYYY,hh,mm,ss,temp,~]=textread(in_file,'%f%f%f%f%f%f%f%f','delimiter',',','headerlines',8);
    else
        if ml_p ==0
            [date_str,time_str,temp]=textread(in_file,'%s%s%f','delimiter',',','headerlines',7);
            date_num = split(date_str,'-');
            YYYY = str2double(date_num(:,1));
            MM = str2double(date_num(:,2));
            DD = str2double(date_num(:,3));
            time_num = split(time_str,':');
            hh = str2double(time_num(:,1));
            mm = str2double(time_num(:,2));
            ss = str2double(time_num(:,3));
        else
            [date_str,time_str,temp,depth]=textread(in_file,'%s%s%f%f','delimiter',',','headerlines',7);
            date_num = split(date_str,'-');
            YYYY = str2double(date_num(:,1));
            MM = str2double(date_num(:,2));
            DD = str2double(date_num(:,3));
            time_num = split(time_str,':');
            hh = str2double(time_num(:,1));
            mm = str2double(time_num(:,2));
            ss = str2double(time_num(:,3));
        end
    end
end

% Convert date and time to mtime
% Preallocate arrays
ml.mtime=zeros(length(DD),1);
% Convert to matlab time
ml.mtime=datenum(YYYY,MM,DD,hh,mm,ss);

% Add nominal depth
ml.nominal_depth=zeros(length(temp),1);
ml.nominal_depth(:,1) = str2num(nom_depth);

ml.temp=temp;
if exist('depth','var')
    ml.depth = depth;
end
