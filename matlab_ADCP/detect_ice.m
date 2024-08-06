function [ice_start,ice_end]=detect_ice(jd,u,v,surf_bin,flname,outpath)

% Identify periods of sea ice cover from moored, upward-looking ADCP.
% Original code from Jason Hyatt,modified extensively by MIW from 2006-2008.
% Periods of low horizontal velocity variance are interpreted
% as being representative of sea ice cover above mooring (method
% detailed in Hyatt et al., 2008, DSR II LTER Special Issue).
% Observations from Rijpfjorden (Svalbard) suggest that this method
% only works as a proxy for fast/pack ice cover, as ice formed earlier
% and broke up later in the fjord during winter 2007 than the dates
% identified using moored ADCP data.
% Periods of ice cover are selected by eye from the horizontal velocity
% data (beginning and end dates are selected). Multiple periods of ice
% cover can be selected. MIW, May 2008.

vel = u+i*v;
warning off all

m=1;
scode=0;
while scode~=1
    stopcode=0;
    while stopcode~=1
        h=figure(1);
        clf
        plot(jd,vel(surf_bin,:),'g')
        hold on
        xlim([min(jd) max(jd)])
        datetick('x','m','keeplimits');
        ylabel('Horizontal velocity (m/s)','fontsize',12)
        set(gca,'fontsize',12);
        disp(' ')
        if exist('xice','var')~=0
            for n=1:size(xice,1)
                plot(jd(max(nearest(jd,xice(n,1))):min(nearest(jd,xice(n,2)))),vel(surf_bin,max(nearest(jd,xice(n,1))):min(nearest(jd,xice(n,2)))),'k')
            end
        end
        if exist('x2','var')
            disp('Displaying selected limits')
            plot(x1,y1,'k+','markersize',8,'linewidth',2)
            plot(x2,y2,'k+','markersize',8,'linewidth',2)
            stopcode=1;
        else
            if ~exist('x1','var')
                disp('Zoom in on ice onset');
                disp('Low variance indicates presence of ice'); disp(' ')
                aa=input('Press 1 when ready to select point ');
                while aa==1
                    sc1=0;
                    disp(' ')
                    disp('Please select first point ')
                    [x1,y1]=ginput(1);
                    dclim=round(x1);
                    plot(x1,y1,'k+','markersize',8,'linewidth',2); disp(' ')
                    ac1=input('Accept first point? (y/n) ','s');
                    if strcmp(ac1,'y')==1
                        sc1=1;
                    else
                        clear x1 y1 dclim
                    end
                    aa=0;
                end
            else
                plot(x1,y1,'k+','markersize',8,'linewidth',2)
                disp('Zoom in on ice breakup'); disp(' ')
                bb=input('Press 1 when ready to select point '); disp(' ')
                while bb==1
                    sc2=0;
                    disp('Please select second point '); disp(' ')
                    [x2,y2]=ginput(1);
                    uclim=round(x2);
                    plot(x2,y2,'k+','markersize',8,'linewidth',2)
                    ac2=input('Accept second point? (y/n) ','s'); disp(' ')
                    if strcmp(ac2,'y')==1
                        sc2=1;
                    else
                        clear x2 y2 uclim
                    end
                    bb=0;
                end
            end
        end
    end
    if isempty(x1);
        scode=1;
        ice_code=0;
        disp('No ice period selected');
        ice_start=NaN;
        ice_end=NaN;
    else
        xice(m,1)=x1;
        xice(m,2)=x2;
        ice(m,1)=max(nearest(jd,xice(m,1)));
        ice(m,2)=min(nearest(jd,xice(m,2)));
        clear x1 y1 x2 y2
        disp(' ')
        p=input('Finished selecting ice-covered periods? y/n   ','s'); disp(' ')
        if strcmp(p,'y')==1
            scode=1;
        end
        m=m+1;
        ice_code=1;
    end;
end

if ice_code==1;
    plot(jd,vel(surf_bin,:),'g')
    disp('*** ICE PRESENCE ***')
    for m=1:size(ice,1)
        plot(jd(ice(m,1):ice(m,2)),vel(surf_bin,ice(m,1):ice(m,2)),'k');
        from=datestr(jd(ice(m,1)))
        to=datestr(jd(ice(m,2)))
        ice_start(m,:)=from;
        ice_end(m,:)=to;
    end
    box on
    ax=axis;
    gg=text(ax(1)+(ax(2)-ax(1))/40,ax(3)+abs(ax(3))/9,['\fontsize{12} {\color{green}No ice    \color{black}Ice}']);
    set(gg,'backgroundcolor','w','edgecolor','k');
    text(ax(1),ax(3)-abs(ax(3))/5,'2006','fontsize',12)
    text(ax(2)-(ax(2)-ax(1))/11,ax(3)-abs(ax(3))/5,'2007','fontsize',12)
    
    fig_title = ['Ice_detection_' flname];
    title(fig_title,'interpreter','none');
    % sav_title = ['Ice_detection_' flname '.jpg'];
    sav_title = [outpath '\Ice_detection_' flname '.jpg'];     % Edit ESDU, Oct 22
    saveas(h,sav_title);
end