% Routine to extract ADCP settings from Panarchive datafiles.

clear all;

cd P:\PHYSICS\Panarchive\Processed\1_rdr
addpath C:\Code\Matlab\Various\nansuite

% List files
!dir *.mat /o/b >list.dat
% Read list
fid=fopen('list.dat');
[list]=textread('list.dat','%s');
fclose(fid);

for i=1:length(list);
    filename=list{i};
    a=load(filename);
    ins_depth(i)=a.adcp_depth;
    % Check orientation
    if strcmp(a.config.orientation,'up')==1;
        orient(i)=1;
    else orient(i)=0;
    end;
    freq(i)=a.config.beam_freq;
    n_bins(i)=a.config.n_cells;
    bin_size(i)=a.config.cell_size;
    bin1_depth(i)=a.config.bin1_dist;
    pings_per_ens(i)=a.config.pings_per_ensemble;
    time_between_pings(i)=a.config.time_between_ping_groups;
    % Calculate ensemble interval
%     for j=1:(length(a.mtime_all))-1;
%         tdif(j)=(a.mtime_all(j+1)-a.mtime_all(j))*24*60*60;
%         if tdif(j)<=0;
%             tdif(j)=NaN;
%         end
%     end;
%     ping_interval(i)=nanmean(tdif);
    tdif=(diff(a.mtime_all))*24*60*60;
    ind2=find(tdif<=0);
    tdif(ind2)=NaN;
    ping_interval(i)=nanmean(tdif);
    clear a tdif
end

% Set up data for output
data(:,1)=ins_depth(:);
data(:,2)=orient(:);
data(:,3)=freq(:);
data(:,4)=n_bins(:);
data(:,5)=bin_size(:);
data(:,6)=bin1_depth(:);
data(:,7)=pings_per_ens(:);
data(:,8)=time_between_pings(:);
data(:,9)=ping_interval(:);

file_out='PANARCHIVE_adcp_settings.asc';
fid2=fopen(file_out,'a+');
% Wite header
fprintf(fid2,'%s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\r',...
    'ins_depth','orient','freq','n_bins','bin_size','bin1_depth','pings_per_ens','time_between_pings','ensemble_interval');
% Write data
dlmwrite(file_out,data,'-append','delimiter', '\t','precision',12);
fclose(fid2);

cd P:\PHYSICS\Panarchive\Processed\matlab