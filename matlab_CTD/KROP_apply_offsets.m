function KROP_apply_offsets(info_file)

% Apply offsets to sensors
% Those offsets will have been be determined by the user prior to running
% the script (e.g. with intercomparison CTD casts) and offsets entered in
% the mooring info_file.
% ESDU, SAMS, 2019

% Note: currently there are sections of code for each intrument (clearer / 
% easier to write it that way), but in future versions this script could be 
% improved by merging the individual bits of code and make it applicable to
% all instrument types. 

close all
load(info_file)

% Load mooring data
mat_fl = [d_mat '\' mooring_id '_CTD.mat'];
load(mat_fl)

% Prepare output structure
RAW3 = RAW2;


%% Add offsets to SBE16p
if exist('sbe16p_num','var')
    if sbe16p_num >0
        
        % Loop through each instrument
        for j = 1:sbe16p_num
            
            % Get variables
            inst = ['SBE16p_' sbe16p_sn{j}];
            eval(['DATA_IN=RAW2.' inst ';']);
            DATA_OUT = DATA_IN;
            
            % Check if offsets are non-zero
            if isnan(off_sbe16p_t(j))
                
                msg = [inst 'No intercomparison data'];
                disp(msg)
                
            else
                % Check if offsets are non-zero
                if off_sbe16p_t(j) ~=0 || off_sbe16p_c(j) ~=0
                    msg = [inst ' offsets T = ' num2str(off_sbe16p_t(j)) ' ; C = ' num2str(off_sbe16p_t(j)) ' : applying offsets'];
                    disp(msg)
                    
                    % Add offsets
                    if ~isnan(off_sbe16p_t(j))
                        DATA_OUT.temp = DATA_IN.temp + off_sbe16p_t(j);
                    end
                    if ~isnan(off_sbe16p_c(j))
                        DATA_OUT.cond = DATA_IN.cond + off_sbe16p_c(j);
                    end
                    
                    % Re-calculate salinity and sigma theta
                    DATA_OUT.sal = sw_salt(DATA_OUT.cond/sw_c3515,DATA_OUT.temp,DATA_OUT.pres);
                    DATA_OUT.sigmatheta = sw_pden(DATA_OUT.sal,DATA_OUT.temp,DATA_OUT.pres,0)-1000;
                    
                    % Plot result
                    fig = figure('units','normalized','Position',[0.01,0.05,0.98,0.87]);
                    
                    p1=subplot(4,1,1);
                    hold on
                    plot(DATA_IN.mtime,DATA_IN.temp,'*-','color',[.6,.6,.6],'markersize',5);
                    plot(DATA_OUT.mtime,DATA_OUT.temp,'g*-','markersize',2)
                    grid on
                    datetick('x',12)
                    ylabel('Temp (^oC)','fontsize',7)
                    set(gca,'fontsize',7)
                    lg=legend('Raw','Offset','location','EastOutside');
                    set(lg,'fontsize',7)
                    title([mooring_id '  ' inst],'interpreter','none','fontsize',10)
                    
                    p2=subplot(4,1,2);
                    hold on
                    plot(DATA_IN.mtime,DATA_IN.cond,'*-','color',[.6,.6,.6],'markersize',5)
                    plot(DATA_OUT.mtime,DATA_OUT.cond,'g*-','markersize',2)
                    grid on
                    datetick('x',12)
                    ylabel('Cond (mS/cm)','fontsize',7)
                    set(gca,'fontsize',7)
                    lg=legend('Raw','Offset','location','EastOutside');
                    set(lg,'fontsize',7)
                    
                    p3=subplot(4,1,3);
                    hold on
                    plot(DATA_IN.mtime,DATA_IN.sal,'*-','color',[.6,.6,.6],'markersize',5)
                    plot(DATA_OUT.mtime,DATA_OUT.sal,'g*-','markersize',2)
                    grid on
                    datetick('x',12)
                    ylabel('Salinity (psu)','fontsize',7)
                    set(gca,'fontsize',7)
                    lg=legend('Raw','Offset','location','EastOutside');
                    set(lg,'fontsize',7)
                    
                    p4=subplot(4,1,4);
                    hold on
                    plot(DATA_IN.mtime,DATA_IN.sigmatheta,'*-','color',[.6,.6,.6],'markersize',5)
                    plot(DATA_OUT.mtime,DATA_OUT.sigmatheta,'g*-','markersize',2)
                    grid on
                    datetick('x',12)
                    ylabel('Sig-theta (kg/m^3)','fontsize',7)
                    set(gca,'fontsize',7)
                    lg=legend('Raw','Offset','location','EastOutside');
                    set(lg,'fontsize',7)
                    xlabel('Date','fontsize',7)
                    
                    linkaxes([p1 p2 p3 p4],'x')
                    
                    % Save figure
                    fig_nm = [d_plot_o '\offset_' mooring_id '_' inst];
                    saveas(fig,fig_nm,'png')
                    
                    % Save data
                    eval(['RAW3.' inst '=DATA_OUT;'])
                    
                else
                    msg = [inst ' offsets are zero, no data adjustment'];
                    disp(msg)
                    
                end
            end
            
            clear inst DATA_IN DATA_OUT fig
            
        end
        
        clear j
        
    end
end


%% Add offsets to SBE19p
if exist('sbe19p_num','var')
    if sbe19p_num >0
        
        % Loop through each instrument
        for j = 1:sbe19p_num
            
            % Get variables
            inst = ['SBE19p_' sbe19p_sn{j}];
            eval(['DATA_IN=RAW2.' inst ';']);
            DATA_OUT = DATA_IN;
            
            % Check if offsets are non-zero
            if isnan(off_sbe19p_t(j))
                
                msg = [inst 'No intercomparison data'];
                disp(msg)
                
            else
                % Check if offsets are non-zero
                if off_sbe19p_t(j) ~=0 || off_sbe19p_c(j) ~=0
                    msg = [inst ' offsets T = ' num2str(off_sbe19p_t(j)) ' ; C = ' num2str(off_sbe19p_t(j)) ' : applying offsets'];
                    disp(msg)
                    
                    % Add offsets
                    if ~isnan(off_sbe19p_t(j))
                        DATA_OUT.temp = DATA_IN.temp + off_sbe19p_t(j);
                    end
                    if ~isnan(off_sbe19p_c(j))
                        DATA_OUT.cond = DATA_IN.cond + off_sbe19p_c(j);
                    end
                    
                    % Re-calculate salinity and sigma theta
                    DATA_OUT.sal = sw_salt(DATA_OUT.cond/sw_c3515,DATA_OUT.temp,DATA_OUT.pres);
                    DATA_OUT.sigmatheta = sw_pden(DATA_OUT.sal,DATA_OUT.temp,DATA_OUT.pres,0)-1000;
                    
                    % Plot result
                    fig = figure('units','normalized','Position',[0.01,0.05,0.98,0.87]);
                    
                    p1=subplot(4,1,1);
                    hold on
                    plot(DATA_IN.mtime,DATA_IN.temp,'*-','color',[.6,.6,.6],'markersize',5);
                    plot(DATA_OUT.mtime,DATA_OUT.temp,'g*-','markersize',2)
                    grid on
                    datetick('x',12)
                    ylabel('Temp (^oC)','fontsize',7)
                    set(gca,'fontsize',7)
                    lg=legend('Raw','Offset','location','EastOutside');
                    set(lg,'fontsize',7)
                    title([mooring_id '  ' inst],'interpreter','none','fontsize',10)
                    
                    p2=subplot(4,1,2);
                    hold on
                    plot(DATA_IN.mtime,DATA_IN.cond,'*-','color',[.6,.6,.6],'markersize',5)
                    plot(DATA_OUT.mtime,DATA_OUT.cond,'g*-','markersize',2)
                    grid on
                    datetick('x',12)
                    ylabel('Cond (mS/cm)','fontsize',7)
                    set(gca,'fontsize',7)
                    lg=legend('Raw','Offset','location','EastOutside');
                    set(lg,'fontsize',7)
                    
                    p3=subplot(4,1,3);
                    hold on
                    plot(DATA_IN.mtime,DATA_IN.sal,'*-','color',[.6,.6,.6],'markersize',5)
                    plot(DATA_OUT.mtime,DATA_OUT.sal,'g*-','markersize',2)
                    grid on
                    datetick('x',12)
                    ylabel('Salinity (psu)','fontsize',7)
                    set(gca,'fontsize',7)
                    lg=legend('Raw','Offset','location','EastOutside');
                    set(lg,'fontsize',7)
                    
                    p4=subplot(4,1,4);
                    hold on
                    plot(DATA_IN.mtime,DATA_IN.sigmatheta,'*-','color',[.6,.6,.6],'markersize',5)
                    plot(DATA_OUT.mtime,DATA_OUT.sigmatheta,'g*-','markersize',2)
                    grid on
                    datetick('x',12)
                    ylabel('Sig-theta (kg/m^3)','fontsize',7)
                    set(gca,'fontsize',7)
                    lg=legend('Raw','Offset','location','EastOutside');
                    set(lg,'fontsize',7)
                    xlabel('Date','fontsize',7)
                    
                    linkaxes([p1 p2 p3 p4],'x')
                    
                    % Save figure
                    fig_nm = [d_plot_o '\offset_' mooring_id '_' inst];
                    saveas(fig,fig_nm,'png')
                    
                    % Save data
                    eval(['RAW3.' inst '=DATA_OUT;'])
                    
                else
                    msg = [inst ' offsets are zero, no data adjustment'];
                    disp(msg)
                    
                end
            end
            
            clear inst DATA_IN DATA_OUT fig
            
        end
        
        clear j
        
    end
end


%% Add offsets to Hydrocat
if exist('hcat_num','var')
    if hcat_num >0
        
        % Loop through each instrument
        for j = 1:hcat_num
            
            % Get variables
            inst = ['HCAT_' hcat_sn{j}];
            eval(['DATA_IN=RAW2.' inst ';']);
            DATA_OUT = DATA_IN;
            
            % Check if offsets are non-zero
            if isnan(off_hcat_t(j))
                
                msg = [inst 'No intercomparison data'];
                disp(msg)
                
            else
                % Check if offsets are non-zero
                if off_hcat_t(j) ~=0 || off_hcat_c(j) ~=0
                    msg = [inst ' offsets T = ' num2str(off_hcat_t(j)) ' ; C = ' num2str(off_hcat_t(j)) ' : applying offsets'];
                    disp(msg)
                    
                    % Add offsets
                    if ~isnan(off_hcat_t(j))
                        DATA_OUT.temp = DATA_IN.temp + off_hcat_t(j);
                    end
                    if ~isnan(off_hcat_c(j))
                        DATA_OUT.cond = DATA_IN.cond + off_hcat_c(j);
                    end
                    
                    % Re-calculate salinity and sigma theta
                    DATA_OUT.sal = sw_salt(DATA_OUT.cond/sw_c3515,DATA_OUT.temp,DATA_OUT.pres);
                    DATA_OUT.sigmatheta = sw_pden(DATA_OUT.sal,DATA_OUT.temp,DATA_OUT.pres,0)-1000;
                    
                    % Plot result
                    fig = figure('units','normalized','Position',[0.01,0.05,0.98,0.87]);
                    
                    p1=subplot(4,1,1);
                    hold on
                    plot(DATA_IN.mtime,DATA_IN.temp,'*-','color',[.6,.6,.6],'markersize',5);
                    plot(DATA_OUT.mtime,DATA_OUT.temp,'g*-','markersize',2)
                    grid on
                    datetick('x',12)
                    ylabel('Temp (^oC)','fontsize',7)
                    set(gca,'fontsize',7)
                    lg=legend('Raw','Offset','location','EastOutside');
                    set(lg,'fontsize',7)
                    title([mooring_id '  ' inst],'interpreter','none','fontsize',10)
                    
                    p2=subplot(4,1,2);
                    hold on
                    plot(DATA_IN.mtime,DATA_IN.cond,'*-','color',[.6,.6,.6],'markersize',5)
                    plot(DATA_OUT.mtime,DATA_OUT.cond,'g*-','markersize',2)
                    grid on
                    datetick('x',12)
                    ylabel('Cond (mS/cm)','fontsize',7)
                    set(gca,'fontsize',7)
                    lg=legend('Raw','Offset','location','EastOutside');
                    set(lg,'fontsize',7)
                    
                    p3=subplot(4,1,3);
                    hold on
                    plot(DATA_IN.mtime,DATA_IN.sal,'*-','color',[.6,.6,.6],'markersize',5)
                    plot(DATA_OUT.mtime,DATA_OUT.sal,'g*-','markersize',2)
                    grid on
                    datetick('x',12)
                    ylabel('Salinity (psu)','fontsize',7)
                    set(gca,'fontsize',7)
                    lg=legend('Raw','Offset','location','EastOutside');
                    set(lg,'fontsize',7)
                    
                    p4=subplot(4,1,4);
                    hold on
                    plot(DATA_IN.mtime,DATA_IN.sigmatheta,'*-','color',[.6,.6,.6],'markersize',5)
                    plot(DATA_OUT.mtime,DATA_OUT.sigmatheta,'g*-','markersize',2)
                    grid on
                    datetick('x',12)
                    ylabel('Sig-theta (kg/m^3)','fontsize',7)
                    set(gca,'fontsize',7)
                    lg=legend('Raw','Offset','location','EastOutside');
                    set(lg,'fontsize',7)
                    xlabel('Date','fontsize',7)
                    
                    linkaxes([p1 p2 p3 p4],'x')
                    
                    % Save figure
                    fig_nm = [d_plot_o '\offset_' mooring_id '_' inst];
                    saveas(fig,fig_nm,'png')
                    
                    % Save data
                    eval(['RAW3.' inst '=DATA_OUT;'])
                    
                else
                    msg = [inst ' offsets are zero, no data adjustment'];
                    disp(msg)
                    
                end
            end
            
            clear inst DATA_IN DATA_OUT fig
            
        end
        
        clear j
        
    end
end


%% Add offsets to SBE37
if exist('sbe37_num','var')
    if sbe37_num >0
        
        % Loop through each instrument
        for j = 1:sbe37_num
            
            % Get variables
            inst = ['SBE37_' sbe37_sn{j}];
            eval(['DATA_IN=RAW2.' inst ';']);
            DATA_OUT = DATA_IN;
            
            % Check if offsets are non-zero
            if isnan(off_sbe37_t(j))
                
                msg = [inst 'No intercomparison data'];
                disp(msg)
                
            else
                % Check if offsets are non-zero
                if off_sbe37_t(j) ~=0 || off_sbe37_c(j) ~=0
                    msg = [inst ' offsets T = ' num2str(off_sbe37_t(j)) ' ; C = ' num2str(off_sbe37_t(j)) ' : applying offsets'];
                    disp(msg)
                    
                    % Add offsets
                    if ~isnan(off_sbe37_t(j))
                        DATA_OUT.temp = DATA_IN.temp + off_sbe37_t(j);
                    end
                    if ~isnan(off_sbe37_c(j))
                        DATA_OUT.cond = DATA_IN.cond + off_sbe37_c(j);
                    end
                    
                    % Re-calculate salinity and sigma theta
                    DATA_OUT.sal = sw_salt(DATA_OUT.cond/sw_c3515,DATA_OUT.temp,DATA_OUT.pres);
                    DATA_OUT.sigmatheta = sw_pden(DATA_OUT.sal,DATA_OUT.temp,DATA_OUT.pres,0)-1000;
                    
                    % Plot result
                    fig = figure('units','normalized','Position',[0.01,0.05,0.98,0.87]);
                    
                    p1=subplot(4,1,1);
                    hold on
                    plot(DATA_IN.mtime,DATA_IN.temp,'*-','color',[.6,.6,.6],'markersize',5);
                    plot(DATA_OUT.mtime,DATA_OUT.temp,'g*-','markersize',2)
                    grid on
                    datetick('x',12)
                    ylabel('Temp (^oC)','fontsize',7)
                    set(gca,'fontsize',7)
                    lg=legend('Raw','Offset','location','EastOutside');
                    set(lg,'fontsize',7)
                    title([mooring_id '  ' inst],'interpreter','none','fontsize',10)
                    
                    p2=subplot(4,1,2);
                    hold on
                    plot(DATA_IN.mtime,DATA_IN.cond,'*-','color',[.6,.6,.6],'markersize',5)
                    plot(DATA_OUT.mtime,DATA_OUT.cond,'g*-','markersize',2)
                    grid on
                    datetick('x',12)
                    ylabel('Cond (mS/cm)','fontsize',7)
                    set(gca,'fontsize',7)
                    lg=legend('Raw','Offset','location','EastOutside');
                    set(lg,'fontsize',7)
                    
                    p3=subplot(4,1,3);
                    hold on
                    plot(DATA_IN.mtime,DATA_IN.sal,'*-','color',[.6,.6,.6],'markersize',5)
                    plot(DATA_OUT.mtime,DATA_OUT.sal,'g*-','markersize',2)
                    grid on
                    datetick('x',12)
                    ylabel('Salinity (psu)','fontsize',7)
                    set(gca,'fontsize',7)
                    lg=legend('Raw','Offset','location','EastOutside');
                    set(lg,'fontsize',7)
                    
                    p4=subplot(4,1,4);
                    hold on
                    plot(DATA_IN.mtime,DATA_IN.sigmatheta,'*-','color',[.6,.6,.6],'markersize',5)
                    plot(DATA_OUT.mtime,DATA_OUT.sigmatheta,'g*-','markersize',2)
                    grid on
                    datetick('x',12)
                    ylabel('Sig-theta (kg/m^3)','fontsize',7)
                    set(gca,'fontsize',7)
                    lg=legend('Raw','Offset','location','EastOutside');
                    set(lg,'fontsize',7)
                    xlabel('Date','fontsize',7)
                    
                    linkaxes([p1 p2 p3 p4],'x')
                    
                    % Save figure
                    fig_nm = [d_plot_o '\offset_' mooring_id '_' inst];
                    saveas(fig,fig_nm,'png')
                    
                    % Save data
                    eval(['RAW3.' inst '=DATA_OUT;'])
                    
                else
                    msg = [inst ' offsets are zero, no data adjustment'];
                    disp(msg)
                    
                end
            end
            
            clear inst DATA_IN DATA_OUT fig
            
        end
        
        clear j
        
    end
end

%% Add offsets to SBE56
if exist('sbe56_num','var')
    if sbe56_num >0
        
        % Loop through each instrument
        for j = 1:sbe56_num
            
            % Get variables
            inst = ['SBE56_' sbe56_sn{j}];
            eval(['DATA_IN=RAW2.' inst ';']);
            DATA_OUT = DATA_IN;
            
            % Check if offsets are non-zero
            if isnan(off_sbe56_t(j))
                
                msg = [inst 'No intercomparison data'];
                disp(msg)
                
            else
                % Check if offsets are non-zero
                if off_sbe56_t(j) ~=0
                    msg = [inst ' offset T = ' num2str(off_sbe56_t(j)) ' : applying offset'];
                    disp(msg)
                    
                    % Add offset
                    DATA_OUT.temp = DATA_IN.temp + off_sbe56_t(j);
                    
                    % Plot result
                    fig = figure('units','normalized','Position',[0.01,0.05,0.98,0.87]);
                    
                    p1=subplot(4,1,1);
                    hold on
                    plot(DATA_IN.mtime,DATA_IN.temp,'*-','color',[.6,.6,.6],'markersize',5);
                    plot(DATA_OUT.mtime,DATA_OUT.temp,'g*-','markersize',2)
                    grid on
                    datetick('x',12)
                    ylabel('Temp (^oC)','fontsize',7)
                    set(gca,'fontsize',7)
                    lg=legend('Raw','Offset','location','EastOutside');
                    set(lg,'fontsize',7)
                    title([mooring_id '  ' inst],'interpreter','none','fontsize',10)
                    
                    % Save figure
                    fig_nm = [d_plot_o '\offset_' mooring_id '_' inst];
                    saveas(fig,fig_nm,'png')
                    
                    % Save data
                    eval(['RAW3.' inst '=DATA_OUT;'])
                    
                else
                    msg = [inst ' offset is zero, no data adjustment'];
                    disp(msg)
                    
                end
            end
            clear inst DATA_IN DATA_OUT fig
            
        end
        
        clear j
    end
end


%% Add offsets to Minilogs
if exist('ml_num','var')
    if ml_num >0
        
        % Loop through each instrument
        for j = 1:ml_num
            
            % Get variables
            inst = ['ML_' ml_sn{j}];
            eval(['DATA_IN=RAW2.' inst ';']);
            DATA_OUT = DATA_IN;
            
            % Check if offsets are non-zero
            if isnan(off_ml_t(j))
                
                msg = [inst 'No intercomparison data'];
                disp(msg)
                
            else
                if off_ml_t(j) ~=0
                    msg = [inst ' offset T = ' num2str(off_ml_t(j)) ' : applying offset'];
                    disp(msg)
                    
                    % Add offset
                    DATA_OUT.temp = DATA_IN.temp + off_ml_t(j);
                    
                    % Plot result
                    fig = figure('units','normalized','Position',[0.01,0.05,0.98,0.87]);
                    
                    p1=subplot(4,1,1);
                    hold on
                    plot(DATA_IN.mtime,DATA_IN.temp,'*-','color',[.6,.6,.6],'markersize',5);
                    plot(DATA_OUT.mtime,DATA_OUT.temp,'g*-','markersize',2)
                    grid on
                    datetick('x',12)
                    ylabel('Temp (^oC)','fontsize',7)
                    set(gca,'fontsize',7)
                    lg=legend('Raw','Offset','location','EastOutside');
                    set(lg,'fontsize',7)
                    title([mooring_id '  ' inst],'interpreter','none','fontsize',10)
                    
                    % Save figure
                    fig_nm = [d_plot_o '\offset_' mooring_id '_' inst];
                    saveas(fig,fig_nm,'png')
                    
                    % Save data
                    eval(['RAW3.' inst '=DATA_OUT;'])
                    
                else
                    msg = [inst ' offset is zero, no data adjustment'];
                    disp(msg)
                    
                end
            end
            
            clear inst DATA_IN DATA_OUT fig
            
        end
        
        clear j
    end
end


%% Save data
save(mat_fl,'RAW','RAW2','RAW3');
