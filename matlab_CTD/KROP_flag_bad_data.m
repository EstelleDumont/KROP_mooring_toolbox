function [ind_bad,p_handle]=KROP_flag_bad_data(moor,inst,nd,varb,varn,mtime,blk,thr,pos)

% Function to despike moored instruments datasets
%
% Input:    inst = instrument "name" (type + S/N), for labelling only
%           nd   = instrument (nominal) depth
%           varb = variable to despike (e.g. temp), array
%           varn = variable name (e.g. 'Temp'), string
%           mtime = instrument's time stamp (Matlab time)
%           blk = block length of data to calculate median over. Must be
%                 an even number.
%           thr = theshold to detect outliers.
% Output:   ib = index of bad data
% (for JR17006 try blk=48 (2s) and thresh = 0.005 for salinity)
%
% ESDU, SAMS, April 19


% Calculate moving average
win_med=mv_wind(varb,blk,'mean','none');

% Select data points falling beyond specified threshold
ib=zeros(length(varb),1);
for j=blk/2:length(varb)-blk/2
    if varb(j)<win_med(j-blk/2+1)-thr || varb(j)>win_med(j-blk/2+1)+thr
        ib(j)=1;
    end
end
% Special case: points that don't get caught by auto-despiking
if regexp(moor,'RF_18_20')
    if regexp(inst,'SBE37_14868')
        if regexp(varn,'cond')
            ib(8646:8663)=1;
        end
        if regexp(varn,'sal')
            ib(8646:8663)=1;
        end
    end
end
ind_bad=logical(ib);

% Calculate stats
samp_int = round((mtime(2)-mtime(1))*24*60);
blk_hrs = round((blk*samp_int)/60);
nb_pts = length(varb);
nb_bad_pts = length(find(ind_bad)==1);
pct_bad = (nb_bad_pts/nb_pts)*100;

% Print stats on screen
disp('*****');
disp(['Variable processed:           ' inst '.' varn]);
disp(['Sampling interval:            ' num2str(samp_int) ' minutes']);
disp(['Averaging block:              ' num2str(blk_hrs) ' hours']);
disp(['Outlier threshold (std dev):  ' num2str(thr)]);
disp(['Data points flagged:          ' num2str(nb_bad_pts)]);
disp(['Percentage of data flagged:   ' num2str(pct_bad) '%']);

% Plot up flagged data
eval(['p' num2str(pos) '=subplot(31' num2str(pos) ');']) 
hold on; box on; grid on
plot(mtime,varb,'color',[0 .7 1])
plot(mtime(blk/2:length(varb)-blk/2),win_med,'bd','markersize',2)
% Add new bad data flagged here
plot(mtime(ind_bad),varb(ind_bad),'ro')
title_str = [inst ' (' num2str(nd) 'm) - Block length = ' num2str(blk_hrs) ' hours; threshold = ' num2str(thr) ' std dev'];
title(title_str,'interpreter','none');

clear ib nb_pts nb_bad_pts pct_bad

eval(['p_handle = p' num2str(pos) ';'])

