% !!!!!!!!Note: rdradcp.m has to be in the same directory as rdr_gui!!!!!!!
% Runs rdradcp and saves the important variables.

function varargout = rdr_gui(varargin)
% RDR_GUI M-file for rdr_gui.fig
%      RDR_GUI, by itself, creates a new RDR_GUI or raises the existing
%      singleton*.
%
%      H = RDR_GUI returns the handle to a new RDR_GUI or the handle to
%      the existing singleton*.
%
%      RDR_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RDR_GUI.M with the given input arguments.
%
%      RDR_GUI('Property','Value',...) creates a new RDR_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before rdr_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to rdr_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help rdr_gui

% Last Modified by GUIDE v2.5 28-Sep-2014 15:52:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @rdr_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @rdr_gui_OutputFcn, ...
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


% --- Executes just before rdr_gui is made visible.
function rdr_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to rdr_gui (see VARARGIN)

% Choose default command line output for rdr_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes rdr_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = rdr_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%% functions handling the input data

% --- Executes on button press in browse.
function inbrowse_Callback(hObject, eventdata, handles)
% hObject    handle to browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,path,ind]=uigetfile('*');
infile = strcat(path,filename);
set(handles.ipf,'String',infile);


function ipf_Callback(hObject, eventdata, handles)
% hObject    handle to ipf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ipf as text
%        str2double(get(hObject,'String')) returns contents of ipf as a double
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function ipf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ipf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function opf_Callback(hObject, eventdata, handles)
% hObject    handle to opf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of opf as text
%        str2double(get(hObject,'String')) returns contents of opf as a double
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function opf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to opf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function adcp_depth_Callback(hObject, eventdata, handles)
% hObject    handle to adcp_depth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of adcp_depth as text
%        str2double(get(hObject,'String')) returns contents of adcp_depth as a double
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function adcp_depth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to adcp_depth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function w_depth_Callback(hObject, eventdata, handles)
% hObject    handle to adcp_depth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of adcp_depth as text
%        str2double(get(hObject,'String')) returns contents of adcp_depth as a double
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function w_depth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to adcp_depth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in beam1.
function beam1_Callback(hObject, eventdata, handles)
% hObject    handle to beam1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of beam1
if (get(hObject,'Value') == get(hObject,'Max'))
    if get(handles.discard_text,'String')=='0'
        set(handles.discard_text,'String','1')
    else
        set(handles.beam_text,'String','If there is more than one broken beam the program will not return valuable information.')
    end
end
guidata(hObject, handles);


% --- Executes on button press in beam2.
function beam2_Callback(hObject, eventdata, handles)
% hObject    handle to beam2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of beam2
if (get(hObject,'Value') == get(hObject,'Max'))
    if get(handles.discard_text,'String')=='0'
        set(handles.discard_text,'String','2')
    else
        set(handles.beam_text,'String','If there is more than one broken beam the program will not return valuable information.')
    end
end
guidata(hObject, handles);


% --- Executes on button press in beam3.
function beam3_Callback(hObject, eventdata, handles)
% hObject    handle to beam3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of beam3
if (get(hObject,'Value') == get(hObject,'Max'))
    if get(handles.discard_text,'String')=='0'
        set(handles.discard_text,'String','3')
    else
        set(handles.beam_text,'String','If there is more than one broken beam the program will not return valuable information.')
    end
end
guidata(hObject, handles);


% --- Executes on button press in beam4.
function beam4_Callback(hObject, eventdata, handles)
% hObject    handle to beam4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of beam4
if (get(hObject,'Value') == get(hObject,'Max'))
    if get(handles.discard_text,'String')=='0'
        set(handles.discard_text,'String','4')
    else
        set(handles.beam_text,'String','If there is more than one broken beam the program will not return valuable information.')
    end
end
guidata(hObject, handles);



function Eens1_Callback(hObject, eventdata, handles)
% hObject    handle to Eens1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Eens1 as text
%        str2double(get(hObject,'String')) returns contents of Eens1 as a double
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Eens1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Eens1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%% functions operating when certain buttons are pressed

% --- Executes on button press in beam_button.
function beam_button_Callback(hObject, eventdata, handles)
cla(subplot(1,1,1,'Parent',handles.beampanel),'reset');
% hObject    handle to beam_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ipf=get(handles.ipf,'String');
adcp_depth=str2double(get(handles.adcp_depth,'String'));
w_depth=str2double(get(handles.w_depth,'String'));
orient1=get(handles.orient1,'String');

adcp=rdradcp(ipf); % rdradcp is called

% Extract all the necessary variables generated by rdradcp and rename some
% of them.
name=adcp.name;
config=adcp.config;
temperature=adcp.temperature;
ssp=adcp.ssp;
mtime_all=adcp.mtime;
adc=adcp.adc;
E_4beam=adcp.intens;
number=adcp.number;
pitch=adcp.pitch;
roll=adcp.roll;
heading=adcp.heading;
salinity=adcp.salinity;
pressure=adcp.pressure;
SerEmmpersec=adcp.east_vel';
SerNmmpersec=adcp.north_vel';
SerVmmpersec=adcp.vert_vel';
SerErmmpersec=adcp.error_vel';
corr=adcp.corr;
perc_good=adcp.perc_good;
RDIBinSize=adcp.config.cell_size;
SerBins=adcp.config.n_cells;
RDIBin1Mid=adcp.config.bin1_dist;
SerCAcnt=squeeze(mean(corr,2))';

% Update orientation (appears to always be "up" in the files)
contents_orient1=get(handles.orient1,'String');
%fprintf(contents_orient1{get(handles.orient1,'Value')});
if strcmp(contents_orient1{get(handles.orient1,'Value')},'Up');
    adcp.config.orientation='up';
    config.orientation='up';
elseif strcmp(contents_orient1{get(handles.orient1,'Value')},'Down');
    adcp.config.orientation='do';
    config.orientation='do';
end
    
%%check if there are any bad beams
subplot(1,1,1,'Parent',handles.beampanel)
plot(squeeze(E_4beam(1,1,:)));
hold on
plot(squeeze(E_4beam(1,2,:)),'r');
plot(squeeze(E_4beam(1,3,:)),'g');                                            
plot(squeeze(E_4beam(1,4,:)),'k');
legend(gca,{'beam 1','beam 2','beam 3','beam 4'},'location','eastoutside')

set(handles.beam_text,'Visible','on')
set(handles.beam1,'Visible','on')
set(handles.beam2,'Visible','on')
set(handles.beam3,'Visible','on')
set(handles.beam4,'Visible','on')
set(handles.E_ref_button,'Visible','on')

% Create a temporary file holding all the important variables.
save C:\temp\beamdata.mat name config temperature ssp mtime_all adc number pitch roll heading adcp_depth w_depth salinity pressure SerEmmpersec SerNmmpersec SerVmmpersec SerErmmpersec SerCAcnt perc_good RDIBinSize SerBins RDIBin1Mid corr E_4beam
guidata(hObject, handles);



% --- Executes on button press in E_ref_button.
function E_ref_button_Callback(hObject, eventdata, handles)
% hObject    handle to E_ref_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load C:\temp\beamdata.mat name config temperature ssp mtime_all adc number pitch roll heading adcp_depth w_depth salinity pressure SerEmmpersec SerNmmpersec SerVmmpersec SerErmmpersec SerCAcnt perc_good RDIBinSize SerBins RDIBin1Mid corr E_4beam
% Loading the temporary file to calculate SerEAAcnt.
badbeam=str2double(get(handles.discard_text,'String'));
good=nan*ones(1,4);

%Obtain beam averages for SerEAAcnt (raw backscatter data). Bad beams are discarded before
%averaging.

if badbeam~=0
    for j=1:4
        if j~=badbeam
            good(j)=1;                                                      
        end
    end
    good=find(~isnan(good));
    SerEAAcnt=squeeze(mean(E_4beam(:,good,:),2));
else
    SerEAAcnt=squeeze(mean(E_4beam,2));
end
SerEAAcnt=SerEAAcnt';

% Echo intensity reference level
% Gives the user the chance to choose the right number to calculate
% E_ref from.
figure(1)
clf
%plot(SerEAAcnt(1:1500,1))
plot(SerEAAcnt(:,1))
xlabel('Ensemble number')
ylabel('Counts')
title('Echo Intensity for Bin #1')
set(handles.E_ref_text,'Visible','on')
set(handles.text10,'Visible','on')
set(handles.text11,'Visible','on')
set(handles.Eens1,'Visible','on')
set(handles.Eens2,'Visible','on')
set(handles.interaction,'String','Once you have typed in the requested number please click the save button.')
set(handles.save_button,'Visible','on')
% Save the new variable.
save C:\temp\beamdata.mat name config temperature ssp mtime_all adc number pitch roll heading adcp_depth w_depth salinity pressure SerEmmpersec SerNmmpersec SerVmmpersec SerErmmpersec SerCAcnt perc_good RDIBinSize SerBins RDIBin1Mid corr E_4beam SerEAAcnt
guidata(hObject, handles);



% --- Executes on button press in save_button.
function save_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
opf=get(handles.opf,'String');
load C:\temp\beamdata.mat name config temperature ssp mtime_all adc number pitch roll heading adcp_depth w_depth salinity pressure SerEmmpersec SerNmmpersec SerVmmpersec SerErmmpersec SerCAcnt perc_good RDIBinSize SerBins RDIBin1Mid corr E_4beam SerEAAcnt
% load the data generated and extracted by rdradcp

% Calculate E_ref from the input.
Eens1=str2double(get(handles.Eens1,'String'));
Eens2=str2double(get(handles.Eens2,'String'));
E_ref=SerEAAcnt(Eens1:Eens2,:);
E_ref=mean(E_ref(find(~isnan(E_ref))));
% Comment out and edit line below if E_ref can't be calculated from data
% E_ref=41.1289; % KF_17_18_U
set(handles.display_text,'String',['Mean Echo Intensity Reference Level: ',num2str(E_ref)])
set(handles.qc_button,'Visible','on')

% Save all the variables to the file indicated by the user.
eval(['save ', opf, ' name config temperature ssp mtime_all adc SerEAAcnt number pitch roll heading adcp_depth w_depth salinity pressure SerEmmpersec SerNmmpersec SerVmmpersec SerErmmpersec SerCAcnt perc_good RDIBinSize SerBins RDIBin1Mid corr E_4beam E_ref'])
delete C:\temp\beamdata.mat % The temporary file holding the rdradcp output is being deleted.
guidata(hObject, handles);



% --- Executes on button press in qc_button.
function qc_button_Callback(hObject, eventdata, handles)
% hObject    handle to qc_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run adcp_qc_gui
guidata(hObject, handles);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over inbrowse.
function inbrowse_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to inbrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function inbrowse_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inbrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function Eens2_Callback(hObject, eventdata, handles)
% hObject    handle to Eens2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Eens2 as text
%        str2double(get(hObject,'String')) returns contents of Eens2 as a double


% --- Executes during object creation, after setting all properties.
function Eens2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Eens2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function text10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in orient.
function orient_Callback(hObject, eventdata, handles)
% hObject    handle to orient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns orient contents as cell array
%        contents{get(hObject,'Value')} returns selected item from orient


% --- Executes during object creation, after setting all properties.
function orient_CreateFcn(hObject, eventdata, handles)
% hObject    handle to orient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in orient1.
function orient1_Callback(hObject, eventdata, handles)
% hObject    handle to orient1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns orient1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from orient1


% --- Executes during object creation, after setting all properties.
function orient1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to orient1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
