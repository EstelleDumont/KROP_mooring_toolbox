function varargout = ice_detection_gui(varargin)
% ICE_DETECTION_GUI M-file for ice_detection_gui.fig
%      ICE_DETECTION_GUI, by itself, creates a new ICE_DETECTION_GUI or raises the existing
%      singleton*.
%
%      H = ICE_DETECTION_GUI returns the handle to a new ICE_DETECTION_GUI or the handle to
%      the existing singleton*.
%
%      ICE_DETECTION_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ICE_DETECTION_GUI.M with the given input arguments.
%
%      ICE_DETECTION_GUI('Property','Value',...) creates a new ICE_DETECTION_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ice_detection_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ice_detection_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ice_detection_gui

% Last Modified by GUIDE v2.5 28-Oct-2022 12:21:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @ice_detection_gui_OpeningFcn, ...
    'gui_OutputFcn',  @ice_detection_gui_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ice_detection_gui is made visible.
function ice_detection_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ice_detection_gui (see VARARGIN)

% Choose default command line output for ice_detection_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ice_detection_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ice_detection_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function p_Callback(hObject, eventdata, handles)
% hObject    handle to p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of p as text
%        str2double(get(hObject,'String')) returns contents of p as a double


% --- Executes during object creation, after setting all properties.
function p_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function f_Callback(hObject, eventdata, handles)
% hObject    handle to f (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f as text
%        str2double(get(hObject,'String')) returns contents of f as a double


% --- Executes during object creation, after setting all properties.
function f_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in inbrowse.
function inbrowse_Callback(hObject, eventdata, handles)
% hObject    handle to inbrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,path,ind]=uigetfile();
set(handles.f,'String',filename);
set(handles.p,'String',path);


% --- Executes during object creation, after setting all properties.
function origin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to origin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in origin.
function origin_Callback(hObject, eventdata, handles)
% hObject    handle to origin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns origin contents as cell array
%        contents{get(hObject,'Value')} returns selected item from origin
guidata(hObject, handles);


function op_Callback(hObject, eventdata, handles)
% hObject    handle to op (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of op as text
%        str2double(get(hObject,'String')) returns contents of op as a double


% --- Executes during object creation, after setting all properties.
function op_CreateFcn(hObject, eventdata, handles)
% hObject    handle to op (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function of_Callback(hObject, eventdata, handles)
% hObject    handle to of (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of of as text
%        str2double(get(hObject,'String')) returns contents of of as a double


% --- Executes during object creation, after setting all properties.
function of_CreateFcn(hObject, eventdata, handles)
% hObject    handle to of (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in outbrowse.
function outbrowse_Callback(hObject, eventdata, handles)
% hObject    handle to outbrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
path2=uigetdir;
set(handles.op,'String',path2);


% --- Executes during object creation, after setting all properties.
function run_ice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to run_ice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes on button press in run_ice.
function run_ice_Callback(hObject, eventdata, handles)
% hObject    handle to run_ice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
p=get(handles.p,'String');
f=get(handles.f,'String');
infile = strcat(p,f);
e=load(infile);

op=get(handles.op,'String');
of=get(handles.of,'String');

% Select the bin to use for ice detection: this is the first bin above the
% bin showing the highest backscatter (method from Hyatt et al, 2008).
% The bin may not be completely in the water and in that case it will have
% been removed from the final dataset.

% Find out which bin is the "surface" bin in final dataset (i.e. in
% bin_depth)
surf_bin_no = length(e.bin_depth);
[nobin,xx]=size(e.E_all);
jj=nobin-surf_bin_no;
if jj>5
    jj=5;
end

% Look at the average backscatter value on this bin, and on the 1 below and
% 10 above (this is to avoid selecting a bin with high backscatter in the
% water column / near the instrument)
for j = (surf_bin_no - 1): (surf_bin_no + jj)
    bscat_avg (j)=mean(e.E_all(j,:));
end
% Select bin above the max backscatter bin
[k,l] = max(bscat_avg);
ice_bin = l+1;
if ice_bin > nobin
    ice_bin=nobin;
end
% ice_bin=30;
% Remove any non-sense times (sometimes there is a 0 at the end of dataset)
ind = find(e.mtime_all<=0);
e.mtime_all(ind) = NaN;
clear ind

% Call ice detection function
flname = regexprep(f,'.mat','');
[ice_start,ice_end]=detect_ice(e.mtime_all,e.u_all,e.v_all,ice_bin,flname,op);

% Add the "ice presence" variable
% Create new variable
% NB: can't use the function "zeros" as variable is too big
for m = 1:length(e.u)
    ice_cover(m) = 0;
end
is_num = NaN;
ie_num = NaN;
% Convert dates to numeric format
if isnan(ice_start)==0
    is_str = cellstr(ice_start);
    ie_str = cellstr(ice_end);
    is_num = datenum(is_str);
    ie_num = datenum(ie_str);
    % Find the data within the ice period
    for n = 1:length(is_num)
        clear ind
        ind=find(e.mtime_all>is_num(n) & e.mtime_all<ie_num(n));
        ice_cover(ind) = 1;
    end
end

load(infile);
% Correct mtime_all again
ind2 = find(mtime_all<=0);
mtime_all(ind2) = NaN;
clear ind2

contents=get(handles.origin,'String');
if strcmp(contents{get(handles.origin,'Value')},'Data comes from WinADCP')
    rdr = 'n';
    eval(['save ', op, '\', of,' adcp_depth w_depth bin_depth dir err mag start u w bin_range E mtime stop v mtime_all long_deg long_min lat_deg lat_min ice_bin ice_cover is_num ie_num'])
elseif strcmp(contents{get(handles.origin,'Value')},'Data comes from RDRADCP')
    rdr = 'y';
    eval(['save ', op, '\', of,' name config temperature ssp mtime adc number pitch roll heading adcp_depth w_depth salinity pressure perc_good bin_depth err start u w bin_range  stop v corr E_4beam dir mag E mtime_all E_ref long_deg long_min lat_deg lat_min ice_bin ice_cover is_num ie_num'])
end

set(handles.btn_next,'Visible','on')


% --- Executes on button press in no_run_ice.
function no_run_ice_Callback(hObject, eventdata, handles)
% hObject    handle to no_run_ice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
p=get(handles.p,'String');
f=get(handles.f,'String');
infile = strcat(p,f);
e=load(infile);
for m = 1:length(e.u)
    ice_cover(m) = -1;
end
ice_bin=NaN;
is_num=NaN;
ie_num=NaN;

load(infile);
% Correct mtime_all
ind2 = find(mtime_all<=0);
mtime_all(ind2) = NaN;
clear ind2

op=get(handles.op,'String');
of=get(handles.of,'String');

contents=get(handles.origin,'String');
if strcmp(contents{get(handles.origin,'Value')},'Data comes from WinADCP')
    rdr = 'n';
    eval(['save ', op, '\', of,' adcp_depth w_depth bin_depth dir err mag start u w bin_range E mtime stop v mtime_all long_deg long_min lat_deg lat_min ice_bin ice_cover is_num ie_num'])
elseif strcmp(contents{get(handles.origin,'Value')},'Data comes from RDRADCP')
    rdr = 'y';
    eval(['save ', op, '\', of,' name config temperature ssp mtime adc number pitch roll heading adcp_depth w_depth salinity pressure perc_good bin_depth err start u w bin_range  stop v corr E_4beam dir mag E mtime_all E_ref long_deg long_min lat_deg lat_min ice_bin ice_cover is_num ie_num'])
end

set(handles.btn_next,'Visible','on')


% --- Executes during object creation, after setting all properties.
function btn_next_CreateFcn(hObject, eventdata, handles)
% hObject    handle to run_ice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in btn_next.
function btn_next_Callback(hObject, eventdata, handles)
% hObject    handle to btn_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Calls next step = backscatter calculation
backscatter_calc_gui
