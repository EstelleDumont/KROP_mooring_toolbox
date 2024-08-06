function varargout = backscatter_calc_gui(varargin)
% BACKSCATTER_CALC_GUI MATLAB code for backscatter_calc_gui.fig
%      BACKSCATTER_CALC_GUI, by itself, creates a new BACKSCATTER_CALC_GUI or raises the existing
%      singleton*.
%
%      H = BACKSCATTER_CALC_GUI returns the handle to a new BACKSCATTER_CALC_GUI or the handle to
%      the existing singleton*.
%
%      BACKSCATTER_CALC_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BACKSCATTER_CALC_GUI.M with the given input arguments.
%
%      BACKSCATTER_CALC_GUI('Property','Value',...) creates a new BACKSCATTER_CALC_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before backscatter_calc_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to backscatter_calc_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help backscatter_calc_gui

% Last Modified by GUIDE v2.5 11-Oct-2022 15:20:23
% Created by ESDU, SAMS, Oct22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @backscatter_calc_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @backscatter_calc_gui_OutputFcn, ...
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


% --- Executes just before backscatter_calc_gui is made visible.
function backscatter_calc_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to backscatter_calc_gui (see VARARGIN)

% Choose default command line output for backscatter_calc_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes backscatter_calc_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = backscatter_calc_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function txt_file_path_Callback(hObject, eventdata, handles)
% hObject    handle to txt_file_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_file_path as text
%        str2double(get(hObject,'String')) returns contents of txt_file_path as a double


% --- Executes during object creation, after setting all properties.
function txt_file_path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_file_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function txt_infile_Callback(hObject, eventdata, handles)
% hObject    handle to txt_infile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_infile as text
%        str2double(get(hObject,'String')) returns contents of txt_infile as a double


% --- Executes during object creation, after setting all properties.
function txt_infile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_infile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function txt_outfile_Callback(hObject, eventdata, handles)
% hObject    handle to txt_outfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of txt_outfile as text
%        str2double(get(hObject,'String')) returns contents of txt_outfile as a double


% --- Executes during object creation, after setting all properties.
function txt_outfile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_outfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_browse.
function btn_browse_Callback(hObject, eventdata, handles)
% hObject    handle to btn_browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[browse_filename,browse_path,~]=uigetfile();
set(handles.txt_file_path,'String',browse_path);
set(handles.txt_infile,'String',browse_filename);
infile=get(handles.txt_infile,'String');
set(handles.txt_outfile,'String',regexprep(infile,'.mat','_sv')); % Note: user can still edit that in gui window


% --- Executes on button press in btn_calc_sv.
function btn_calc_sv_Callback(hObject, eventdata, handles)
% hObject    handle to btn_calc_sv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
p=get(handles.txt_file_path,'String');
f=get(handles.txt_infile,'String');
infile = strcat(p,f);
f2=get(handles.txt_outfile,'String');
outfile = strcat(p,f2);
err_msg=Sv_calc(p,infile,outfile); % calculate backscatter (Sv)
if err_msg==1
    set(handles.txt_result_sv,'String','The slant range is too small, therefore Sv could not be calculated and saved.','BackGroundColor','BackGroundColor',[1,0.7,0.5])
else
    set(handles.txt_result_sv,'String','The data has now been saved (as .mat array)','BackGroundColor','c')
end
% Make next step window appear
set(handles.btn_nextstep,'Visible','on');


% --- Executes on button press in btn_nextstep.
function btn_nextstep_Callback(hObject, eventdata, handles)
% hObject    handle to btn_nextstep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
krop_export_plot_gui