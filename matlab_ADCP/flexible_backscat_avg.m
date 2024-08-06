function [eod,interval,m,wmap,w]=flexible_backscat_avg(path_1,path_2,avgd,beg_date,end_date,data_points,all)
% function flexible_backscat_avg.m

% input: path_1 = full path and file name of where mtime, Sv and bin_depth
%                   is stored
%        path_2 = full path and file name of where to store the resulting
%                   matrix
%        avgd = number of days one wants to average the data over
%        beg_date = 'yyyy,mm,dd' of when the averaging is supposed to start
%        end_date = 'yyyy,mm,dd' of when the averaging is supposed to end
%        t_dist = time between two consecutive measurements
%        data_points = minimum number of data points one wants to average
%                       over (note that this number has to be at least as
%                       big as the number of days the data is supposed to
%                       be averaged over
%        all = 2 if one wants to see all the plots, 1 if one wants to see
%                       only the first plot (works only if the
%                       averaging_gui is used)

% output: a number of variables created in the program that are needed for
%           the plotting of the first plot in the gui

% flexible averaging of backscatter and vertical velocity of ADCP

eval(['load ', path_1, ' Sv mtime w bin_depth;'])

mt=mtime';
sv=Sv;
eval(['d=find(mt>=datenum(', beg_date, ',0,0,0) & mt<=datenum(' end_date, ',0,0,0));']) % extend deployment period to midnight before and after
sv=sv(:,d);
mt=mt(d);
m=size(sv);
eod=288; % the number of 5 minute time intervals during one day
% removing the bias from the vertical velocity
w=w(:,d);
bias=nanmean(w(:));
w=w-bias;

wmap=redbluecolmap(0-2*nanstd(w(:)),0+2*nanstd(w(:))); % creating the map for the vertical velocity averages
% calculate the number of time intervals of the wished length
eval(['time_intervals=floor((datenum(', end_date, ',0,0,0)-datenum(', beg_date, ',0,0,0))/', num2str(avgd), ');'])
% creating new times for the interpolation of the given data
eval(['XI=datenum(', beg_date, ',0,0,0):datenum(0,0,0,0,5,0):datenum(', end_date, ',0,0,0);'])


wkstart=XI(1);
YIsv=zeros(m(1),length(XI));
YIw=zeros(m(1),length(XI));
warning('off','MATLAB:interp1:NaNinY');
% interpolating the absolute backscatter and the vertical velocity
for dbin=1:m(1)
    YIsv(dbin,:)=interp1(mt,sv(dbin,:),XI);
    YIw(dbin,:)=interp1(mt,w(dbin,:),XI);
end

% loop, creating a three dimensional matrix containing the averaged data
for i=1:time_intervals
    interval(i,:)=[wkstart wkstart+avgd];
    ind=find(XI>=wkstart & XI<=wkstart+avgd); % find the indices of the ith time interval
    wkstart=wkstart+avgd;
    
    % getting the data for the ith time interval
    data=YIsv(:,ind); 
    datavv=YIw(:,ind);
    
    for dbin=1:m(1)
        for dt=1:eod
            % The user has to make sure that the averaging is started on a
            % day when there exists a whole day worth of data.
            dti=0+dt:eod:(eod*(avgd-1))+dt; % take the same time of each day in the time interval
            datadt=data(dbin,dti);
            datadtvv=datavv(dbin,dti);
            
            % average the data
            if length(datadt)>data_points-1
                sv_mean(dbin,dt,i)=nanmean(datadt');
            else
                sv_mean(dbin,dt,i)=NaN;
            end
            
            if length(datadtvv)>data_points-1
                w_mean(dbin,dt,i)=nanmean(datadtvv');
            else
                w_mean(dbin,dt,i)=NaN;
            end
            
        end
    end
end

%% saving the matrices, bin_depth, and XI
eval(['save ', path_2, ' sv_mean w_mean XI bin_depth;'])

%% creating the plots of the averaged backscatter data and the averaged vertical velocity

eval(['load ', path_1, ' bin_depth;'])
if all==2 % the user of the gui wants to plot all the averages
    if time_intervals<=35
        if bin_depth(1)>=bin_depth(m(1)) % decides whether the ADCP was looking up or down 
            for i=1:time_intervals
            
                figure(i) % creates a figure per averaged time period 
                %(if too many are created the computer will automatically close all matlab applications)
                clf
                ax2=subplot(1,2,1);
                pcolor(1:eod,-bin_depth,sv_mean(:,[floor(eod/2)+1:eod,1:floor(eod/2)],i))
                shading flat
                title(['Backscatter values: ',datestr(interval(i,1),'dd mmm'),' - ',datestr(interval(i,2),'dd mmm')])
                set(gca,'ylim',[-ceil(bin_depth(1)/10)*10 -floor(bin_depth(m(1))/10)*10],...
                    'xtick',[1,72,144,216,288],'xticklabel',['12';'18';'00';'06';'12'])
                caxis([nanmean(Sv(:))-2*nanstd(Sv(:)) nanmean(Sv(:))+2*nanstd(Sv(:))]) % This affects the look of the plots.
                cb2=colorbar;
            
                freezeColors(ax2)
                cbfreeze(cb2)
            
                ax1=subplot(1,2,2);
                colormap(ax1,wmap)
                pcolor(1:eod,-bin_depth,w_mean(:,[floor(eod/2)+1:eod,1:floor(eod/2)],i))
                shading flat
                title(['Vertvel values: ',datestr(interval(i,1),'dd mmm'),' - ',datestr(interval(i,2),'dd mmm')])
                set(gca,'ylim',[-ceil(bin_depth(1)/10)*10 -floor(bin_depth(m(1))/10)*10],...
                    'xtick',[1,72,144,216,288],'xticklabel',['12';'18';'00';'06';'12'])
                caxis([0-2*nanstd(w(:)) 0+2*nanstd(w(:))]) % This affects the look of the plots.
                colorbar;
            
                freezecolors(ax1)
            end
        else
            for i=1:time_intervals
            
                figure(i)
                clf
                ax2=subplot(1,2,1);
                pcolor(1:eod,-bin_depth,sv_mean(:,[floor(eod/2)+1:eod,1:floor(eod/2)],i))
                shading flat
                title(['Backscatter values: ',datestr(interval(i,1),'dd mmm'),' - ',datestr(interval(i,2),'dd mmm')])
                set(gca,'ylim',[-ceil(bin_depth(m(1))/10)*10 -floor(bin_depth(1)/10)*10],...
                    'xtick',[1,72,144,216,288],'xticklabel',['12';'18';'00';'06';'12'])
                caxis([nanmean(Sv(:))-2*nanstd(Sv(:)) nanmean(Sv(:))+2*nanstd(Sv(:))]) % This affects the look of the plots.
                cb2=colorbar;
            
                freezecolors(ax2)
                cbfreeze(cb2)
            
                ax1=subplot(1,2,2);
                colormap(ax1,wmap)
                pcolor(1:eod,-bin_depth,w_mean(:,[floor(eod/2)+1:eod,1:floor(eod/2)],i))
                shading flat
                title(['Vertvel values: ',datestr(interval(i,1),'dd mmm'),' - ',datestr(interval(i,2),'dd mmm')])
                set(gca,'ylim',[-ceil(bin_depth(m(1))/10)*10 -floor(bin_depth(1)/10)*10],...
                    'xtick',[1,72,144,216,288],'xticklabel',['12';'18';'00';'06';'12'])
                caxis([0-2*nanstd(w(:)) 0+2*nanstd(w(:))]) % This affects the look of the plots.
                colorbar;
            
                freezecolors(ax1)
            end
        end
    end
end



%% ADDITIONAL FUNCTIONS CALLED

function [f_mean] = nanmean(data)
%
%   [f_mean] = nanmean(data);
%
%Function which calculates the mean (not NaN) of data containing
%NaN's.  NaN's are excluded completely from calculation.


[m,n] = size(data);

for index = 1:n;
    not_nans = find(isnan(data(:,index)) == 0);
    if length(not_nans) > 0;
        f_mean(index) = mean(data(not_nans,index));
    else
        f_mean(index) = NaN;
    end
end


function newmap=redbluecolmap(min,max)
if min>0 || max<0
    disp('caxis range must be (-ve,+ve)')
    return
end
n=ones(64,3);

piv=round(64*abs(min/(min-max)))+1; % find the index for the zero value
ipiv=64-piv+2;
% now make the colormap
n(1:piv-1,1)=[0:(1/(piv-2)):1]';
n(piv-2:64,3)=[1:-(1/(ipiv)):0]';
n(:,2)=n(:,1);
n(1:piv,2)=[0:(1/(piv-1)):1]';
n(piv-2:64,2)=[1:-(1/(ipiv)):0]';

newmap=n;


function [f_std] = nanstd(data);
%
%   [f_std] = nanstd(data);
%
%Function which calculates the std (not NaN) of data containing
%NaN's.  NaN's are excluded completely from calculation.

[m,n] = size(data);

for index = 1:n;
    not_nans = find(isnan(data(:,index)) == 0);
    if length(not_nans) > 0;
        f_std(index) = std(data(not_nans,index));
    else
        f_std(index) = NaN;
    end
end


function freezeColors(varargin)
% freezeColors  Lock colors of plot, enabling multiple colormaps per figure. (v2.3)
%
%   Problem: There is only one colormap per figure. This function provides
%       an easy solution when plots using different colomaps are desired
%       in the same figure.
%
%   freezeColors freezes the colors of graphics objects in the current axis so
%       that subsequent changes to the colormap (or caxis) will not change the
%       colors of these objects. freezeColors works on any graphics object
%       with CData in indexed-color mode: surfaces, images, scattergroups,
%       bargroups, patches, etc. It works by converting CData to true-color rgb
%       based on the colormap active at the time freezeColors is called.
%
%   The original indexed color data is saved, and can be restored using
%       unfreezeColors, making the plot once again subject to the colormap and
%       caxis.
%
%
%   Usage:
%       freezeColors        applies to all objects in current axis (gca),
%       freezeColors(axh)   same, but works on axis axh. Useful for colorbar.
%
%   Example:
%       subplot(2,1,1); imagesc(X); colormap hot; freezeColors
%       subplot(2,1,2); imagesc(Y); colormap hsv; freezeColors etc...
%
%       Note: colorbars must also be frozen
%           hc = colorbar; freezeColors(hc), or simply freezeColors(colorbar)
%
%       For additional examples, see freezeColors_demo.
%
%   Side effect on render mode: freezeColors does not work with the painters
%       renderer, because Matlab doesn't support rgb color data in
%       painters mode. If the current renderer is painters, freezeColors
%       changes it to zbuffer.
%
%       See also unfreezeColors, freezeColors_pub.html
%
%
%   John Iversen (iversen@nsi.edu) 3/23/05
%

%   Changes:
%   JRI (iversen@nsi.edu) 4/19/06   Correctly handles scaled integer cdata
%   JRI 9/1/06   should now handle all objects with cdata: images, surfaces,
%                scatterplots. (v 2.1)
%   JRI 11/11/06 Preserves NaN colors. Hidden option (v 2.2, not uploaded)
%   JRI 3/17/07  Preserve caxis after freezing--maintains colorbar scale (v 2.3)
%   JRI 4/12/07  Check for painters mode as Matlab doesn't support rgb in it.
%

% Hidden option for NaN colors:
%   Missing data are often represented by NaN in the indexed color
%   data, which renders transparently. This transparency will be preserved
%   when freezing colors. If instead you wish such gaps to be filled with
%   a real color, add 'nancolor',[r g b] to the end of the arguments. E.g.
%   freezeColors('nancolor',[r g b]) or freezeColors(axh,'nancolor',[r g b]),
%   where [r g b] is a color vector. This works on images & pcolor, but not on
%   surfaces.
%   Thanks to Fabiano Busdraghi and Jody Klymak for the suggestions.

%   Note: Special handling of patches: For some reason, setting
%   cdata on patches created by bar() yields an error,
%   so instead set facevertexcdata instead for patches.


% Free for all uses, but please retain the following:
%   Original Author:
%   John Iversen, 2005-7
%   john_iversen@post.harvard.edu

appdatacode = 'JRI__freezeColorsData';

[h, nancolor] = checkArgs(varargin);

%gather all children with scaled or indexed CData
cdatah = getCDataHandles(h);

%current colormap
cmap = colormap;
nColors = size(cmap,1);
cax = caxis;

% convert object color indexes into colormap to true-color data using
%  current colormap
for hh = cdatah',
    g = get(hh);
    
    %preserve parent axis clim
    if strcmp(get(g.Parent,'type'),'axes'),
        originalClim = get(g.Parent,'clim');
    else
        originalClim = [];
    end
    
    %special handling for patch (see note above)
    if ~strcmp(g.Type,'patch'),
        cdata = g.CData;
    else
        cdata = g.FaceVertexCData;
    end
    
    %get cdata mapping (most objects (except scattergroup) have it)
    if isfield(g,'CDataMapping'),
        scalemode = g.CDataMapping;
    else
        scalemode = 'scaled';
    end
    
    %save original indexed data for use with unfreezeColors
    siz = size(cdata);
    setappdata(hh, appdatacode, {cdata scalemode});
    
    %convert cdata to indexes into colormap
    if strcmp(scalemode,'scaled'),
        %4/19/06 JRI, Accommodate scaled display of integer cdata:
        %       in MATLAB, uint * double = uint, so must coerce cdata to double
        %       Thanks to O Yamashita for pointing this need out
        idx = ceil( (double(cdata) - cax(1)) / (cax(2)-cax(1)) * nColors);
    else %direct mapping
        idx = cdata;
    end
    
    %clamp to [1, nColors]
    idx(idx<1) = 1;
    idx(idx>nColors) = nColors;
    
    %handle nans in idx
    nanmask = isnan(idx);
    idx(nanmask)=1; %temporarily replace w/ a valid colormap index
    
    %make true-color data--using current colormap
    realcolor = zeros(siz);
    for i = 1:3,
        c = cmap(idx,i);
        c = reshape(c,siz);
        c(nanmask) = nancolor(i); %restore Nan (or nancolor if specified)
        realcolor(:,:,i) = c;
    end
    
    %apply new true-color color data
    
    %true-color is not supported in painters renderer, so switch out of that
    if strcmp(get(gcf,'renderer'), 'painters'),
        set(gcf,'renderer','zbuffer');
    end
    
    %replace original CData with true-color data
    if ~strcmp(g.Type,'patch'),
        set(hh,'CData',realcolor);
    else
        set(hh,'faceVertexCData',permute(realcolor,[1 3 2]))
    end
    
    %restore clim (so colorbar will show correct limits)
    if ~isempty(originalClim),
        set(g.Parent,'clim',originalClim)
    end
    
end %loop on indexed-color objects


% ============================================================================ %
% Local functions

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% getCDataHandles -- get handles of all descendents with indexed CData
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function hout = getCDataHandles(h)
% getCDataHandles  Find all objects with indexed CData

%recursively descend object tree, finding objects with indexed CData
% An exception: don't include children of objects that themselves have CData:
%   for example, scattergroups are non-standard hggroups, with CData. Changing
%   such a group's CData automatically changes the CData of its children,
%   (as well as the children's handles), so there's no need to act on them.

error(nargchk(1,1,nargin,'struct'))

hout = [];
if isempty(h),return;end

ch = get(h,'children');
for hh = ch'
    g = get(hh);
    if isfield(g,'CData'),     %does object have CData?
        %is it indexed/scaled?
        if ~isempty(g.CData) && isnumeric(g.CData) && size(g.CData,3)==1,
            hout = [hout; hh]; %#ok<AGROW> %yes, add to list
        end
    else %no CData, see if object has any interesting children
        hout = [hout; getCDataHandles(hh)]; %#ok<AGROW>
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% checkArgs -- Validate input arguments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [h, nancolor] = checkArgs(args)
% checkArgs  Validate input arguments to freezeColors

nargs = length(args);
error(nargchk(0,3,nargs,'struct'))

%grab handle from first argument if we have an odd number of arguments
if mod(nargs,2),
    h = args{1};
    if ~ishandle(h),
        error('JRI:freezeColors:checkArgs:invalidHandle',...
            'The first argument must be a valid graphics handle (to an axis)')
    end
    args{1} = [];
    nargs = nargs-1;
else
    h = gca;
end

%set nancolor if that option was specified
nancolor = [nan nan nan];
if nargs == 2,
    if strcmpi(args{end-1},'nancolor'),
        nancolor = args{end};
        if ~all(size(nancolor)==[1 3]),
            error('JRI:freezeColors:checkArgs:badColorArgument',...
                'nancolor must be [r g b] vector');
        end
        nancolor(nancolor>1) = 1; nancolor(nancolor<0) = 0;
    else
        error('JRI:freezeColors:checkArgs:unrecognizedOption',...
            'Unrecognized option (%s). Only ''nancolor'' is valid.',args{end-1})
    end
end


function CBH = cbfreeze(varargin)
%CBFREEZE   Freezes the colormap of a colorbar.
%
%   SYNTAX:
%           cbfreeze
%           cbfreeze('off')
%           cbfreeze(H,...)
%     CBH = cbfreeze(...);
%
%   INPUT:
%     H     - Handles of colorbars to be freezed, or from figures to search
%             for them or from peer axes (see COLORBAR).
%             DEFAULT: gcf (freezes all colorbars from the current figure)
%     'off' - Unfreezes the colorbars, other options are:
%               'on'    Freezes
%               'un'    same as 'off'
%               'del'   Deletes the colormap(s).
%             DEFAULT: 'on' (of course)
%
%   OUTPUT (all optional):
%     CBH - Color bar handle(s).
%
%   DESCRIPTION:
%     MATLAB works with a unique COLORMAP by figure which is a big
%     limitation. Function FREEZECOLORS by John Iversen allows to use
%     different COLORMAPs in a single figure, but it fails freezing the
%     COLORBAR. This program handles this problem.
%
%   NOTE:
%     * Optional inputs use its DEFAULT value when not given or [].
%     * Optional outputs may or not be called.
%     * If no colorbar is found, one is created.
%     * The new frozen colorbar is an axes object and does not behaves
%       as normally colorbars when resizing the peer axes. Although, some
%       time the normal behavior is not that good.
%     * Besides, it does not have the 'Location' property anymore.
%     * But, it does acts normally: no ZOOM, no PAN, no ROTATE3D and no
%       mouse selectable.
%     * No need to say that CAXIS and COLORMAP must be defined before using
%       this function. Besides, the colorbar location. Anyway, 'off' or
%       'del' may help.
%     * The 'del' functionality may be used whether or not the colorbar(s)
%       is(are) froozen. The peer axes are resized back. Try: 
%        >> colorbar, cbfreeze del
%
%   EXAMPLE:
%     surf(peaks(30))
%     colormap jet
%     cbfreeze
%     colormap gray
%     title('What...?')
%
%   SEE ALSO:
%     COLORMAP, COLORBAR, CAXIS
%     and
%     FREEZECOLORS by John Iversen
%     at http://www.mathworks.com/matlabcentral/fileexchange
%
%
%   ---
%   MFILE:   cbfreeze.m
%   VERSION: 1.1 (Sep 02, 2009) (<a href="matlab:web('http://www.mathworks.com/matlabcentral/fileexchange/authors/11258')">download</a>) 
%   MATLAB:  7.7.0.471 (R2008b)
%   AUTHOR:  Carlos Adrian Vargas Aguilera (MEXICO)
%   CONTACT: nubeobscura@hotmail.com

%   REVISIONS:
%   1.0      Released. (Jun 08, 2009)
%   1.1      Fixed BUG with image handle on MATLAB R2009a. Thanks to Sergio
%            Muniz. (Sep 02, 2009)

%   DISCLAIMER:
%   cbfreeze.m is provided "as is" without warranty of any kind, under the
%   revised BSD license.

%   Copyright (c) 2009 Carlos Adrian Vargas Aguilera


% INPUTS CHECK-IN
% -------------------------------------------------------------------------

% Parameters:
cbappname = 'Frozen';         % Colorbar application data with fields:
                              % 'Location' from colorbar
                              % 'Position' from peer axes befor colorbar
                              % 'pax'      handle from peer axes.
axappname = 'FrozenColorbar'; % Peer axes application data with frozen
                              % colorbar handle.
 
% Set defaults:
S = 'on';                   Sopt = {'on','un','off','del'};
H = get(0,'CurrentFig');

% Check inputs:
if nargin==2 && (~isempty(varargin{1}) && all(ishandle(varargin{1})) && ...
  isempty(varargin{2}))
 
 % Check for CallBacks functionalities:
 % ------------------------------------
 
 varargin{1} = double(varargin{1});
 
 if strcmp(get(varargin{1},'BeingDelete'),'on') 
  % Working as DeletFcn:

  if (ishandle(get(varargin{1},'Parent')) && ...
      ~strcmpi(get(get(varargin{1},'Parent'),'BeingDeleted'),'on'))
    % The handle input is being deleted so do the colorbar:
    S = 'del'; 
    
   if ~isempty(getappdata(varargin{1},cbappname))
    % The frozen colorbar is being deleted:
    H = varargin{1};
   else
    % The peer axes is being deleted:
    H = ancestor(varargin{1},{'figure','uipanel'}); 
   end
   
  else
   % The figure is getting close:
   return
  end
  
 elseif (gca==varargin{1} && ...
                     gcf==ancestor(varargin{1},{'figure','uipanel'}))
  % Working as ButtonDownFcn:
  
  cbfreezedata = getappdata(varargin{1},cbappname);
  if ~isempty(cbfreezedata) 
   if ishandle(cbfreezedata.ax)
    % Turns the peer axes as current (ignores mouse click-over):
    set(gcf,'CurrentAxes',cbfreezedata.ax);
    return
   end
  else
   % Clears application data:
   rmappdata(varargin{1},cbappname) 
  end
  H = varargin{1};
 end
 
else
 
 % Checks for normal calling:
 % --------------------------
 
 % Looks for H:
 if nargin && ~isempty(varargin{1}) && all(ishandle(varargin{1}))
  H = varargin{1};
  varargin(1) = [];
 end

 % Looks for S:
 if ~isempty(varargin) && (isempty(varargin{1}) || ischar(varargin{1}))
  S = varargin{1};
 end
end

% Checks S:
if isempty(S)
 S = 'on';
end
S = lower(S);
iS = strmatch(S,Sopt);
if isempty(iS)
 error('CVARGAS:cbfreeze:IncorrectStringOption',...
  ['Unrecognized ''' S ''' argument.' ])
else
 S = Sopt{iS};
end

% Looks for CBH:
CBH = cbhandle(H);

if ~strcmp(S,'del') && isempty(CBH)
 % Creates a colorbar and peer axes:
 pax = gca;
 CBH = colorbar('peer',pax);
else
 pax = [];
end


% -------------------------------------------------------------------------
% MAIN 
% -------------------------------------------------------------------------
% Note: only CBH and S are necesary, but I use pax to avoid the use of the
%       "hidden" 'Axes' COLORBAR's property. Why... ¿?

% Saves current position:
fig = get(  0,'CurrentFigure');
cax = get(fig,'CurrentAxes');

% Works on every colorbar:
for icb = 1:length(CBH)
 
 % Colorbar axes handle:
 h  = double(CBH(icb));
 
 % This application data:
 cbfreezedata = getappdata(h,cbappname);
 
 % Gets peer axes:
 if ~isempty(cbfreezedata)
  pax = cbfreezedata.pax;
  if ~ishandle(pax) % just in case
   rmappdata(h,cbappname)
   continue
  end
 elseif isempty(pax) % not generated
  try
   pax = double(get(h,'Axes'));  % NEW feature in COLORBARs
  catch
   continue
  end
 end
 
 % Choose functionality:
 switch S
  
  case 'del'
   % Deletes:
   if ~isempty(cbfreezedata)
    % Returns axes to previous size:
    oldunits = get(pax,'Units');
    set(pax,'Units','Normalized');
    set(pax,'Position',cbfreezedata.Position)
    set(pax,'Units',oldunits)
    set(pax,'DeleteFcn','')
    if isappdata(pax,axappname)
     rmappdata(pax,axappname)
    end
   end
   if strcmp(get(h,'BeingDelete'),'off') 
    delete(h)
   end
   
  case {'un','off'}
   % Unfrozes:
   if ~isempty(cbfreezedata)
    delete(h);
    set(pax,'DeleteFcn','')
    if isappdata(pax,axappname)
     rmappdata(pax,axappname)
    end
    oldunits = get(pax,'Units');
    set(pax,'Units','Normalized')
    set(pax,'Position',cbfreezedata.Position)
    set(pax,'Units',oldunits)
    CBH(icb) = colorbar(...
     'peer'    ,pax,...
     'Location',cbfreezedata.Location);
   end
 
  otherwise % 'on'
   % Freezes:
 
   % Gets colorbar axes properties:
   cb_prop  = get(h);
   
   % Gets colorbar image handle. Fixed BUG, Sep 2009
   hi = findobj(h,'Type','image');
    
   % Gets image data and transform it in a RGB:
   CData = get(hi,'CData'); 
   if size(CData,3)~=1
    % It's already frozen:
    continue
   end
  
   % Gets image tag:
   Tag = get(hi,'Tag');
  
   % Deletes previous colorbar preserving peer axes position:
   oldunits = get(pax,'Units');
              set(pax,'Units','Normalized')
   Position = get(pax,'Position');
   delete(h)
   cbfreezedata.Position = get(pax,'Position');
              set(pax,'Position',Position)
              set(pax,'Units',oldunits)
  
   % Generates new colorbar axes:
   % NOTE: this is needed because each time COLORMAP or CAXIS is used,
   %       MATLAB generates a new COLORBAR! This eliminates that behaviour
   %       and is the central point on this function.
   h = axes(...
    'Parent'  ,cb_prop.Parent,...
    'Units'   ,'Normalized',...
    'Position',cb_prop.Position...
   );
  
   % Save location for future call:
   cbfreezedata.Location = cb_prop.Location;
  
   % Move ticks because IMAGE draws centered pixels:
   XLim = cb_prop.XLim;
   YLim = cb_prop.YLim;
   if     isempty(cb_prop.XTick)
    % Vertical:
    X = XLim(1) + diff(XLim)/2;
    Y = YLim    + diff(YLim)/(2*length(CData))*[+1 -1];
   else % isempty(YTick)
    % Horizontal:
    Y = YLim(1) + diff(YLim)/2;
    X = XLim    + diff(XLim)/(2*length(CData))*[+1 -1];
   end
  
   % Draws a new RGB image:
   image(X,Y,ind2rgb(CData,colormap),...
    'Parent'            ,h,...
    'HitTest'           ,'off',...
    'Interruptible'     ,'off',...
    'SelectionHighlight','off',...
    'Tag'               ,Tag...
   )  

   % Removes all   '...Mode'   properties:
   cb_fields = fieldnames(cb_prop);
   indmode   = strfind(cb_fields,'Mode');
   for k=1:length(indmode)
    if ~isempty(indmode{k})
     cb_prop = rmfield(cb_prop,cb_fields{k});
    end
   end
   
   % Removes special COLORBARs properties:
   cb_prop = rmfield(cb_prop,{...
    'CurrentPoint','TightInset','BeingDeleted','Type',...       % read-only
    'Title','XLabel','YLabel','ZLabel','Parent','Children',...  % handles
    'UIContextMenu','Location',...                              % colorbars
    'ButtonDownFcn','DeleteFcn',...                             % callbacks
    'CameraPosition','CameraTarget','CameraUpVector','CameraViewAngle',...
    'PlotBoxAspectRatio','DataAspectRatio','Position',... 
    'XLim','YLim','ZLim'});
   
   % And now, set new axes properties almost equal to the unfrozen
   % colorbar:
   set(h,cb_prop)

   % CallBack features:
   set(h,...
    'ActivePositionProperty','position',...
    'ButtonDownFcn'         ,@cbfreeze,...  % mhh...
    'DeleteFcn'             ,@cbfreeze)     % again
   set(pax,'DeleteFcn'      ,@cbfreeze)     % and again!  
  
   % Do not zoom or pan or rotate:
   setAllowAxesZoom  (zoom    ,h,false)
   setAllowAxesPan   (pan     ,h,false)
   setAllowAxesRotate(rotate3d,h,false)
   
   % Updates data:
   CBH(icb) = h;   

   % Saves data for future undo:
   cbfreezedata.pax       = pax;
   setappdata(  h,cbappname,cbfreezedata);
   setappdata(pax,axappname,h);
   
 end % switch functionality   

end  % MAIN loop


% OUTPUTS CHECK-OUT
% -------------------------------------------------------------------------

% Output?:
if ~nargout
 clear CBH
else
 CBH(~ishandle(CBH)) = [];
end

% Returns current axes:
if ishandle(cax) 
 set(fig,'CurrentAxes',cax)
end


% [EOF]   cbfreeze.m


function CBH = cbhandle(varargin)
%CBHANDLE   Handle of current colorbar axes.
%
%   SYNTAX:
%     CBH = cbhandle;
%     CBH = cbhandle(H);
%
%   INPUT:
%     H - Handles axes, figures or uipanels to look for colorbars.
%         DEFAULT: gca (current axes)
%
%   OUTPUT:
%     CBH - Color bar handle(s).
%
%   DESCRIPTION:
%     By default, color bars are hidden objects. This function searches for
%     them by its 'axes' type and 'Colorbar' tag.
%    
%   SEE ALSO:
%     COLORBAR
%     and
%     CBUNITS, CBLABEL, CBFREEZE by Carlos Vargas
%     at http://www.mathworks.com/matlabcentral/fileexchange
%
%
%   ---
%   MFILE:   cbhandle.m
%   VERSION: 1.1 (Aug 20, 2009) (<a href="matlab:web('http://www.mathworks.com/matlabcentral/fileexchange/authors/11258')">download</a>) 
%   MATLAB:  7.7.0.471 (R2008b)
%   AUTHOR:  Carlos Adrian Vargas Aguilera (MEXICO)
%   CONTACT: nubeobscura@hotmail.com

%   REVISIONS:
%   1.0      Released. (Jun 08, 2009)
%   1.1      Fixed bug with colorbar handle input. (Aug 20, 2009)

%   DISCLAIMER:
%   cbhandle.m is provided "as is" without warranty of any kind, under the
%   revised BSD license.

%   Copyright (c) 2009 Carlos Adrian Vargas Aguilera


% INPUTS CHECK-IN
% -------------------------------------------------------------------------

% Parameters:
axappname = 'FrozenColorbar'; % Peer axes application data with frozen
                              % colorbar handle.

% Sets default:
H = get(get(0,'CurrentFigure'),'CurrentAxes');

if nargin && ~isempty(varargin{1}) && all(ishandle(varargin{1}))
 H = varargin{1};
end

% -------------------------------------------------------------------------
% MAIN
% -------------------------------------------------------------------------

% Looks for CBH:
CBH = [];
% set(0,'ShowHiddenHandles','on')
for k = 1:length(H)
 switch get(H(k),'type')
  case {'figure','uipanel'}
   % Parents axes?:
   CBH = [CBH; ...
    findobj(H(k),'-depth',1,'Tag','Colorbar','-and','Type','axes')];
  case 'axes'
   % Peer axes?:
   hin  = double(getappdata(H(k),'LegendColorbarInnerList'));
   hout = double(getappdata(H(k),'LegendColorbarOuterList'));
   if     (~isempty(hin)  && ishandle(hin))
    CBH = [CBH; hin];
   elseif (~isempty(hout) && ishandle(hout))
    CBH = [CBH; hout];
   elseif isappdata(H(k),axappname)
    % Peer from frozen axes?:
    CBH = [CBH; double(getappdata(H(k),axappname))];
   elseif strcmp(get(H(k),'Tag'),'Colorbar') % Fixed BUG Aug 2009
    % Colorbar axes?
    CBH = [CBH; H(k)];
   end
  otherwise
   % continue
 end
end
% set(0,'ShowHiddenHandles','off')


% [EOF]   cbhandle.m
