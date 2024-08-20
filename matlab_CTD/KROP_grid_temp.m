function KROP_grid_temp(info_file)

% Extract temperature data from all instruments (6-hour averaged file) and
% interpolate in depth (every 1m)
% ESDU, SAMS, April 19

% Note: currently the code lists (and looks for) each intrument type, but 
% in future versions this script could be improved by automatically
% selecting all instruments available, or only those specified by the user.

close all
load(info_file)

% Load mooring data
mat_fl = [d_mat '\' mooring_id '_CTD.mat'];
load(mat_fl)


%% Collate instrument list and nominal depths
inst_depth=[];
jj=1;

if exist('sbe16p_num','var')
    if sbe16p_num >0
        for j = 1:sbe16p_num
            inst_sn(jj,1) = str2double(sbe16p_sn(j));
            inst_depth(jj,1) = str2double(sbe16p_depth(j));
            eval(['inst_temp(jj,:) = PRO_avg_6hr.SBE16p_' sbe16p_sn{j} '.temp(:,1);']);
            jj=jj+1;
        end
    end
end

if exist('sbe19p_num','var')
    if sbe19p_num >0
        for j = 1:sbe19p_num
            inst_sn(jj,1) = str2double(sbe19p_sn(j));
            inst_depth(jj,1) = str2double(sbe19p_depth(j));
            eval(['inst_temp(jj,:) = PRO_avg_6hr.SBE19p_' sbe19p_sn{j} '.temp(:,1);']);
            jj=jj+1;
        end
    end
end

% Hydrocat data stopped early in 20/21 - do not use in grid or else it
% creates a gap in the grid at the end of deployment
% if exist('hcat_num','var')
%     if hcat_num >0
%         for j = 1:hcat_num
%             inst_sn(jj,1) = str2double(hcat_sn(j));
%             inst_depth(jj,1) = str2double(hcat_depth(j));
%             eval(['inst_temp(jj,:) = PRO_avg_6hr.HCAT_' hcat_sn{j} '.temp(:,1);']);
%             jj=jj+1;
%         end
%     end
% end

if exist('sbe37_num','var')
    if sbe37_num >0
        for j = 1:sbe37_num
            inst_sn(jj,1) = str2double(sbe37_sn(j));
            inst_depth(jj,1) = str2double(sbe37_depth(j));
            eval(['inst_temp(jj,:) = PRO_avg_6hr.SBE37_' sbe37_sn{j} '.temp(:,1);']);
            jj=jj+1;
        end
    end
end

if exist('sbe56_num','var')
    if sbe56_num >0
        for j = 1:sbe56_num
            % Check if it's at the same depth as an SBE16 or SBE37, if it is
            % don't include in grid
            this_depth = str2double(sbe56_depth(j));
            ind_dbl = find(inst_depth == this_depth);
            if isempty(ind_dbl)
                inst_sn(jj,1) = str2double(sbe56_sn(j));
                inst_depth(jj,1) = str2double(sbe56_depth(j));
                eval(['inst_temp(jj,:) = PRO_avg_6hr.SBE56_' sbe56_sn{j} '.temp(:,1);']);
                jj=jj+1;
            end
        end
    end
end

if exist('ml_num','var')
    if ml_num >0
        for j = 1:ml_num
            % Check if it's at the same depth as an SBE16 or SBE37, if it is
            % don't include in grid
            this_depth = str2double(ml_depth(j));
            ind_dbl = find(inst_depth == this_depth);
            if isempty(ind_dbl)
                inst_sn(jj,1) = str2double(ml_sn(j));
                inst_depth(jj,1) = str2double(ml_depth(j));
                eval(['inst_temp(jj,:) = PRO_avg_6hr.ML_' ml_sn{j} '.temp(:,1);']);
                jj=jj+1;
            end
        end
    end
end

% Put list back in order of increasing depth
[grid_depth,grid_ind]=sort(inst_depth);
grid_sn = inst_sn(grid_ind);
grid_temp = inst_temp(grid_ind,:);


%% Gridding
% Setup time and bin interval for grid
binsize_y = 1;
interp_depth = [min(grid_depth):binsize_y:max(grid_depth)];

% Initialise array
interp_temp = nan(length(interp_depth),length(PRO_avg_6hr.interp_time));

% Interpolate data
for k = 1:length(interp_temp)
    interp_temp(:,k) = interp1(grid_depth,grid_temp(:,k),interp_depth);
end


%% Save data
PRO_grid_temp.inst_sn = grid_sn;
PRO_grid_temp.inst_depth = grid_depth;
PRO_grid_temp.interp_time = PRO_avg_6hr.interp_time;
PRO_grid_temp.interp_depth = interp_depth;
PRO_grid_temp.interp_temp = interp_temp;
save(mat_fl,'PRO_grid_temp','-append');


