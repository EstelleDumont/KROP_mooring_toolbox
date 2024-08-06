function err_msg = interpolate_adcp_data_30min_weekly(root_dir,M_id,start_date,end_date,f_csv,f_sv,f_vv,f_u,f_v,f_spd,f_dir)

% ADCP data script to:
%   1) interpolate data in 30-minute intervals
%   2) export data as csv files
% The ADCP data should be in mat format, processed using the SAMS ADCP 
% backscatter gui toolbox (inc. rdradcp.m function  by R. Pawlowicz) and
% follow the KROP file naming conventsions and folder structure.
% Input:
%   - root_dir = Root directory for KROP folder structure (i.e. the folder
%               containing all the individual moorings subfolders, and the
%               processing folder)
%   - M_id = mooring ID (e.g. RF_06_07)
%   - start_date = mooring deployment date (or date to start averaging files)
%   - end_date = mooring recovery date  (or date to end averaging files)
%   - f_csv = flag for csv export (1 if want to export csv files, 0 if not)
%   - f_sv/vv/u/v/spd/dir = variable flags for export (1 = export, 0 = do not export).

% ESDU, SAMS, 2022

err_msg = [];

% Set up directories
moor_dir = [root_dir '\' M_id];
matlab_dir = [root_dir '\processing\matlab_ADCP'];
mat_dir  = [moor_dir '\mat'];
csv_dir  = [moor_dir '\csv\ADCP'];
if ~exist(csv_dir,'dir'); mkdir(csv_dir); end
eval(['addpath ' matlab_dir])

% Get list of ADCP files
eval(['cd ' mat_dir ])
m_str = [M_id '_ADCP_*.mat'];
fl_list = dir(m_str);

% If no files were found end function
if isempty(fl_list)
    err_msg = ' No ADCP data   found  for   this mooring';
    return
end

% Get number of weeks to average
M_s_mtime=datenum(start_date,'dd-mmm-yyyy');
M_e_mtime=datenum(end_date,'dd-mmm-yyyy');
no_weeks = ceil((M_e_mtime - M_s_mtime)/7);

% Extraction parameters:
eod = 48; % number of 30-minutes intervals in one day
WK_start = M_s_mtime;
WK_end=WK_start+7;

for k=1:no_weeks % number of weeks te moorings lasted / to run averages for
    
    for j=1:length(fl_list)
        
        % 1 - Get filename
        filename = fl_list(j).name;
        
        % 2-  Get timespan of data
        adcp=load(filename);
        adcp_s=min(adcp.mtime);
        adcp_e=max(adcp.mtime);
        mt=adcp.mtime';
        
        nbin=length(adcp.bin_depth); % number of bins
        
        % 3-  Find selected period in ADCP record:
        valid_adcp=find(adcp.mtime>=WK_start & adcp.mtime<=WK_end);
        mt_valid=adcp.mtime(valid_adcp);
        
        % Calculate number of days in adcp record for that week
        wk_days=(adcp.mtime(max(valid_adcp))-adcp.mtime(min(valid_adcp)));
        
        % Initialise final matrix
        % length X = number of days in  dataset * number of samples per day
        % (eod) + 2 (1 for header row and 1 for last row). length Y =
        % number of bins + 1 (for header column).
        wk_sv=zeros(floor(eod*wk_days+2),nbin+1);
        wk_w=zeros(floor(eod*wk_days+2),nbin+1);
        wk_u=zeros(floor(eod*wk_days+2),nbin+1);
        wk_v=zeros(floor(eod*wk_days+2),nbin+1);
        wk_spd=zeros(floor(eod*wk_days+2),nbin+1);
        wk_dir=zeros(floor(eod*wk_days+2),nbin+1);
        
        % Write column and row headers into final matrix
        % Calculate final timestamp
        last_sample_time=(length(wk_sv)-2)*2;
        wk_sv(:,1)=[-2:2:last_sample_time];
        wk_sv(1,:)=[0,repmat(adcp.bin_depth',1,1)];
        wk_w(:,1)=[-2:2:last_sample_time];
        wk_w(1,:)=[0,repmat(adcp.bin_depth',1,1)];
        wk_u(:,1)=[-2:2:last_sample_time];
        wk_u(1,:)=[0,repmat(adcp.bin_depth',1,1)];
        wk_v(:,1)=[-2:2:last_sample_time];
        wk_v(1,:)=[0,repmat(adcp.bin_depth',1,1)];
        wk_spd(:,1)=[-2:2:last_sample_time];
        wk_spd(1,:)=[0,repmat(adcp.bin_depth',1,1)];
        wk_dir(:,1)=[-2:2:last_sample_time];
        wk_dir(1,:)=[0,repmat(adcp.bin_depth',1,1)];
        
        % 5-  Extract data for this week
        wk_mt=mt(valid_adcp);
        wk_Sv2=adcp.Sv(:,valid_adcp);
        m_Sv=size(wk_Sv2);
        wk_w2=adcp.w(:,valid_adcp);
        m_w=size(wk_w2);
        wk_u2=adcp.u(:,valid_adcp);
        m_u=size(wk_u2);
        wk_v2=adcp.v(:,valid_adcp);
        m_v=size(wk_v2);
        
        % Calculate current magnitude and direction
        wk_dir2 = nan(size(wk_u2));
        wk_spd2 = nan(size(wk_u2));
        for jj=1:size(wk_u2,1)
            ind=find(~isnan(wk_u2(jj,:)));
            [wk_dir2(jj,ind),wk_spd2(jj,ind)]=cart2compass(wk_u2(jj,ind),wk_v2(jj,ind));
        end
        m_spd=size(wk_spd2);
        m_dir=size(wk_dir2);
        
        % 6-  Interpolate sv every 30min for each depth bin
        
        % Set interpolating times
        XI=[adcp.mtime(min(valid_adcp)):datenum(0,0,0,0,30,0):adcp.mtime(max(valid_adcp))];
        
        % Pre-allocate variables
        YISv=zeros(m_Sv(1),length(XI));
        YIw=zeros(m_w(1),length(XI));
        YIu=zeros(m_u(1),length(XI));
        YIv=zeros(m_v(1),length(XI));
        YIspd=zeros(m_spd(1),length(XI));
        YIdir=zeros(m_dir(1),length(XI));
        
        % Interpolate variables
        warning('off','MATLAB:interp1:NaNinY');
        for dbin=1:m_Sv(1)
            YISv(dbin,:) = interp1(wk_mt,wk_Sv2(dbin,:),XI);
        end
        for dbin=1:m_w(1)
            YIw(dbin,:) = interp1(wk_mt,wk_w2(dbin,:),XI);
        end
        for dbin=1:m_u(1)
            YIu(dbin,:) = interp1(wk_mt,wk_u2(dbin,:),XI);
        end
        for dbin=1:m_v(1)
            YIv(dbin,:) = interp1(wk_mt,wk_v2(dbin,:),XI);
        end
        for dbin=1:m_spd(1)
            YIspd(dbin,:) = interp1(wk_mt,wk_spd2(dbin,:),XI);
        end
        for dbin=1:m_dir(1)
            YIdir(dbin,:) = interp1(wk_mt,wk_dir2(dbin,:),XI);
        end
        
        % Save in output arrays (1st row and column = headers)
        wk_sv(2:length(YISv)'+1,(2:nbin+1))=YISv(:,:)';
        wk_w(2:length(YIw)'+1,(2:nbin+1))=YIw(:,:)';
        wk_u(2:length(YIu)'+1,(2:nbin+1))=YIu(:,:)';
        wk_v(2:length(YIv)'+1,(2:nbin+1))=YIv(:,:)';
        wk_spd(2:length(YIspd)'+1,(2:nbin+1))=YIspd(:,:)';
        wk_dir(2:length(YIdir)'+1,(2:nbin+1))=YIdir(:,:)';
        
        % Replace first column of file by epoch time
        wk_sv(:,1)=[0,posixtime(datetime(XI,'ConvertFrom','datenum'))];
        wk_w(:,1)=[0,posixtime(datetime(XI,'ConvertFrom','datenum'))];
        wk_u(:,1)=[0,posixtime(datetime(XI,'ConvertFrom','datenum'))];
        wk_v(:,1)=[0,posixtime(datetime(XI,'ConvertFrom','datenum'))];
        wk_spd(:,1)=[0,posixtime(datetime(XI,'ConvertFrom','datenum'))];
        wk_dir(:,1)=[0,posixtime(datetime(XI,'ConvertFrom','datenum'))];
        
        % Export to csv
        if f_csv == 1
            filename_out= [csv_dir '\' regexprep(filename,'.mat','')];
            if f_sv == 1
                eval(['dlmwrite(''' filename_out  '_sv_' datestr(WK_start,'yyyy-mm-dd') '.csv'',wk_sv,''delimiter'','','',''precision'',''%.5f'');']);
            end
            if f_vv == 1
                eval(['dlmwrite(''' filename_out  '_w_' datestr(WK_start,'yyyy-mm-dd') '.csv'',wk_w,''delimiter'','','',''precision'',''%.5f'');']);
            end
            if f_u == 1
                eval(['dlmwrite(''' filename_out  '_u_' datestr(WK_start,'yyyy-mm-dd') '.csv'',wk_u,''delimiter'','','',''precision'',''%.5f'');']);
            end
            if f_v == 1
                eval(['dlmwrite(''' filename_out  '_v_' datestr(WK_start,'yyyy-mm-dd') '.csv'',wk_v,''delimiter'','','',''precision'',''%.5f'');']);
            end
            if f_spd == 1
                eval(['dlmwrite(''' filename_out  '_hv_' datestr(WK_start,'yyyy-mm-dd') '.csv'',wk_spd,''delimiter'','','',''precision'',''%.5f'');']);
            end
            if f_dir == 1
                eval(['dlmwrite(''' filename_out  '_dir_' datestr(WK_start,'yyyy-mm-dd') '.csv'',wk_dir,''delimiter'','','',''precision'',''%.5f'');']);
            end
        end
                
        clear filename adcp wk_*
        
    end
    
    % Move to following week
    WK_start= WK_end;
    WK_end=WK_start+7;
           
end
