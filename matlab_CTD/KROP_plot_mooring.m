function KROP_plot_mooring(info_file)

% Plot processed data from mooring.
%   Plot 1: flc, par and salanity timeseries + temperature contour plot
%   Plot 2: Hydrocat variable timeseries
% ESDU, SAMS, April 19

% Note: the number of instruments per plot/subplot is currently limited (to
% 6 SBE37s, and 2 for the other instruments). This could be extended in
% future versions of the code (the main thing will be to specify mroe
% colors / different sympols for extra instruments).

close all
load(info_file)

% Load mooring data
mat_fl = [d_mat '\' mooring_id '_CTD.mat'];
load(mat_fl)


% Setup plot
fig = figure('units','normalized','Position',[0.01,0.05,0.98,0.87]);

% Set up subplots, to be filled if data is available
s1=subplot(5,1,1);
text(.4,.5,'No Fluorescence data')
s2=subplot(5,1,2);
text(.4,.5,'No PAR data')
s3=subplot(5,1,3);
text(.4,.5,'No Salinity data')

% Setup legend indices
j=0; jj=0; jjj=0; jjjj=0; jjjjj=0;

%% Timeseries plots of SBE16(s) (up to 2)
j=0;
no_par=1;
no_flc=1;
if exist('sbe16p_num','var')
    if sbe16p_num >0
        for j = 1:sbe16p_num
            eval(['DATA_IN = PRO_avg_6hr.SBE16p_' sbe16p_sn{j} ';'])

            if isfield(DATA_IN,'flc')
                no_flc=0;
                if j==1
                    subplot(5,1,1)
                    plot(DATA_IN.interp_time,DATA_IN.flc,'color',rgb('Lime'))
                    hold on; grid on;
                    datetick('x',12)
                    ylabel('Fluo (mg/m^3)','fontsize',8)
                    set(gca,'fontsize',8)
                    lg_f{j} = [sbe16p_depth{j} 'm'];
                else
                    subplot(5,1,1)
                    plot(DATA_IN.interp_time,DATA_IN.flc,'color',rgb('ForestGreen'))
                    lg_f{j} = [sbe16p_depth{j} 'm'];
                end
            else
                no_flc=1;
            end

            if isfield(DATA_IN,'par')
                no_par = 0;
                if j==1
                    subplot(5,1,2)
                    plot(DATA_IN.interp_time,DATA_IN.par,'color',rgb('Goldenrod'))
                    hold on; grid on;
                    datetick('x',12)
                    ylabel('PAR (\mumol phot/m^2/sec)','fontsize',8)
                    set(gca,'fontsize',8)
                    lg_p{j} = [sbe16p_depth{j} 'm'];
                else
                    subplot(5,1,2)
                    plot(DATA_IN.interp_time,DATA_IN.par,'color',rgb('SaddleBrown'))
                    lg_p{j} = [sbe16p_depth{j} 'm'];
                end
            else
                no_par = 1;
            end

            if isfield(DATA_IN,'sal')
                if j==1
                    subplot(5,1,3)
                    plot(DATA_IN.interp_time,DATA_IN.sal,'color',rgb('Cyan'))
                    hold on; grid on;
                    datetick('x',12)
                    ylabel('Salinity (psu)','fontsize',8)
                    set(gca,'fontsize',8)
                    lg_s{j} = [sbe16p_depth{j} 'm'];
                else
                    subplot(5,1,3)
                    plot(DATA_IN.interp_time,DATA_IN.sal,'color',rgb('DeepSkyBlue'))
                    lg_s{j} = [sbe16p_depth{j} 'm'];
                end
            end

            clear DATA_IN
        end
    end
end


%% Timeseries plots of SBE19(s) (up to 2)
jj=0;
no_par=1;
no_flc=1;
if exist('sbe19p_num','var')
    if sbe19p_num >0
        for jj = 1:sbe19p_num
            eval(['DATA_IN = PRO_avg_6hr.SBE19p_' sbe19p_sn{jj} ';'])

            if isfield(DATA_IN,'flc')
                no_flc=0;
                if jj==1
                    subplot(5,1,1)
                    plot(DATA_IN.interp_time,DATA_IN.flc,'-','color',rgb('SeaGreen'))
                    hold on; grid on;
                    datetick('x',12)
                    ylabel('Fluo (mg/m^3)','fontsize',8)
                    set(gca,'fontsize',8)
                    lg_f{j+jj} = [sbe19p_depth{jj} 'm'];
                else
                    subplot(5,1,1)
                    plot(DATA_IN.interp_time,DATA_IN.flc,'-','color',rgb('PaleGreen'))
                    lg_f{j+jj} = [sbe19p_depth{jj} 'm'];
                end
            else
                no_flc=1;
            end

            if isfield(DATA_IN,'par')
                no_par = 0;
                if jj==1
                    subplot(5,1,2)
                    plot(DATA_IN.interp_time,DATA_IN.par,'-','color',rgb('Sienna'))
                    hold on; grid on;
                    datetick('x',12)
                    ylabel('PAR (\mumol phot/m^2/sec)','fontsize',8)
                    set(gca,'fontsize',8)
                    lg_p{j+jj} = [sbe19p_depth{jj} 'm'];
                else
                    subplot(5,1,2)
                    plot(DATA_IN.interp_time,DATA_IN.par,'-','color',rgb('DarkGoldenrod'))
                    lg_p{j+jj} = [sbe19p_depth{jj} 'm'];
                end
            else
                no_par = 1;
            end

            if isfield(DATA_IN,'sal')
                if jj==1
                    subplot(5,1,3)
                    plot(DATA_IN.interp_time,DATA_IN.sal,'-','color',rgb('LightSkyBlue'))
                    hold on; grid on;
                    datetick('x',12)
                    ylabel('Salinity (psu)','fontsize',8)
                    set(gca,'fontsize',8)
                    lg_s{j+jj} = [sbe19p_depth{jj} 'm'];
                else
                    subplot(5,1,3)
                    plot(DATA_IN.interp_time,DATA_IN.sal,'-','color',rgb('DarkTurquoise'))
                    lg_s{j+jj} = [sbe19p_depth{jj} 'm'];
                end
            end

            clear DATA_IN
        end
    end
end


%% Timeseries plots of ESM-1 (up to 2)
jjj=0;
if exist('esm1_num','var')
    if esm1_num >0
        for jjj = 1:esm1_num
            eval(['DATA_IN = PRO_avg_6hr.ESM1_' esm1_sn{jjj} ';'])

            if isfield(DATA_IN,'flc')
                if jjj==1
                    subplot(5,1,1)
                    plot(DATA_IN.interp_time,DATA_IN.flc,'color',rgb('DarkGreen'))
                    hold on; grid on;
                    datetick('x',12)
                    ylabel('Fluo (mg/m^3)','fontsize',8)
                    set(gca,'fontsize',8)
                    lg_f{j+jj+jjj} = [esm1_depth{jjj} 'm'];
                else
                    subplot(5,1,1)
                    plot(DATA_IN.interp_time,DATA_IN.flc,'color',rgb('DarkOliveGreen'))
                    lg_f{j+jj+jjj} = [esm1_depth{jjj} 'm'];
                end
            end

            clear DATA_IN
        end
    end
end


%% Timeseries plots of Hydrocat
jjjj=0;
no_par=1;
no_flc=1;
if exist('hcat_num','var')
    if hcat_num>0
        for jjjj = 1:hcat_num
            eval(['DATA_IN = PRO_avg_6hr.HCAT_' hcat_sn{jjjj} ';'])

            if isfield(DATA_IN,'flc')
                no_flc=0;
                if jjjj==1
                    subplot(5,1,1)
                    plot(DATA_IN.interp_time,DATA_IN.flc,'-','color',rgb('LightSeaGreen'))
                    hold on; grid on;
                    datetick('x',12)
                    ylabel('Fluo (mg/m^3)','fontsize',8)
                    set(gca,'fontsize',8)
                    lg_f{j+jj+jjj+jjjj} = [hcat_depth{jjjj} 'm'];
                else
                    subplot(5,1,1)
                    plot(DATA_IN.interp_time,DATA_IN.flc,'-','color',rgb('DarkOliveGreen'))
                    lg_f{j+jj+jjj+jjjj} = [hcat_depth{jjjj} 'm'];
                end
            else
                no_flc=1;
            end

            if isfield(DATA_IN,'par')
                no_par = 0;
                if jjjj==1
                    subplot(5,1,2)
                    plot(DATA_IN.interp_time,DATA_IN.par,'-','color',rgb('Gold'))
                    hold on; grid on;
                    datetick('x',12)
                    ylabel('PAR (\mumol phot/m^2/sec)','fontsize',8)
                    set(gca,'fontsize',8)
                    lg_p{j+jj+jjj+jjjj} = [hcat_depth{jjjj} 'm'];
                else
                    subplot(5,1,2)
                    plot(DATA_IN.interp_time,DATA_IN.par,'-''color',rgb('Khaki'))
                    lg_p{j+jj+jjj+jjjj} = [hcat_depth{jjjj} 'm'];
                end
            else
                no_par = 1;
            end

            if isfield(DATA_IN,'sal')
                if jjjj==1
                    subplot(5,1,3)
                    plot(DATA_IN.interp_time,DATA_IN.sal,'-','color',rgb('SteelBlue'))
                    hold on; grid on;
                    datetick('x',12)
                    ylabel('Salinity (psu)','fontsize',8)
                    set(gca,'fontsize',8)
                    lg_s{j+jj+jjjj} = [hcat_depth{jjjj} 'm'];
                else
                    subplot(5,1,3)
                    plot(DATA_IN.interp_time,DATA_IN.sal,'-','color',rgb('DarkSlateBlue'))
                    lg_s{j+jj+jjjj} = [hcat_depth{jjjj} 'm'];
                end
            end

            clear DATA_IN
        end
    end
end


%% Timeseries plot of SBE37
sal_col = {'DodgerBlue','Blue','Indigo','BlueViolet','DarkMagenta','Magenta'};
if exist('sbe37_num','var')
    if sbe37_num >0
        for jjjjj = 1:sbe37_num
            eval(['DATA_IN = PRO_avg_6hr.SBE37_' sbe37_sn{jjjjj} ';'])

            if isfield(DATA_IN,'sal')
                subplot(5,1,3)
                eval(['plot(DATA_IN.interp_time,DATA_IN.sal,''color'',rgb(''' sal_col{jjjjj} '''))'])
                hold on; grid on;
                datetick('x',12)
                ylabel('Salinity (psu)','fontsize',8)
                set(gca,'fontsize',8)
                lg_s{j+jj+jjjj+jjjjj} = [sbe37_depth{jjjjj} 'm']; % Note: remove esm1 index jjj (doesn't have salinity)
            end
        end
        clear DATA_IN
    end
end

if exist('lg_f')
    subplot(5,1,1)
    legend(lg_f,'fontsize',8,'location','eastoutside')
end
if exist('lg_p')
    subplot(5,1,2)
    legend(lg_p,'fontsize',8,'location','eastoutside')
end
if exist('lg_s')
    subplot(5,1,3)
    legend(lg_s,'fontsize',8,'location','eastoutside')
end

subplot(5,1,1)
title ([mooring_id ' (6hr average)'],'interpreter','none','fontsize',10);


%% Contour plot of temperature grid

s4=subplot(5,1,4:5);
hold on; grid on
imagesc(PRO_grid_temp.interp_time,PRO_grid_temp.interp_depth,PRO_grid_temp.interp_temp)
datetick('x','mmm-yy')
% Add instruments depths
xlims=get(gca,'xlim');
for k = 1:length(PRO_grid_temp.inst_depth)
    plot(xlims,[PRO_grid_temp.inst_depth(k),PRO_grid_temp.inst_depth(k)],'-','color',[.1 .1 .1])
end
imagesc(PRO_grid_temp.interp_time,PRO_grid_temp.interp_depth,PRO_grid_temp.interp_temp)
plot([min(PRO_grid_temp.interp_time) max(PRO_grid_temp.interp_time)],[mooring_depth mooring_depth],'k-','linewidth',3)
set(gca,'fontsize',8)
set(gca,'YLim',[0 ceil(mooring_depth/10)*10])
set(gca,'YDir','reverse')
box on

% Labels
xlabel('Date','fontsize',8)
ylabel('Depth (m)','fontsize',8);

% Add color scale
colormap(cmocean('balance'))
h=colorbar;
set(h,'fontsize',8)
set(get(h,'xlabel'),'string','Temp (^oC)','fontsize',8)

if (sbe16p_num+sbe19p_num+sbe37_num)>0 % i.e. we have more than the temperature plot)
    if (no_par+no_flc) == 0 % par and flc there
        linkaxes([s1 s2 s3 s4],'x')
    elseif (no_par+no_flc) == 2 % no par or flc
        linkaxes([s3 s4],'x')
    elseif no_flc ==1 % only par plot, no flc plot (+ sal + temp)
        linkaxes([s2 s3 s4],'x')
    elseif no_par ==1 % only flc plot, no par (+ sal + temp)
        linkaxes([s1 s3 s4],'x')
    end
end


%% Make all suplots the same size to maintain timescale
pause(1)
% Get original positions
p1 = get(s1,'Position');
p2 = get(s2,'Position');
p3 = get(s3,'Position');
p4 = get(s4,'Position');
%p3 = get(subplot(5,1,3:4),'Position');
% Set new horizontal limits
p1(1) = p3(1)-0.06;
p1(3) = p3(3)+0.1;
p2(1) = p1(1); p3(1) = p1(1); p4(1) = p1(1);
p2(3) = p1(3); p3(3) = p1(3); p4(3) = p1(3);
% Extend vertical limits
p4(2) = p4(2)-0.05;
p3(2) = p3(2)-0.05; p3(4) = p3(4)+0.035;
p2(2) = p2(2)-0.04; p2(4) = p2(4)+0.035;
p1(2) = p1(2)-0.03; p1(4) = p1(4)+0.035;
% Update positions of the subplotsinfo
set(s1,'Position',p1);
set(s2,'Position',p2);
set(s3,'Position',p3);
set(s4,'Position',p4);

% Align x-axis
x4 = get(s4,'xlim');
set(s1,'xlim',x4)
set(s2,'xlim',x4)
set(s3,'xlim',x4)

%% Save figure
fig_nm = [d_plot_pro '\' mooring_id '_avg_6hr'];
saveas(fig,fig_nm,'tif')

clear j jj jj* lg*


%% Extra timeseries plot for Hydrocat

if exist('hcat_num','var')
    if hcat_num>0

        fig2 = figure('units','normalized','Position',[0.01,0.05,0.98,0.87]);

        for h = 1:hcat_num

            eval(['DATA_IN = PRO_avg_6hr.HCAT_' hcat_sn{h} ';'])

            if isfield(DATA_IN,'temp')
                if h==1
                    subplot(6,1,1)
                    plot(DATA_IN.interp_time,DATA_IN.flc,'-','color',rgb('DarkOrange'))
                    hold on; grid on;
                    datetick('x',12)
                    ylabel('Temp (^oC)','fontsize',8)
                    set(gca,'fontsize',8)
                    lg_t{h} = [hcat_depth{h} 'm'];
                else
                    subplot(6,1,1)
                    plot(DATA_IN.interp_time,DATA_IN.temp,'-','color',rgb('Red'))
                    lg_t{h} = [hcat_depth{h} 'm'];
                end
            end

            if isfield(DATA_IN,'sal')
                if h==1
                    subplot(6,1,2)
                    plot(DATA_IN.interp_time,DATA_IN.sal,'-','color',rgb('SteelBlue'))
                    hold on; grid on;
                    datetick('x',12)
                    ylabel('Salinity (psu)','fontsize',8)
                    set(gca,'fontsize',8)
                    lg_s{h} = [hcat_depth{h} 'm'];
                else
                    subplot(6,1,2)
                    plot(DATA_IN.interp_time,DATA_IN.sal,'-','color',rgb('DarkSlateBlue'))
                    lg_s{h} = [hcat_depth{h} 'm'];
                end
            end

            if isfield(DATA_IN,'flc')
                if h==1
                    subplot(6,1,3)
                    plot(DATA_IN.interp_time,DATA_IN.flc,'-','color',rgb('LightSeaGreen'))
                    hold on; grid on;
                    datetick('x',12)
                    ylabel('Fluo (mg/m^3)','fontsize',8)
                    set(gca,'fontsize',8)
                    lg_f{h} = [hcat_depth{h} 'm'];
                else
                    subplot(6,1,3)
                    plot(DATA_IN.interp_time,DATA_IN.flc,'-','color',rgb('DarkOliveGreen'))
                    lg_f{h} = [hcat_depth{h} 'm'];
                end
            end

            if isfield(DATA_IN,'oxy')
                if h==1
                    subplot(6,1,4)
                    plot(DATA_IN.interp_time,DATA_IN.oxy,'-','color',rgb('Khaki'))
                    hold on; grid on;
                    datetick('x',12)
                    ylabel('O2 (mg/L)','fontsize',8)
                    set(gca,'fontsize',8)
                    lg_o{h} = [hcat_depth{h} 'm'];
                else
                    subplot(6,1,4)
                    plot(DATA_IN.interp_time,DATA_IN.oxy,'-''color',rgb('Gold'))
                    lg_o{h} = [hcat_depth{h} 'm'];
                end
            end

            if isfield(DATA_IN,'ph')
                if h==1
                    subplot(6,1,5)
                    plot(DATA_IN.interp_time,DATA_IN.ph,'-','color',rgb('Gray'))
                    hold on; grid on;
                    datetick('x',12)
                    ylabel('pH','fontsize',8)
                    set(gca,'fontsize',8)
                    lg_p{h} = [hcat_depth{h} 'm'];
                else
                    subplot(6,1,5)
                    plot(DATA_IN.interp_time,DATA_IN.ph,'-''color',rgb('Black'))
                    lg_p{h} = [hcat_depth{h} 'm'];
                end
            end

            if isfield(DATA_IN,'tur')
                if h==1
                    subplot(6,1,6)
                    plot(DATA_IN.interp_time,DATA_IN.tur,'-','color',rgb('SaddleBrown'))
                    hold on; grid on;
                    datetick('x',12)
                    ylabel('Turbidity (NTU)','fontsize',8)
                    set(gca,'fontsize',8)
                    lg_tu{h} = [hcat_depth{h} 'm'];
                else
                    subplot(6,1,6)
                    plot(DATA_IN.interp_time,DATA_IN.tur,'-''color',rgb('Maroon'))
                    lg_tu{h} = [hcat_depth{h} 'm'];
                end
            end

            clear DATA_IN

        end


        if exist('lg_t')
            subplot(6,1,1)
            legend(lg_t,'fontsize',8,'location','eastoutside')
        end
        if exist('lg_s')
            subplot(6,1,2)
            legend(lg_s,'fontsize',8,'location','eastoutside')
        end
        if exist('lg_f')
            subplot(6,1,3)
            legend(lg_f,'fontsize',8,'location','eastoutside')
        end
        if exist('lg_o')
            subplot(6,1,4)
            legend(lg_o,'fontsize',8,'location','eastoutside')
        end
        if exist('lg_p')
            subplot(6,1,5)
            legend(lg_p,'fontsize',8,'location','eastoutside')
        end
        if exist('lg_tu')
            subplot(6,1,6)
            legend(lg_tu,'fontsize',8,'location','eastoutside')
        end

        subplot(6,1,1)
        title ([mooring_id ' (6hr average) - Hydrocat '],'interpreter','none','fontsize',10);

        fig_nm = [d_plot_pro '\' mooring_id '_avg_6hr_hydrocat'];
        saveas(fig2,fig_nm,'tif')

    end

end
