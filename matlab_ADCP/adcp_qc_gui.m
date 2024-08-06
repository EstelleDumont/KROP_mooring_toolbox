function varargout = adcp_qc_gui(varargin)
% ADCP_QC_GUI M-file for adcp_qc_gui.fig
%      ADCP_QC_GUI, by itself, creates a new ADCP_QC_GUI or raises the existing
%      singleton*.
%
%      H = ADCP_QC_GUI returns the handle to a new ADCP_QC_GUI or the handle to
%      the existing singleton*.
%
%      ADCP_QC_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ADCP_QC_GUI.M with the given input arguments.
%
%      ADCP_QC_GUI('Property','Value',...) creates a new ADCP_QC_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before adcp_qc_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to adcp_qc_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help adcp_qc_gui

% Last Modified by GUIDE v2.5 21-Feb-2011 14:43:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @adcp_qc_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @adcp_qc_gui_OutputFcn, ...
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


% --- Executes just before adcp_qc_gui is made visible.
function adcp_qc_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to adcp_qc_gui (see VARARGIN)

% Choose default command line output for adcp_qc_gui
handles.output = hObject;
% Points to the function which will handle the saving_panel.
set(handles.saving_panel,'SelectionChangeFcn',@saving_panel_SelectionChangeFcn);
% Set the interaction window to the first question.
set(handles.qwindow,'Backgroundcolor','c');
set(handles.qwindow,'String','Do you wish to extract a subset of the data? Please make sure that you have selected where the data comes from before you answer this question.')
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes adcp_qc_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = adcp_qc_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%% FUNCTIONS HANDLING THE USER INPUT

% Checkings for the directory path name can be done in this function.
function p_Callback(hObject, eventdata, handles)
% hObject    handle to p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of p as text
%        str2double(get(hObject,'String')) returns contents of p as a double
guidata(hObject, handles);


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


% Is active when a filename is typed in, holds the according information.
function f_Callback(hObject, eventdata, handles)
% hObject    handle to f (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f as text
%        str2double(get(hObject,'String')) returns contents of f as a double
guidata(hObject, handles);


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
function inbrowse_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inbrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% Is active when the instrument depth is typed in, holds the according data.
function adcp_d_Callback(hObject, eventdata, handles)
% hObject    handle to adcp_d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of adcp_d as text
%        str2double(get(hObject,'String')) returns contents of adcp_d as a double
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function adcp_d_CreateFcn(hObject, eventdata, handles)
% hObject    handle to adcp_d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function rdr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rdr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lat_deg_Callback(hObject, eventdata, handles)
% hObject    handle to lat_deg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lat_deg as text
%        str2double(get(hObject,'String')) returns contents of lat_deg as a double


% --- Executes during object creation, after setting all properties.
function lat_deg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lat_deg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lat_min_Callback(hObject, eventdata, handles)
% hObject    handle to lat_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lat_min as text
%        str2double(get(hObject,'String')) returns contents of lat_min as a double


% --- Executes during object creation, after setting all properties.
function lat_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lat_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function long_deg_Callback(hObject, eventdata, handles)
% hObject    handle to long_deg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of long_deg as text
%        str2double(get(hObject,'String')) returns contents of long_deg as a double


% --- Executes during object creation, after setting all properties.
function long_deg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to long_deg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function long_min_Callback(hObject, eventdata, handles)
% hObject    handle to long_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of long_min as text
%        str2double(get(hObject,'String')) returns contents of long_min as a double


% --- Executes during object creation, after setting all properties.
function long_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to long_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of start as text
%        str2double(get(hObject,'String')) returns contents of start as a double
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stop as text
%        str2double(get(hObject,'String')) returns contents of stop as a double
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function stop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fpathout_Callback(hObject, eventdata, handles)
% hObject    handle to fpathout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fpathout as text
%        str2double(get(hObject,'String')) returns contents of fpathout as a double
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function fpathout_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fpathout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function fout_Callback(hObject, eventdata, handles)
% hObject    handle to fout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fout as text
%        str2double(get(hObject,'String')) returns contents of fout as a double
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function fout_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fout (see GCBO)
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
set(handles.fpathout,'String',path2);


% --- Executes during object creation, after setting all properties.
function outbrowse_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outbrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


%% FUNCTIONS EXECUTING THE REQUIRED ACTIONS.


% --- Executes on selection change in rdr.
function rdr_Callback(hObject, eventdata, handles)
% hObject    handle to rdr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns rdr contents as cell array
%        contents{get(hObject,'Value')} returns selected item from rdr
guidata(hObject, handles);
contents=get(handles.rdr,'String');
if strcmp(contents{get(handles.rdr,'Value')},'Please select data origin')
    set(handles.adcp_d,'Visible','off')
    set(handles.q_adcp_d,'Visible','off')
elseif strcmp(contents{get(handles.rdr,'Value')},'Data comes from Win ADCP.')
    set(handles.adcp_d,'Visible','on')
    set(handles.q_adcp_d,'Visible','on')
    set(handles.instruct,'Backgroundcolor',get(0,'defaultUicontrolBackgroundColor'),'Visible','on');
    set(handles.qwindow,'Backgroundcolor','c','Visible','on');
    set(handles.subset,'Visible','on');
else
    set(handles.adcp_d,'Visible','off')
    set(handles.q_adcp_d,'Visible','off')
    set(handles.instruct,'Backgroundcolor',get(0,'defaultUicontrolBackgroundColor'),'Visible','on');
    set(handles.qwindow,'Backgroundcolor','c','Visible','on');
    set(handles.subset,'Visible','on');
end


% --- Executes on selection change in subset.
function subset_Callback(hObject, eventdata, handles)
% hObject    handle to subset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns subset contents as cell array
%        contents{get(hObject,'Value')} returns selected item from subset

% If the user wants to extract a subset from the data he has to specify
% what the start and stop times are and according actions have to be
% performed, therefore the different static text and edit fields are made
% visible as well as the show_button. If not start and stop times are set
% to a default value to get a valid input for the function.
p=get(handles.p,'String');
f=get(handles.f,'String');
infile = strcat(p,f);
%eval( ['d=load(''',p,'/',f,'.mat'');'])
d=load(infile);
% Set rdr.
contents=get(handles.rdr,'String');
if strcmp(contents{get(handles.rdr,'Value')},'Please select data origin')
    rdr='';
elseif strcmp(contents{get(handles.rdr,'Value')},'Data comes from Win ADCP.')
    rdr='n';
else
    rdr='y';
end
if rdr=='n'
    adcp_depth=get(handles.adcp_d,'String');
    mtime_all=datenum(2000+d.SerYear,d.SerMon,d.SerDay,d.SerHour,d.SerMin,d.SerSec);
else
    mtime_all=d.mtime_all;
end
contents=get(hObject,'String');
if contents{get(hObject,'Value')}=='y' % If the user wants to extract a subset of the data set all the input fields and buttons to visible.
    set(handles.text_start,'Visible','on')
    set(handles.text_stop,'Visible','on')
    set(handles.start,'Visible','on')
    set(handles.stop,'Visible','on')
    set(handles.submit,'Visible','on')
    set(handles.show_button,'Visible','on')
    set(handles.start_text,'Visible','on')
    set(handles.stop_text,'Visible','on')
    set(handles.instruct,'Backgroundcolor',get(0,'defaultUicontrolBackgroundColor'));
else
    if contents{get(hObject,'Value')}=='n'
        set(handles.start,'String',datestr(mtime_all(1),'yyyy,mm,dd,HH'))
        set(handles.stop,'String',datestr(mtime_all(length(mtime_all)),'yyyy,mm,dd,HH'))
        set(handles.stop,'String',datestr(max(mtime_all),'yyyy,mm,dd,HH'))
        set(handles.run,'Visible','on')
        set(handles.instruct,'Backgroundcolor',get(0,'defaultUicontrolBackgroundColor'));
    else
        set(handles.qwindow2,'String','Please choose either y or n')
    end
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function subset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in show_button.
function show_button_Callback(hObject, eventdata, handles)
% hObject    handle to show_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Shows the user the first and last entry of mtime_all, so he can make a choice
% on when he wants to start extracting the data.
p=get(handles.p,'String');
f=get(handles.f,'String');
contents=get(handles.rdr,'String');
if strcmp(contents{get(handles.rdr,'Value')},'Data comes from Win ADCP.')
    rdr='n';
else
    rdr='y';
end
infile = strcat(p,f);
d=load(infile);
if rdr=='n'
    mtime_all=datenum(2000+d.SerYear,d.SerMon,d.SerDay,d.SerHour,d.SerMin,d.SerSec);
else
    mtime_all=d.mtime_all;
end
set(handles.start_text_title,'Visible','on')
set(handles.end_text_title,'Visible','on')
set(handles.start_text,'String',datestr(mtime_all(1)))
set(handles.stop_text,'String',datestr(mtime_all(length(mtime_all))))
set(handles.stop_text,'String',datestr(max(mtime_all)))
guidata(hObject, handles);




% --- Executes on button press in submit.
function submit_Callback(hObject, eventdata, handles)
% hObject    handle to submit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Once the user chose to extract data and has typed in the start and stop
% times it has to be made sure that the start and stop times lie within the
% deployment period.
p=get(handles.p,'String');
f=get(handles.f,'String');
contents=get(handles.rdr,'String');
set(handles.qwindow,'Backgroundcolor',get(0,'defaultUicontrolBackgroundColor'));
if strcmp(contents{get(handles.rdr,'Value')},'Data comes from Win ADCP.')
    rdr='n';
else
    rdr='y';
end
infile = strcat(p,f);
d=load(infile);
if rdr=='n'
    mtime_all=datenum(2000+d.SerYear,d.SerMon,d.SerDay,d.SerHour,d.SerMin,d.SerSec);
else
    mtime_all=d.mtime_all;
end
start=get(handles.start,'String');
stop=get(handles.stop,'String');
eval(['start=datenum([',start,',00,00]);'])
eval(['stop=datenum([',stop,',00,00]);'])
set(handles.qwindow2,'Backgroundcolor','c');
%if datenum(start)<mtime_all(1)|| datenum(stop)>mtime_all(length(mtime_all))
if datenum(start)<mtime_all(1)|| datenum(stop)>max(mtime_all)
    set(handles.qwindow2,'String','ERROR! - Data segment exceeds deployment period! Please try again.')
else
    set(handles.qwindow2,'String','Your data will be extracted once you push the "Run Program"-button.')
    set(handles.run,'Visible','on')
end

guidata(hObject, handles);




% --- Executes on button press in run.
function run_Callback(hObject, eventdata, handles)
% hObject    handle to run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
p=get(handles.p,'String'); % Gets the path name.
f=get(handles.f,'String'); % Gets the file name.
infile = strcat(p,f);
load(infile);
%adcp_depth=str2double(get(handles.adcp_d,'String')); % Gets the instrument depth and turns it into a double.
contents=get(handles.rdr,'String');
if strcmp(contents{get(handles.rdr,'Value')},'Data comes from Win ADCP.')
    rdr='n';
else
    rdr='y';
end
contents=get(handles.subset,'String'); % Help variable to get the chosen answer from the subset-popupmenu.
subset=contents{get(handles.subset,'Value')}; % Get the chosen answer from the subset-popupmenu.
start=get(handles.start,'String'); % Get the start and stop time that the user has typed in.
stop=get(handles.stop,'String');
[adcp_depth,w_depth,bin_depth,dir,err,mag,start,u,w,bin_range,E,mtime,stop,v,mtime_all,u_all,v_all,E_all]=adcp_qc(p,f,adcp_depth,subset,start,stop,rdr,w_depth); % Calls adcp_qc.
pause(0.20) % Gives the program called time to generate all the variables that are to be saved.
if subset=='n'
    start=datenum(mtime_all(1));
    stop=datenum(mtime_all(length(mtime_all)));
end
if rdr=='n'
    save C:\temp\workdata.mat adcp_depth w_depth bin_depth dir err mag start u w bin_range E mtime stop v mtime_all u_all v_all E_all % Saves the data necessary for the saving part in a temporary file.
else
    infile = strcat(p,f);
    eval(['load ', infile, ' name config temperature ssp adc number pitch roll heading salinity pressure perc_good corr E_4beam E_ref']) 
    save C:\temp\workdata.mat name config temperature ssp mtime adc number pitch roll heading adcp_depth w_depth salinity pressure perc_good bin_depth err start u w bin_range  stop v E dir mag corr E_4beam mtime_all E_ref u_all v_all E_all
end
set(handles.qwindow,'Backgroundcolor',get(0,'defaultUicontrolBackgroundColor'),'Visible','on');
set(handles.qwindow2,'Backgroundcolor',get(0,'defaultUicontrolBackgroundColor'));
set(handles.qwindow3,'Backgroundcolor','c');
set(handles.qwindow3,'String','Do you wish to save the extracted data?') % Move on to the next step of the process.
set(handles.sav,'Visible','on')
guidata(hObject, handles);



% --- Executes on selection change in sav.
function sav_Callback(hObject, eventdata, handles)
% hObject    handle to sav (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns sav contents as cell array
%        contents{get(hObject,'Value')} returns selected item from sav

% If the user chooses to save the data the various static text and edit
% fields have to be made visible, as well as the radiobutton panel, the
% radio buttons and the save_button, if not sav has to be set to a default
% value.
contents=get(hObject,'String');
if contents{get(hObject,'Value')}=='y'
    set(handles.text8,'Visible','on')
    set(handles.text9,'Visible','on')
    set(handles.fpathout,'Visible','on') 
    set(handles.fout,'Visible','on')
    set(handles.saving_panel,'Visible','on')
    set(handles.sav2,'Visible','on')
    set(handles.sav3,'Visible','on')
    set(handles.sav4,'Visible','on')
    set(handles.save_button,'Visible','on')
    set(handles.outbrowse,'Visible','on')
else
    if contents{get(hObject,'Value')}=='n'
        set(handles.s_space,'String','0') % s_space holds the value for sav.
        delete C:\temp\workdata.mat % Delete the temporary file that held the output of adcp_qc.
    else
        set(handles.qwindow3,'String','Please select either y or n.')
    end
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function sav_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sav (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function saving_panel_SelectionChangeFcn(hObject, eventdata)
 
%retrieve GUI data, i.e. the handles structure
handles = guidata(hObject); 
 
switch get(eventdata.NewValue,'Tag')   % Get Tag of selected object
    case 'sav2'
      %execute this code when sav2 is selected
      set(handles.s_space,'String','2');
 
    case 'sav3'
      %execute this code when sav3 is selected
      set(handles.s_space,'String','3');
 
    case 'sav4'
      %execute this code when sav4 is selected  
      set(handles.s_space,'String','4');
    otherwise
       % Code for when there is no match.
 
end
%updates the handles structure
guidata(hObject, handles);




% --- Executes on button press in save_button.
function save_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% If the user wants to save the data, he made a choice of the way he would
% like to save it in. These are held in s_space and must therefore be
% retrieved.
contents=get(handles.sav,'String');
sav=contents{get(handles.sav,'Value')};
fpathout=get(handles.fpathout,'String');
fout=get(handles.fout,'String');
saving=str2double(get(handles.s_space,'String'));

% Retrieving the longitude and latitude parameters of the instrument.
long_deg=str2double(get(handles.long_deg,'String'));
long_min=str2double(get(handles.long_min,'String'));
lat_deg=str2double(get(handles.lat_deg,'String'));
lat_min=str2double(get(handles.lat_min,'String'));

contents=get(handles.rdr,'String');
if strcmp(contents{get(handles.rdr,'Value')},'Data comes from Win ADCP.')
    rdr='n';
else
    rdr='y';
end

if sav == 'y'
    
    if rdr=='n'
        load C:\temp\workdata.mat adcp_depth w_depth bin_depth dir err mag start u w bin_range E mtime stop v mtime_all u_all v_all E_all
    else
        load C:\temp\workdata.mat name config temperature ssp mtime adc number pitch roll heading adcp_depth w_depth salinity pressure perc_good bin_depth err start u w bin_range  stop v E dir mag corr E_4beam mtime_all E_ref u_all v_all E_all
    end

    if saving==4 % If the user wants to save the data in both ways, this is done.
            if rdr=='n'
                eval(['save ', fpathout, '\', fout,' adcp_depth w_depth bin_depth dir err mag start u w bin_range E mtime stop v mtime_all long_deg long_min lat_deg lat_min u_all v_all E_all'])
            else
                eval(['save ', fpathout, '\', fout,' name config temperature ssp mtime adc number pitch roll heading adcp_depth w_depth salinity pressure perc_good bin_depth err start u w bin_range  stop v corr E_4beam dir mag E mtime_all E_ref long_deg long_min lat_deg lat_min u_all v_all E_all'])
            end

            dates=cellstr(datestr(mtime));
            warning off MATLAB:xlswrite:AddSheet

           
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',dates,''east'', ''A4'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''bin number'']),''east'', ''A2'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''bin depth (m)'']),''east'', ''A3'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',[1:length(bin_depth)],''east'', ''B2'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',bin_depth'',''east'', ''B3'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''east velocity'']),''east'', ''A1'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''units=mm/sec'']),''east'',''B1'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',u'',''east'', ''B4'')';])

            
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',dates,''north'', ''A4'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''bin depth (m)'']),''north'', ''A3'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',bin_depth'',''north'', ''B3'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''bin number'']),''north'', ''A2'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''north velocity'']),''north'', ''A1'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',[1:length(bin_depth)],''north'', ''B2'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''units=mm/sec'']),''north'', ''B1'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',v'',''north'', ''B4'')';])

            
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',dates,''vertical'', ''A4'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''bin depth (m)'']),''vertical'', ''A3'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',bin_depth'',''vertical'', ''B3'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''bin number'']),''vertical'', ''A2'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''vertical velocity'']),''vertical'', ''A1'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',[1:length(bin_depth)],''vertical'', ''B2'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''units=mm/sec'']),''vertical'', ''B1'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',w'',''vertical'', ''B4'')';])

            
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',dates,''magnitude'', ''A4'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''bin depth (m)'']),''magnitude'', ''A3'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',bin_depth'',''magnitude'', ''B3'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''bin number'']),''magnitude'', ''A2'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''magnitude'']),''magnitude'', ''A1'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',[1:length(bin_depth)],''magnitude'', ''B2'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''units=mm/sec'']),''magnitude'', ''B1'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',mag'',''magnitude'', ''B4'')';])

            
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',dates,''direction'', ''A4'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''bin depth (m)'']),''direction'', ''A3'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',bin_depth'',''direction'', ''B3'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''bin number'']),''direction'', ''A2'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''direction'']),''direction'', ''A1'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',[1:length(bin_depth)],''direction'', ''B2'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''units=degrees'']),''direction'', ''B1'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',dir'',''direction'', ''B4'')';])

            
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',dates,''backscatter'', ''A4'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''bin depth (m)'']),''backscatter'', ''A3'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',bin_depth'',''backscatter'', ''B3'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''bin number'']),''backscatter'', ''A2'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''backscatter'']),''backscatter'', ''A1'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',[1:length(bin_depth)],''backscatter'', ''B2'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''units=counts'']),''backscatter'', ''B1'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',E'',''backscatter'', ''B4'')';])
            
            % eval(['deleteemptyexcelsheets(''', fpathout, '\', fout, '.xls'')'])

        
    elseif saving == 3 % If the user wants to save the data only in an excel file, this is done.

            dates=cellstr(datestr(mtime));
            warning off MATLAB:xlswrite:AddSheet

            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',dates,''east'', ''A4'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''bin number'']),''east'', ''A2'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''bin depth (m)'']),''east'', ''A3'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',[1:length(bin_depth)],''east'', ''B2'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',bin_depth'',''east'', ''B3'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''east velocity'']),''east'', ''A1'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''units=mm/sec'']),''east'',''B1'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',u'',''east'', ''B4'')';])

            
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',dates,''north'', ''A4'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''bin depth (m)'']),''north'', ''A3'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',bin_depth'',''north'', ''B3'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''bin number'']),''north'', ''A2'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''north velocity'']),''north'', ''A1'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',[1:length(bin_depth)],''north'', ''B2'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''units=mm/sec'']),''north'', ''B1'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',v'',''north'', ''B4'')';])

            
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',dates,''vertical'', ''A4'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''bin depth (m)'']),''vertical'', ''A3'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',bin_depth'',''vertical'', ''B3'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''bin number'']),''vertical'', ''A2'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''vertical velocity'']),''vertical'', ''A1'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',[1:length(bin_depth)],''vertical'', ''B2'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''units=mm/sec'']),''vertical'', ''B1'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',w'',''vertical'', ''B4'')';])

         
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',dates,''magnitude'', ''A4'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''bin depth (m)'']),''magnitude'', ''A3'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',bin_depth'',''magnitude'', ''B3'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''bin number'']),''magnitude'', ''A2'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''magnitude'']),''magnitude'', ''A1'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',[1:length(bin_depth)],''magnitude'', ''B2'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''units=mm/sec'']),''magnitude'', ''B1'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',mag'',''magnitude'', ''B4'')';])

            
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',dates,''direction'', ''A4'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''bin depth (m)'']),''direction'', ''A3'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',bin_depth'',''direction'', ''B3'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''bin number'']),''direction'', ''A2'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''direction'']),''direction'', ''A1'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',[1:length(bin_depth)],''direction'', ''B2'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''units=degrees'']),''direction'', ''B1'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',dir'',''direction'', ''B4'')';])

            
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',dates,''backscatter'', ''A4'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''bin depth (m)'']),''backscatter'', ''A3'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',bin_depth'',''backscatter'', ''B3'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''bin number'']),''backscatter'', ''A2'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''backscatter'']),''backscatter'', ''A1'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',[1:length(bin_depth)],''backscatter'', ''B2'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',cellstr([''units=counts'']),''backscatter'', ''B1'')';])
            eval(['xlswrite(''', fpathout, '\', fout,'.xls'',E'',''backscatter'', ''B4'')';])
            
            %eval(['deleteemptyexcelsheets(''', fpathout, '\', fout, '.xls'')'])

    else % If the user wants to save the data only in a mat file, this is done.
        if rdr=='n'
            eval(['save ', fpathout, '\', fout,' adcp_depth bin_depth w_depth dir err mag start u w bin_range E mtime stop v mtime_all long_deg long_min lat_deg lat_min u_all v_all E_all'])
        else
            eval(['save ', fpathout, '\', fout,' name config temperature ssp mtime adc number pitch roll heading adcp_depth w_depth salinity pressure perc_good bin_depth err start u w bin_range  stop v E dir mag corr E_4beam dir mag mtime_all E_ref long_deg long_min lat_deg lat_min u_all v_all E_all'])
        end
    end
end

delete C:\temp\workdata.mat % Delete the temporary file that held the output of adcp_qc.
set(handles.qwindow3,'String','Done saving.') % Tells the user that the program is finished.
set(handles.qwindow3,'Backgroundcolor',get(0,'defaultUicontrolBackgroundColor'));
set(handles.text24,'Visible','on')
set(handles.shallowest,'Visible','on','String',min(bin_depth))
set(handles.ice_func,'Visible','on')
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function ice_func_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ice_func (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes on button press in ice_func.
function ice_func_Callback(hObject, eventdata, handles)
% hObject    handle to ice_func (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ice_detection_gui


%% Additional Matlab programs

%created by: Quan Quach
%date: 11/6/07
%this function erases any empty sheets in an excel document
 
function deleteEmptyExcelSheets(fileName)
 
%the input fileName is the entire path of the file
%for example, fileName = 'C:\Documents and Settings\matlab\myExcelFile.xls'
 
 
excelObj = actxserver('Excel.Application');
%opens up an excel object 
excelWorkbook = excelObj.workbooks.Open(fileName);
worksheets = excelObj.sheets;
%total number of sheets in workbook
numSheets = worksheets.Count;
 
count=1;
for x=1:numSheets
    %stores the current number of sheets in the workbook
    %this number will change if sheets are deleted
    temp = worksheets.count;
 
    %if there's only one sheet left, we must leave it or else 
    %there will be an error.
    if (temp == 1) 
        break; 
    end
 
    %this command will only delete the sheet if it is empty
    worksheets.Item(count).Delete;
 
    %if a sheet was not deleted, we move on to the next one 
    %by incrementing the count variable
    if (temp == worksheets.count)
        count = count + 1;
    end
end
excelWorkbook.Save;
excelWorkbook.Close(false);
excelObj.Quit;
delete(excelObj);


% --- Executes during object creation, after setting all properties.
function shallowest_CreateFcn(hObject, eventdata, handles)
% hObject    handle to shallowest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
