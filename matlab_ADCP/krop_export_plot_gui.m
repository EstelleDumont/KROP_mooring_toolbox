function varargout = krop_export_plot_gui(varargin)
% KROP_EXPORT_PLOT_GUI MATLAB code for krop_export_plot_gui.fig
%      KROP_EXPORT_PLOT_GUI, by itself, creates a new KROP_EXPORT_PLOT_GUI or raises the existing
%      singleton*.
%
%      H = KROP_EXPORT_PLOT_GUI returns the handle to a new KROP_EXPORT_PLOT_GUI or the handle to
%      the existing singleton*.
%
%      KROP_EXPORT_PLOT_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in KROP_EXPORT_PLOT_GUI.M with the given input arguments.
%
%      KROP_EXPORT_PLOT_GUI('Property','Value',...) creates a new KROP_EXPORT_PLOT_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before krop_export_plot_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to krop_export_plot_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help krop_export_plot_gui

% Last Modified by GUIDE v2.5 14-Oct-2022 09:53:15
% Created by ESDU, SAMS, Oct22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @krop_export_plot_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @krop_export_plot_gui_OutputFcn, ...
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


% --- Executes just before krop_export_plot_gui is made visible.
function krop_export_plot_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to krop_export_plot_gui (see VARARGIN)

% Choose default command line output for krop_export_plot_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes krop_export_plot_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = krop_export_plot_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function txt_root_dir_Callback(hObject, eventdata, handles)
% hObject    handle to txt_root_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_root_dir as text
%        str2double(get(hObject,'String')) returns contents of txt_root_dir as a double


% --- Executes during object creation, after setting all properties.
function txt_root_dir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_root_dir (see GCBO)
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

% First reset output list handle value (in case another directory was
% selected previously)
set(handles.list_moor,'Value',1)
% Make next steps invisible until a mooring is selected
set(handles.list_moor,'Visible','off');
set(handles.text_export,'Visible','off');
set(handles.btn_export_mat,'Visible','off');
set(handles.btn_export_csv,'Visible','off');
set(handles.txt_result_mat,'Visible','off');
set(handles.txt_result_csv,'Visible','off');
set(handles.uipanel_dates,'Visible','off');
set(handles.uipanel_var,'Visible','off');
set(handles.text_plot,'Visible','off');
set(handles.btn_plot,'Visible','off');
set(handles.btn_checkmask,'Visible','off');
set(handles.uipanel_dates2,'Visible','off');
set(handles.uipanel_var2,'Visible','off');
set(handles.uipanel_plot_setup,'Visible','off');
set(handles.txt_result_plot,'Visible','off');
% Let user browse for correct directory
root_dir=uigetdir();
set(handles.txt_root_dir,'String',root_dir);
% Once the directory is selected look for list of moorings available, by
% looking for the list of subdirectories
dir_contents = dir(root_dir);
% Get names of all subfolders
dir_flags = [dir_contents.isdir];
dir_sf = dir_contents(dir_flags);
dir_sf_names = {dir_sf(3:end).name};
% Now figure out which ones might be mooring subfolders - look for folders
% with two '_' in name. Worst case scenario if another directory also has
% two underscores in its name it'll get added to the list.
moorings{1} = 'Please select mooring from list...';
dd = 1;
for d = 1:length(dir_sf_names)
    dir_bits = strsplit(dir_sf_names{1,d},'_');
    if size(dir_bits,2)==3
        moorings{dd+1} = dir_sf_names{1,d};
        dd = dd+1;
    end        
end
clear d dd dir_*
% Add error message if no moorings found in specified directory
if size(moorings,2)<=1 % found moorings sub-folders
    moorings{1} = 'No moorings found in selected folder';
end
% Add moorings / error msg to the drop-down list
set(handles.list_moor,'String',moorings);
% Make list visible
set(handles.text_moor_id,'Visible','on');
set(handles.list_moor,'Visible','on');



% --- Executes during object creation, after setting all properties.
function list_moor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_moor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in list_moor.
function list_moor_Callback(hObject, eventdata, handles)
% hObject    handle to list_moor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns list_moor contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_moor

% Make next steps (data export & plot) visible
set(handles.text_export,'Visible','on');
set(handles.btn_export_mat,'Visible','on');
set(handles.btn_export_csv,'Visible','on');
set(handles.uipanel_dates,'Visible','on');
set(handles.uipanel_var,'Visible','on');
set(handles.text_plot,'Visible','on');
set(handles.btn_plot,'Visible','on');
set(handles.btn_checkmask,'Visible','on');
set(handles.uipanel_dates2,'Visible','on');
set(handles.uipanel_var2,'Visible','on');
set(handles.uipanel_plot_setup,'Visible','on');

% Get moorings start and end times from info file (can be adjusted by user in GUI window)
root_dir = get(handles.txt_root_dir,'String');
moor_list = get(handles.list_moor,'String');
moor_ind = get(handles.list_moor,'Value');
moor_id = moor_list{moor_ind};
info_fl = [root_dir '\' moor_id '\mat\' moor_id '_info.mat'];
if exist(info_fl,'file')
    info = load(info_fl);
    set(handles.txt_start,'String',datestr(info.start_date,'dd-mmm-yyyy'));
    set(handles.txt_end,'String',datestr(info.end_date,'dd-mmm-yyyy'));
    set(handles.txt_start2,'String',datestr(info.start_date,'dd-mmm-yyyy'));
    set(handles.txt_end2,'String',datestr(info.end_date,'dd-mmm-yyyy'));
end

% Get list of files and make first guess at instrument order for the plots
% (user can amend in GUI)
% Note: this step could be skipped if ADCP info was added to the info_file
% in future versions of the code. Alternatively, the code could look into
% the ADCP files and check bin depths. Something to do later!
% Go to mat directory and get file list
matlab_dir = [root_dir '\processing\matlab_ADCP'];
mat_dir  = [root_dir '\' moor_id '\mat'];
eval(['cd ' mat_dir ])
m_str = [moor_id '_ADCP_*.mat'];
fl_list = dir(m_str);
% Go back to processig folder
eval(['cd ' matlab_dir ])
% First check if there is processed ADCP data for this mooring, if not
% display error message
if isempty(fl_list)
    set(handles.list_top,'String',{'No ADCP data found for this mooring'})
    set(handles.list_bot,'String',{'No ADCP data found for this mooring'})
elseif length(fl_list) == 1 % Only one ADCP
    str1 = fl_list(1).name;
    str2 = 'n/a';
    top_list_str = {str1 str2};
    bot_list_str = {str2 str1};
    set(handles.list_top,'String',top_list_str)
    set(handles.list_bot,'String',bot_list_str)
else
    % First check if we have the most common case, i.e. files _D and _U
    if regexp(fl_list(1).name,[moor_id '_ADCP_D.mat']) & regexp(fl_list(2).name,[moor_id '_ADCP_U.mat'])
        str1 = fl_list(1).name;
        str2 = fl_list(2).name;
        % Set U at top and D at bottom
        top_list_str = {str2 str1};
        bot_list_str = {str1 str2};
        set(handles.list_top,'String',top_list_str)
        set(handles.list_bot,'String',bot_list_str)
    elseif regexp(fl_list(1).name,[moor_id '_ADCP_U1.mat']) & regexp(fl_list(2).name,[moor_id '_ADCP_U2.mat'])
        % two upwards-looking ADCPs
        str1 = fl_list(1).name;
        str2 = fl_list(2).name;
        % Set U1 at top and U2 at bottom
        top_list_str = {str1 str2};
        bot_list_str = {str2 str1};
        set(handles.list_top,'String',top_list_str)
        set(handles.list_bot,'String',bot_list_str)
    elseif regexp(fl_list(1).name,[moor_id '_ADCP_D1.mat']) & regexp(fl_list(2).name,[moor_id '_ADCP_D2.mat'])
        % two downwards-looking ADCPs
        str1 = fl_list(1).name;
        str2 = fl_list(2).name;
        % Set D1 at top and D2 at bottom
        top_list_str = {str1 str2};
        bot_list_str = {str2 str1};
        set(handles.list_top,'String',top_list_str)
        set(handles.list_bot,'String',bot_list_str)
    else
       % more than 2 ADCPs, or filenames not recognised - just list in
       % alphabetical order
        set(handles.list_top,'String',{fl_list(:).name})
        set(handles.list_bot,'String',{fl_list(:).name})
    end
end



% --- Executes on button press in btn_export_mat.
function btn_export_mat_Callback(hObject, eventdata, handles)
% hObject    handle to btn_export_mat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Export mat file
root_dir = get(handles.txt_root_dir,'String');
moor_list = get(handles.list_moor,'String');
moor_ind = get(handles.list_moor,'Value');
moor_id = moor_list{moor_ind};
[err_mat,err_msg_mat,out_mat] = KROP_export_adcp_mat(root_dir,moor_id);

% Show results window
set(handles.txt_result_mat,'Visible','on');
if err_mat==1
    % Make text window smaller (only one line of text)
    ws = get(handles.txt_result_mat,'Position');
    ws2 = [ws(1),ws(2)+(ws(4)/2)-(1.25/2),ws(3),1.25];
    set(handles.txt_result_mat,'Position',ws2)
    % set(handles.txt_result_mat,'String',err_msg_mat,'BackGroundColor','r')
    set(handles.txt_result_mat,'String',err_msg_mat,'BackGroundColor',[1,0.7,0.5])
else
    set(handles.txt_result_mat,'String',['The data has now been saved as: ' out_mat],'BackGroundColor','c')
end



% --- Executes on button press in checkbox_sv.
function checkbox_sv_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_sv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox_vv.
function checkbox_vv_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_vv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox_u.
function checkbox_u_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_u (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox_v.
function checkbox_v_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox_spd.
function checkbox_spd_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_spd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox_dir.
function checkbox_dir_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in btn_export_csv.
function btn_export_csv_Callback(hObject, eventdata, handles)
% hObject    handle to btn_export_csv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get mooring info
root_dir = get(handles.txt_root_dir,'String');
moor_list = get(handles.list_moor,'String');
moor_ind = get(handles.list_moor,'Value');
moor_id = moor_list{moor_ind};

% Get start and end dates
start_date = get(handles.txt_start,'String');
end_date = get(handles.txt_end,'String');

% Get list of variables from checkboxes
f_sv = get(handles.checkbox_sv,'Value');
f_vv = get(handles.checkbox_vv,'Value');
f_u = get(handles.checkbox_u,'Value');
f_v = get(handles.checkbox_v,'Value');
f_spd = get(handles.checkbox_spd,'Value');
f_dir = get(handles.checkbox_dir,'Value');

% Edit results window to indicate something is happening
set(handles.txt_result_csv,'Visible','on');
set(handles.txt_result_csv,'String','                                          Processing...','BackGroundColor','y')
pause(1)
% Calculate & export weekly 30-minutes interpolated data
err_msg = interpolate_adcp_data_30min_weekly(root_dir,moor_id,start_date,end_date,...
    1,f_sv,f_vv,f_u,f_v,f_spd,f_dir);
% Confirm export when done
if isempty(err_msg)
    set(handles.txt_result_csv,'String','                                        Data exported',...
        'BackGroundColor','c')
else
    set(handles.txt_result_csv,'String',err_msg,'BackGroundColor',[1,0.7,0.5])
end



function txt_start_Callback(hObject, eventdata, handles)
% hObject    handle to txt_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_start as text
%        str2double(get(hObject,'String')) returns contents of txt_start as a double


% --- Executes during object creation, after setting all properties.
function txt_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function txt_end_Callback(hObject, eventdata, handles)
% hObject    handle to txt_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_end as text
%        str2double(get(hObject,'String')) returns contents of txt_end as a double


% --- Executes during object creation, after setting all properties.
function txt_end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_checkmask.
function btn_checkmask_Callback(hObject, eventdata, handles)
% hObject    handle to btn_checkmask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Function to create a single plot, to allow user to check the depth of the
% noisy surface bin(s), to use as the masking depths in the main plot function.
% Get mooring info
root_dir = get(handles.txt_root_dir,'String');
moor_list = get(handles.list_moor,'String');
moor_ind = get(handles.list_moor,'Value');
moor_id = moor_list{moor_ind};

% Get plot setup
inst_top_s = get(handles.list_top,'String'); inst_top_v = get(handles.list_top,'Value');
inst_top = inst_top_s{inst_top_v};
inst_bot_s = get(handles.list_bot,'String'); inst_bot_v = get(handles.list_bot,'Value');
inst_bot = inst_bot_s{inst_bot_v};

% Set to test_run case (to show one week of data on screeen, but not save).
test_run = 1;

% Set mask depth to 0 to see full dataset
mask_depth = 0;

% Only plot first week fo adta for test run
start_date = get(handles.txt_start,'String');
end_date   = datestr(datenum(start_date,'dd-mmm-yyyy')+7,'dd-mmm-yyyy');

% Only generate first plot for test run
f_svw = 1;
f_uv = 0;
f_sd = 0;

% Edit results window to indicate something is happening
set(handles.txt_result_plot,'Visible','on');
set(handles.txt_result_plot,'String','                                               Processing...','BackGroundColor','y')
pause(1)
% Plot weekly 30-minutes averaged data
err_msg = plot_adcp_data_weekly(root_dir,moor_id,inst_top,inst_bot,...
    mask_depth,start_date,end_date,f_svw,f_uv,f_sd,test_run);
% Confirm when done
if isempty(err_msg)
    set(handles.txt_result_plot,'String','Test run data plotted. Zoom in to determine surface layer depth to mask.',...
        'BackGroundColor','c')
else
    set(handles.txt_result_plot,'String',err_msg,'BackGroundColor',[1,0.7,0.5])
end


% --- Executes on button press in btn_plot.
function btn_plot_Callback(hObject, eventdata, handles)
% hObject    handle to btn_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get mooring info
root_dir = get(handles.txt_root_dir,'String');
moor_list = get(handles.list_moor,'String');
moor_ind = get(handles.list_moor,'Value');
moor_id = moor_list{moor_ind};

% Get plot setup
inst_top_s = get(handles.list_top,'String'); inst_top_v = get(handles.list_top,'Value');
inst_top = inst_top_s{inst_top_v};
inst_bot_s = get(handles.list_bot,'String'); inst_bot_v = get(handles.list_bot,'Value');
inst_bot = inst_bot_s{inst_bot_v};
mask_depth = str2double(get(handles.txt_mask,'String'));

% Get start and end dates
start_date = get(handles.txt_start2,'String');
end_date = get(handles.txt_end2,'String');

% Get list of variables from checkboxes
f_svw = get(handles.checkbox_svw,'Value');
f_uv = get(handles.checkbox_uv,'Value');
f_sd = get(handles.checkbox_sd,'Value');

% Edit results window to indicate something is happening
set(handles.txt_result_plot,'Visible','on');
set(handles.txt_result_plot,'String','                                                                    Processing...','BackGroundColor','y')
pause(1)
% Plot weekly 30-minutes averaged data
err_msg = plot_adcp_data_weekly(root_dir,moor_id,inst_top,inst_bot,...
    mask_depth,start_date,end_date,f_svw,f_uv,f_sd,0);
% Confirm when done
if isempty(err_msg)
    set(handles.txt_result_plot,'String','                                                              Plotted & saved',...
        'BackGroundColor','c')
else
    set(handles.txt_result_plot,'String',err_msg,'BackGroundColor',[1,0.7,0.5])
end



function txt_start2_Callback(hObject, eventdata, handles)
% hObject    handle to txt_start2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_start2 as text
%        str2double(get(hObject,'String')) returns contents of txt_start2 as a double


% --- Executes during object creation, after setting all properties.
function txt_start2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_start2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_end2_Callback(hObject, eventdata, handles)
% hObject    handle to txt_end2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_end2 as text
%        str2double(get(hObject,'String')) returns contents of txt_end2 as a double


% --- Executes during object creation, after setting all properties.
function txt_end2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_end2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_svw.
function checkbox_svw_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_svw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox_uv.
function checkbox_uv_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_uv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox_sd.
function checkbox_sd_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_sd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in list_top.
function list_top_Callback(hObject, eventdata, handles)
% hObject    handle to list_top (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_top contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_top


% --- Executes during object creation, after setting all properties.
function list_top_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_top (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in list_bot.
function list_bot_Callback(hObject, eventdata, handles)
% hObject    handle to list_bot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_bot contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_bot


% --- Executes during object creation, after setting all properties.
function list_bot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_bot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_mask_Callback(hObject, eventdata, handles)
% hObject    handle to txt_mask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_mask as text
%        str2double(get(hObject,'String')) returns contents of txt_mask as a double


% --- Executes during object creation, after setting all properties.
function txt_mask_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_mask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
