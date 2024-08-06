function KROP_crop(info_file)

% Cut data to mooring deployment and recovery time
% ESDU, SAMS, Mar 19

close all
load(info_file)

% Load raw data
mat_fl = [d_mat '\' mooring_id '_CTD.mat'];
load(mat_fl)
% Get list of instruments in file
inst_list = fieldnames(RAW);

% Loop through each instrument and cut all variables to start and end time
for j=1:length(inst_list)
    
    inst = inst_list(j);
    
    % Find mtime index
    eval(['mtime = RAW.' inst{:} '.mtime;'])
    in_water = find(mtime>=start_date-1/24/60 & mtime<=end_date+1/24/60); % add an extra minute eitehr side to allow for slightly out-of-sync instruments
    
    % Get list of variables for that instrument
    eval(['var_list = fieldnames(RAW.' inst{:} ');'])
    
        % Crop data
    for k=1:length(var_list)       
            eval(['RAW2.' inst{:} '.' var_list{k} '=RAW.' inst{:} '.' var_list{k} '(in_water);'])            
            % eval(['RAW2.' inst{:} '.nominal_depth=RAW.' inst{:} '.nominal_depth;'])        
    end
    
    % Plot
    eval(['data_raw=RAW.' inst{:} ';']);
    eval(['data_crop=RAW2.' inst{:} ';']);
    
    fig=figure(j);
    set(fig,'units','normalized','Position',[0.01,0.05,0.98,0.87])
    
    subplot(3,1,1)
    hold on;
    if isfield(data_raw,'depth')
        plot(data_raw.mtime,data_raw.depth,'*-','color',[.6,.6,.6],'markersize',5)
        plot(data_crop.mtime,data_crop.depth,'g*-','markersize',2)
        grid on
        datetick('x',12)
        ylabel('Depth (m)','fontsize',7)
        set(gca,'fontsize',7)
        lg=legend('Raw','Cropped','location','EastOutside');
        set(lg,'fontsize',7)
        title([mooring_id '  ' inst{:}],'interpreter','none','fontsize',10)
    else
        text(.4,.5,'No Pressure data')
        title([mooring_id '  ' inst{:}],'interpreter','none','fontsize',10)
    end
    
    subplot(3,1,2)
    hold on;
    if isfield(data_raw,'temp')
        plot(data_raw.mtime,data_raw.temp,'*-','color',[.6,.6,.6],'markersize',5)
        plot(data_crop.mtime,data_crop.temp,'c*-','markersize',2)
        grid on
        datetick('x',12)
        ylabel('Temp (^oC)','fontsize',7)
        set(gca,'fontsize',7)
        lg=legend('Raw','Cropped','location','EastOutside');
        set(lg,'fontsize',7)
    else
        text(.4,.5,'No Temperature data')
    end
    
    subplot(3,1,3)
    hold on;
    if isfield(data_raw,'sal')
        plot(data_raw.mtime,data_raw.sal,'*-','color',[.6,.6,.6],'markersize',5)
        plot(data_crop.mtime,data_crop.sal,'r*-','markersize',2)
        grid on
        datetick('x',12)
        ylabel('Salinity (psu)','fontsize',7)
        set(gca,'fontsize',7)
        lg=legend('Raw','Cropped','location','EastOutside');
        set(lg,'fontsize',7)
        xlabel('Date','fontsize',7)
    elseif isfield(data_raw,'flc') % for ESM1, only recording flc
        plot(data_raw.mtime,data_raw.flc,'*-','color',[.6,.6,.6],'markersize',5)
        plot(data_crop.mtime,data_crop.flc,'g*-','markersize',2)
        grid on
        datetick('x',12)
        ylabel('Fluorescence (\mug/l)','fontsize',7)
        set(gca,'fontsize',7)
        lg=legend('Raw','Cropped','location','EastOutside');
        set(lg,'fontsize',7)
        xlabel('Date','fontsize',7)
    else
        text(.4,.5,'No Salinity data')
    end
    
    % Make all suplots the same size - use size of subplot 2 (temp)
    pause(1) % Need to pause here for Matlab to register subplot size
    p2 = get(subplot(3,1,2),'Position');
    % Get original positions
    p1 = get(subplot(3,1,1),'Position');
    p3 = get(subplot(3,1,3),'Position');
    % Set new limits
    p1(3) = p2(3);
    p3(3) = p2(3);
    p1(4) = p2(4);
    p3(4) = p2(4);
    % Update positions of the subplots
    set(subplot(3,1,1),'Position',p1);
    set(subplot(3,1,3),'Position',p3);
    
    % Save figure
    fig_nm = [d_plot_c '\crop_' mooring_id '_' inst{:}];
    saveas(fig,fig_nm,'png')
    
    clear inst mtime in_water var_list k fig
    
end

% Save data
save(mat_fl,'RAW','RAW2');


