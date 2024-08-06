function varargout = clean_gui(varargin)
% CLEAN_GUI M-file for clean_gui.fig
%      CLEAN_GUI, by itself, creates a new CLEAN_GUI or raises the existing
%      singleton*.
%
%      H = CLEAN_GUI returns the handle to a new CLEAN_GUI or the handle to
%      the existing singleton*.
%
%      CLEAN_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CLEAN_GUI.M with the given input arguments.
%
%      CLEAN_GUI('Property','Value',...) creates a new CLEAN_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before clean_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to clean_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help clean_gui

% Last Modified by GUIDE v2.5 18-Oct-2011 15:26:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @clean_gui_OpeningFcn, ...
    'gui_OutputFcn',  @clean_gui_OutputFcn, ...
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


% --- Executes just before clean_gui is made visible.
function clean_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to clean_gui (see VARARGIN)

% Choose default command line output for clean_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes clean_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = clean_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%% FUNCTIONS WORKING WITH THE INPUT DATA


% --- Executes on button press in pushbutton5 = browse for input path
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
path0=uigetdir('P:\PHYSICS\Panarchive\Processed\7_CLEAN');
set(handles.path,'String',path0);

function path_Callback(hObject, eventdata, handles)
% hObject    handle to path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of path as text
%        str2double(get(hObject,'String')) returns contents of path as a
%        double
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in auto_fill.
function auto_fill_Callback(hObject, eventdata, handles)
% hObject    handle to auto_fill (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get name of zip file in folder (there should only be one)
path=get(handles.path,'String');
eval(['cd ' path]);
txtdir=dir('*.txt');
txt_name=txtdir.name;
cd P:\PHYSICS\Panarchive\Processed\matlab
% Get name of info datafile
info_file=['P:\PHYSICS\Panarchive\Processed\6_lunar\' regexprep(txt_name,'_FM.txt','_lunar_info.txt')];
info_file=regexprep(info_file,'_NM.txt','_lunar_info.txt');
% Extract metadata info to auto-filll GUI boxes
if exist(info_file,'file');
    %Work out moon phase
    if isempty(regexp(txt_name,'FM','once'))==0;
        moon='f';
    else
        moon='n';
    end;
    % cd P:\PHYSICS\Panarchive\Processed\matlab
    [info_nomoons,info_bins,info_binsize,info_bin1depth,info_orient]=read_lunar_info(info_file,moon);
end

set(handles.no_moons,'String',num2str(info_nomoons));
set(handles.bins,'String',num2str(info_bins));
set(handles.wbin,'String',num2str(info_binsize));
set(handles.depth,'String',num2str(info_bin1depth));

if moon=='f'
    set(handles.lunar_phase,'Value',1);
    % set(handles.lunar_phase,'String','Full Moon');
elseif moon=='n'
    set(handles.lunar_phase,'Value',2);
    % set(handles.lunar_phase,'String','New Moon');
end

if info_orient==1; % i.e. up
    set(handles.direction,'Value',1);
elseif info_orient==-1; % i.e. down
    set(handles.direction,'Value',2); 
end;
    
guidata(hObject, handles);




function no_moons_Callback(hObject, eventdata, handles)
% hObject    handle to no_moons (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of no_moons as text
%        str2double(get(hObject,'String')) returns contents of no_moons as a double
% beg = str2num(get(hObject,'String'));

%checks to see if input is empty. if so, default no_moons to zero
if (isempty(beg))
    set(hObject,'String','0')
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function no_moons_CreateFcn(hObject, eventdata, handles)
% hObject    handle to no_moons (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function bins_Callback(hObject, eventdata, handles)
% hObject    handle to bins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bins as text
%        str2double(get(hObject,'String')) returns contents of bins as a double
bins = str2num(get(hObject,'String'));

%checks to see if input is empty. if so, default bins to zero
if (isempty(bins))
    set(hObject,'String','0')
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function bins_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function wbin_Callback(hObject, eventdata, handles)
% hObject    handle to wbin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wbin as text
%        str2double(get(hObject,'String')) returns contents of wbin as a double
wbin = str2num(get(hObject,'String'));

%checks to see if input is empty. if so, default wbin to zero
if (isempty(wbin))
    set(hObject,'String','0')
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function wbin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wbin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function depth_Callback(hObject, eventdata, handles)
% hObject    handle to depth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of depth as text
%        str2double(get(hObject,'String')) returns contents of depth as a double
depth = str2num(get(hObject,'String'));

%checks to see if input is empty. if so, default depth to zero
if (isempty(depth))
    set(hObject,'String','0')
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function depth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to depth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes on selection change in direction.
function direction_Callback(hObject, eventdata, handles)
% hObject    handle to direction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns direction contents as cell array
%        contents{get(hObject,'Value')} returns selected item from
%        direction
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function direction_CreateFcn(hObject, eventdata, handles)
% hObject    handle to direction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in lunar_phase.
function lunar_phase_Callback(hObject, eventdata, handles)
% hObject    handle to lunar_phase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lunar_phase contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lunar_phase


% --- Executes during object creation, after setting all properties.
function lunar_phase_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lunar_phase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function mpathout_Callback(hObject, eventdata, handles)
% hObject    handle to mpathout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mpathout as text
%        str2double(get(hObject,'String')) returns contents of mpathout as
%        a double
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function mpathout_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mpathout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton6 = browse for matlab output path
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
path1=uigetdir('P:\PHYSICS\Panarchive\Processed\7_CLEAN');
set(handles.mpathout,'String',path1);

function mout_Callback(hObject, eventdata, handles)
% hObject    handle to mout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mout as text
%        str2double(get(hObject,'String')) returns contents of mout as a
%        double
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function mout_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function epathout_Callback(hObject, eventdata, handles)
% hObject    handle to epathout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of epathout as text
%        str2double(get(hObject,'String')) returns contents of epathout as
%        a double
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function epathout_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epathout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton7 = browse for excel output path
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
path2=uigetdir('P:\PHYSICS\Panarchive\Processed\7_CLEAN');
set(handles.epathout,'String',path2);

function eout_Callback(hObject, eventdata, handles)
% hObject    handle to eout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eout as text
%        str2double(get(hObject,'String')) returns contents of eout as a
%        double
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function eout_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in initialize.
function initialize_Callback(hObject, eventdata, handles)
% hObject    handle to initialize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
path=get(handles.path,'String');
no_moons=str2double(get(handles.no_moons,'String'));
% Determine offset - i.e. first number of file to be processed
eval(['cd ' path]);
!dir *.csv_Spec /o/b >list.dat
fid=fopen('list.dat');
[list]=textread('list.dat','%s');
fclose(fid);
cd P:\PHYSICS\Panarchive\Processed\matlab
offset=str2double(list(1,:));
% Set segments - i.e. number of lunar cycles
beg=1;
last=no_moons;
% beg=str2double(get(handles.no_moons,'String'));
% last=str2double(get(handles.last,'String'));
bins=str2double(get(handles.bins,'String'));
wbin=str2double(get(handles.wbin,'String'));
depth=str2double(get(handles.depth,'String'));

contents=get(handles.direction,'String');
if strcmp(contents{get(handles.direction,'Value')},'The ADCP was looking up')==1
    direction = 'u';
else
    direction = 'd';
end

contents2=get(handles.lunar_phase,'String');
if strcmp(contents2{get(handles.lunar_phase,'Value')},'Full Moon')==1
    lunar_phase = 1;
else
    lunar_phase = 2;
end

mpathout=get(handles.mpathout,'String');
mout=get(handles.mout,'String');
epathout=get(handles.epathout,'String');
eout=get(handles.eout,'String');
[mat_path,e_path]=clean_data(path,beg,last,bins,wbin,depth,direction,mpathout,mout,epathout,eout,lunar_phase,offset);
set(handles.answer,'String',[mat_path, ', ', e_path]);
guidata(hObject, handles);


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
