function err_msg = plot_adcp_data_weekly(root_dir,M_id,inst_top,inst_bot,...
    surf_mask,start_date,end_date,f_sv,f_uv,f_sd,test_run)

% ADCP data script to interpolate data in 30-minute intervals and create
% contour plots.
% The ADCP data should be in mat format, processed using the SAMS ADCP
% backscatter gui toolbox (inc. rdradcp.m function  by R. Pawlowicz) and
% follow the KROP file naming conventsions and folder structure.
% Input:
%   - root_dir = Root directory for KROP folder structure (i.e. the folder
%               containing all the individual moorings subfolders, and the
%               processing folder)
%   - M_id = mooring ID (e.g. RF_06_07)
%   - inst_top = top instrument filname (string)
%   - inst_bot = bottom instrument filename (string)
%   - mask_depth = meters to mask at the surface, in case of noisy data (float)
%   - start_date = mooring deployment date (or date to start plot)
%   - end_date = mooring recovery date  (or date to end plot)
%   - f_svw/uv/sv = flags for which variables to plot (1 = export, 0 = do not export)
%   - test_run = flag to simply view plot(s). 0 to close and save figures, 1 to leave open and not save

% ESDU, SAMS, 2022

% Set empty variables (so that 'keep' function still works even if those
% variables / plots don't exist)
err_msg = [];
n_sv = 0; n_uv = 0; n_sd = 0;
sv_fig = []; uv_fig = []; sd_fig = [];
plot1 = []; plot2 = []; plot3 = []; plot4 = []; plot5 = []; plot6 = [];

% Set up directories
moor_dir = [root_dir '\' M_id];
matlab_dir = [root_dir '\processing\matlab_ADCP'];
mat_dir  = [moor_dir '\mat'];
plot_dir  = [moor_dir '\plots\ADCP'];
if ~exist(plot_dir,'dir'); mkdir(plot_dir); end
eval(['addpath ' matlab_dir])
eval(['addpath ' matlab_dir '\cmocean'])

% Setup file list
if regexp(inst_bot,'n/a')
    fl_list = {inst_top};
elseif regexp(inst_top,'n/a')
    fl_list = {inst_bot};
else
    fl_list = {inst_top inst_bot};
end

% Check if files exist, if not end function
eval(['cd ' mat_dir ])
for ll = 1:length(fl_list)
    if ~exist(fl_list{ll})
        err_msg = '                                              File(s) not found';
        return
    end
end
eval(['cd ' matlab_dir ])

% Get number of weeks to average
M_s_mtime=datenum(start_date,'dd-mmm-yyyy');
M_e_mtime=datenum(end_date,'dd-mmm-yyyy');
no_weeks = ceil((M_e_mtime - M_s_mtime)/7);

% Extraction parameters:
eod = 48; % number of 30-minutes intervals in one day
WK_start = M_s_mtime;
WK_end=WK_start+7;

%%
for k=1:no_weeks % number of weeks the moorings lasted / to run averages for
    
    % Set up plots
    if f_sv ==1
        sv_fig=figure('units','normalized','Position',[0.01,0.05,0.98,0.87]);
        set(0,'defaultaxesfontsize',9);
        hold on
        clf
        n_sv = get(sv_fig,'Number');
    end
    if f_uv ==1
        uv_fig=figure('units','normalized','Position',[0.01,0.05,0.98,0.87]);
        set(0,'defaultaxesfontsize',9);
        hold on
        clf
        n_uv = get(uv_fig,'Number');
    end
    if f_sd ==1
        sd_fig=figure('units','normalized','Position',[0.01,0.05,0.98,0.87]);
        set(0,'defaultaxesfontsize',9);
        hold on
        clf
        n_sd = get(sd_fig,'Number');
    end
    
    %%
    for j=1:length(fl_list)
        
        % 1 - Get filename
        filename = [mat_dir '\' fl_list{j}];
        
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
                
        % Plot
        
        % For plotting colorscale we need to "max out" values falling
        % outside the set color scale limits
        ind_sv1 = find(wk_sv<=-90);
        if ~isempty(ind_sv1)
            wk_sv(ind_sv1)=-89.99999;
        end
        ind_sv2 = find(wk_sv>=-55);
        if ~isempty(ind_sv2)
            wk_sv(ind_sv2)=-55.000001;
        end
        
        ind_w1 = find(wk_w<=-0.0225);
        if ~isempty(ind_w1)
            wk_w(ind_w1)=-0.02249999;
        end
        ind_w2 = find(wk_w>=0.0225);
        if ~isempty(ind_w2)
            wk_w(ind_w2)=0.02249999;
        end
        
        % Plot data
        
        if f_sv ==1
            
            figure(n_sv)
            
            plot1=subplot(4,1,1:2);
            h(1)=imagesc(XI,-adcp.bin_depth,wk_sv((2:length(wk_sv)),(2:nbin+1))');
            shading flat
            hold on
            shading('flat')
            datetick
            
            plot2=subplot(4,1,3:4);
            h(2)=imagesc(XI,-adcp.bin_depth,wk_w((2:length(wk_sv)),(2:nbin+1))');
            hold on
            shading('flat')
            datetick
            
        end
        
        if f_uv ==1
            
            figure(n_uv)
            
            plot3=subplot(4,1,1:2);
            h(3)=imagesc(XI,-adcp.bin_depth,wk_u((2:length(wk_u)),(2:nbin+1))');
            hold on
            shading('flat')
            datetick
            
            plot4=subplot(4,1,3:4);
            h(4)=imagesc(XI,-adcp.bin_depth,wk_v((2:length(wk_v)),(2:nbin+1))');
            hold on
            shading('flat')
            datetick
            
        end
        
        if f_sd ==1
            
            figure(n_sd)
            
            plot5=subplot(4,1,1:2);
            h(3)=imagesc(XI,-adcp.bin_depth,wk_dir((2:length(wk_dir)),(2:nbin+1))');
            hold on
            shading('flat')
            datetick
            
            plot6=subplot(4,1,3:4);
            h(4)=imagesc(XI,-adcp.bin_depth,wk_spd((2:length(wk_spd)),(2:nbin+1))');
            hold on
            shading('flat')
            datetick
            
        end
        
        keep M_id inst_top inst_bot fl_list surf_mask start_date end_date...
            f_sv f_uv f_sd test_run n_sv n_uv n_sd WK_start WK_end eod j k h...
            root_dir moor_dir plot_dir mat_dir sv_fig uv_fig sd_fig...
            plot1 plot2 plot3 plot4 plot5 plot6 err_msg
        
    end
    
    %%
    % Finalise plots
    
    if f_sv ==1
        
        figure(n_sv)
        
        cmap2=cmocean('balance');
        cmap1=jet(size(cmap2,1));
        cmap = [cmap1;cmap2];
        
        subplot(4,1,1:2)
        hold on
        colormap(cmap)
        cb1=colorbar;
        caxis([-90 -20])
        set(cb1,'YLim',[-90 -55])
        xlabel(cb1,'S_v (db)','fontsize',7);
        datetick
        grid on
        set(gca,'ylim',[-240 0],'ydir','normal','fontsize',7)
        set(gca,'xtick',(WK_start:datenum(0,0,1,0,0,0'):WK_end))
        datetick('x','dd/mm/yy','keepticks')
        ylabel('Depth (m)','fontsize',7);
        xlim([WK_start WK_end]);
        title([M_id ': Backscatter'],'interpreter','none','fontsize',9);
        % Hide top bin (bad data)
        rectangle('Position',[WK_start,-surf_mask,(WK_end-WK_start),surf_mask],'FaceColor',rgb('Silver'),'LineStyle','none')
        
        subplot(4,1,3:4)
        hold on
        cb2=colorbar;
        caxis([-0.0225-0.045 0.0225])
        set(cb2,'YLim',[-0.0225 0.0225])
        xlabel(cb2,'VV (m/s)','fontsize',7);
        datetick
        grid on
        set(gca,'ylim',[-240 0],'ydir','normal','fontsize',7)
        set(gca,'xtick',(WK_start:datenum(0,0,1,0,0,0'):WK_end))
        datetick('x','dd/mm/yy','keepticks')
        xlabel('Date (tick at 00:00 UTC)','fontsize',7);
        ylabel('Depth (m)','fontsize',7);
        xlim([WK_start WK_end]);
        title([M_id ': Vertical velocity'],'interpreter','none','fontsize',9);
        %Hide top bin (bad data)
        rectangle('Position',[WK_start,-surf_mask,(WK_end-WK_start),surf_mask],'FaceColor',rgb('Silver'),'LineStyle','none')
        
        % Save figure
        colormap(cmap)
        if test_run==0
            fig_filename=[plot_dir '\' M_id '_ADCP_svw_' datestr(WK_start,'yyyy-mm-dd') '.png'];
            saveas(sv_fig,fig_filename);
            close(sv_fig)
        end
        
    end
    
    %%
    if f_uv ==1
        
        figure(n_uv)
        
        subplot(4,1,1:2)
        caxis([-0.35 0.35])
        cb3=colorbar;
        colormap(cmocean('balance'))
        xlabel(cb3,'U (m/s)','fontsize',7);
        datetick
        grid on
        set(gca,'ylim',[-240 0],'ydir','normal','fontsize',7)
        set(gca,'xtick',(WK_start:datenum(0,0,1,0,0,0'):WK_end))
        datetick('x','dd/mm/yy','keepticks')
        ylabel('Depth (m)','fontsize',7);
        xlim([WK_start WK_end]);
        title([M_id ': Eastward velocity'],'interpreter','none','fontsize',9);
        % Hide top bin (bad data)
        rectangle('Position',[WK_start,-surf_mask,(WK_end-WK_start),surf_mask],'FaceColor',rgb('Silver'),'LineStyle','none')
        
        subplot(4,1,3:4)
        caxis([-0.35 0.35])
        cb4=colorbar;
        colormap(cmocean('balance'))
        xlabel(cb4,'V (m/s)','fontsize',7);
        datetick
        grid on
        set(gca,'ylim',[-240 0],'ydir','normal','fontsize',7)
        set(gca,'xtick',(WK_start:datenum(0,0,1,0,0,0'):WK_end))
        datetick('x','dd/mm/yy','keepticks')
        xlabel('Date (tick at 00:00 UTC)','fontsize',7);
        ylabel('Depth (m)','fontsize',7);
        xlim([WK_start WK_end]);
        title([M_id ': Northward velocity'],'interpreter','none','fontsize',9);
        %Hide top bin (bad data)
        rectangle('Position',[WK_start,-surf_mask,(WK_end-WK_start),surf_mask],'FaceColor',rgb('Silver'),'LineStyle','none')
        
        % Save figure
        if test_run==0
            fig2_filename=[plot_dir '\' M_id '_ADCP_uv_' datestr(WK_start,'yyyy-mm-dd') '.png'];
            saveas(uv_fig,fig2_filename);
            close(uv_fig)
        end
        
    end
    
    %%
    if f_sd == 1
        
        figure(n_sd)

        subplot(4,1,1:2)
        colormap(plot5,hsv)
        cb5=colorbar;
        caxis([0 360])
        xlabel(cb5,'Direction (^o)','fontsize',7);
        datetick
        grid on
        set(gca,'ylim',[-240 0],'ydir','normal','fontsize',7)
        set(gca,'xtick',(WK_start:datenum(0,0,1,0,0,0'):WK_end))
        datetick('x','dd/mm/yy','keepticks')
        ylabel('Depth (m)','fontsize',7);
        xlim([WK_start WK_end]);
        title([M_id ': Current direction'],'interpreter','none','fontsize',9);
        % Hide top bin (bad data)
        rectangle('Position',[WK_start,-surf_mask,(WK_end-WK_start),surf_mask],'FaceColor',rgb('Silver'),'LineStyle','none')
        
        subplot(4,1,3:4)
        caxis([0 0.25])
        cb6=colorbar;
        colormap(plot6,parula)
        xlabel(cb6,'Speed (m/s)','fontsize',7);
        datetick
        grid on
        set(gca,'ylim',[-240 0],'ydir','normal','fontsize',7)
        set(gca,'xtick',(WK_start:datenum(0,0,1,0,0,0'):WK_end))
        datetick('x','dd/mm/yy','keepticks')
        xlabel('Date (tick at 00:00 UTC)','fontsize',7);
        ylabel('Depth (m)','fontsize',7);
        xlim([WK_start WK_end]);
        title([M_id ': Current speed'],'interpreter','none','fontsize',9);
        %Hide top bin (bad data)
        rectangle('Position',[WK_start,-surf_mask,(WK_end-WK_start),surf_mask],'FaceColor',rgb('Silver'),'LineStyle','none')
        
        % Save figure
        if test_run==0
            fig3_filename=[plot_dir '\' M_id '_ADCP_currents_' datestr(WK_start,'yyyy-mm-dd') '.png'];
            saveas(sd_fig,fig3_filename);
            close(sd_fig)
        end
    end
    
    
    % Move to following week
    WK_start= WK_end;
    WK_end=WK_start+7;
    
end


