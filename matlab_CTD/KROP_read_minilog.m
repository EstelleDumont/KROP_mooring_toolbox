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
% Different formats depending on year (probably due to software/export options used) and sensors
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
    if any([regexp(moor,'KF_03_04a'),start_year<=2002],'all')
        if ml_p ==0
            [date_str,time_str,temp,~]=textread(in_file,'%s%s%f%f','delimiter',',','headerlines',7);
        else
            [date_str,time_str,temp,~,depth,~]=textread(in_file,'%s%s%f%f%f%f','delimiter',',','headerlines',7);
        end
            date_num = split(date_str,'-');
            if length(date_str{1})==10 % format Date(dd-mm-yyyy)
                YYYY = str2double(date_num(:,3));
                MM = str2double(date_num(:,2));
                DD = str2double(date_num(:,1));
            elseif length(date_str{1})==8 % format Date(yy-mm-dd)
                year_add = start_year - str2double(date_num(1,1));
                YYYY = str2double(date_num(:,1))+year_add;
                MM = str2double(date_num(:,2));
                DD = str2double(date_num(:,3));
            end
            time_num = split(time_str,':');
            hh = str2double(time_num(:,1));
            mm = str2double(time_num(:,2));
            ss = str2double(time_num(:,3));
    elseif start_year==2004 || start_year==2005
        if ml_p ==0
            [date_str,time_str,temp,~]=textread(in_file,'%s%s%f%f','delimiter',',','headerlines',8);
            date_num = split(date_str,'-');
            YYYY = str2double(date_num(:,3));
            MM = str2double(date_num(:,2));
            DD = str2double(date_num(:,1));
            time_num = split(time_str,':');
            hh = str2double(time_num(:,1));
            mm = str2double(time_num(:,2));
            ss = str2double(time_num(:,3));
        else
            [date_str,time_str,temp,~,depth,~]=textread(in_file,'%s%s%f%f%f%f','delimiter',',','headerlines',8);
            date_num = split(date_str,'-');
            YYYY = str2double(date_num(:,3));
            MM = str2double(date_num(:,2));
            DD = str2double(date_num(:,1));
            time_num = split(time_str,':');
            hh = str2double(time_num(:,1));
            mm = str2double(time_num(:,2));
            ss = str2double(time_num(:,3));
        end
    elseif start_year==2003 || start_year==2006
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

else % other moorings (not tested yet), use most common format
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

% Convert date and time to mtime
% Preallocate arrays
ml.mtime = zeros(length(DD),1);
% Convert to matlab time
ml.mtime = datenum(YYYY,MM,DD,hh,mm,ss);
% Correct time for some of the minilogs on the first year of KF - wrong by
% one or two days
if regexp(moor,'KF_02_03a')
    if any([str2num(sn)==4792,str2num(sn)==4793,str2num(sn)==8545,str2num(sn)==9046])
        ml.mtime = ml.mtime + 2;
    end
end
if regexp(moor,'KF_02_03b')
    if any([str2num(sn)==4792,str2num(sn)==4793,str2num(sn)==8545])
        ml.mtime = ml.mtime + 1;
    end
end

% Add nominal depth
ml.nominal_depth=zeros(length(temp),1);
ml.nominal_depth(:,1) = str2num(nom_depth);

ml.temp=temp;
if exist('depth','var')
    if regexp(moor(1:8),'KF_05_06') & str2num(sn)==2637 % bad pressure
        ml.depth = NaN(length(ml.mtime),1);
    else
        ml.depth = depth;
    end
end
