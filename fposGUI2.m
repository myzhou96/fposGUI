function varargout = fposGUI2(varargin)


%%% LAST UPDATED: 1/26/2017 8:06 pm


% FPOSGUI2 MATLAB code for fposGUI2.fig
%      FPOSGUI2, by itself, creates a new FPOSGUI2 or raises the existing
%      singleton*.
%
%      H = FPOSGUI2 returns the handle to a new FPOSGUI2 or the handle to
%      the existing singleton*.
%
%      FPOSGUI2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FPOSGUI2.M with the given input arguments.
%
%      FPOSGUI2('Property','Value',...) creates a new FPOSGUI2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fposGUI2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fposGUI2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fposGUI2

% Last Modified by GUIDE v2.5 08-Feb-2017 14:19:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @fposGUI2_OpeningFcn, ...
    'gui_OutputFcn',  @fposGUI2_OutputFcn, ...
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


% --- Executes just before fposGUI2 is made visible.
function fposGUI2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fposGUI2 (see VARARGIN)

% Choose default command line output for fposGUI2
handles.output = hObject;

% Create plot titles, axes, and labels
handles = setup_Frame_Plots(handles);
handles = setup_OSA_Plots(handles);
handles = setup_SROA_Plots(handles);
handles = setup_Vicon_Plots(handles);

% Set default values for which sensors to collect data from
set(handles.magnetometer_check,'Value',1);
handles.mag.on = 1;
set(handles.SROA_check,'Value',1);
handles.sroa.on = 1;
set(handles.vicon_check,'Value',1);
handles.vicon.on = 1;
set(handles.ifa_check,'Value',1);
handles.ifa.on = 1;
set(handles.osa_check,'Value',1);
handles.osa.on = 1;

% Start time
c = clock();
handles.common_start_time = [c(4) c(5) c(6)];
common_time = common_clock(handles.common_start_time);
set(handles.common_start_time,'Value',common_time);

% Default variables
handles.trial_num = 0;

% Update handles structure
guidata(hObject, handles);

% addpath('C:\Users\user\Box Sync\SPECTRE\Code and Sensors\GUI\SROA_scripts')
% addpath('C:\Users\user\Box Sync\SPECTRE\Code and Sensors\GUI\IMU_scripts')
% addpath('C:\Users\user\Box Sync\SPECTRE\Code and Sensors\GUI\Vicon_scripts\Given Library');

% UIWAIT makes fposGUI2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = fposGUI2_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in go.
function go_Callback(hObject, eventdata, handles)
% hObject    handle to go (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = get(hObject, 'String');
disp(str);

if strcmp(str, 'GO')
    % Change GO to STOP and reset buttons
    set(hObject, 'String', 'STOP');
    set(handles.contact_button, 'Value', 0);
    set(handles.capture_button, 'Value', 0);
    set(handles.bump_button, 'Value', 0);
    set(handles.impact_button, 'Value', 0);
    set(handles.notes_box, 'String', '-');
    
    % Update trial number
    handles.trial_num = handles.trial_num + 1;
    set(handles.run_num, 'String', handles.trial_num);
    
    % Update log files to output to and reset plots
    if handles.osa.on
        handles = reset_OSA_imu(handles);
    end
    if handles.frame.on
        handles = reset_frame_imu(handles);
    end
    if handles.SROA.on
        % initialize DAQ
        cdaq_init;
        % handles = reset_SROA(handles);
        % SROA_fid = ?
    end
    if handles.vicon.on
        % initialize Vicon
        Vicon_init;
        % handles = reset_vicon(handles);
        % vicon_fid = ?
    end
    guidata(hObject, handles);
    
    % start collecting data from all sensors
    while strcmp(get(hObject, 'String'), 'STOP')
        disp('mark');
        
        % Collect and plot Frame IMU
        if handles.frame.on
            % tic
            handles = update_frame_plot(handles);
            % toc
        end
        
        % Collect and plot OSA IMU
        if handles.osa.on
            % tic
            handles = update_osa_plots(handles);
            % toc
        end
        
        % SROA Temperature and Pressure
        if handles.sroa.on
            % DAQ
            tic
            handles.common_time = common_clock(handles.common_start_time);
            if abs(mod(handles.common_time,1/handles.sroa.plotDownSample)) < 1e-2
                % get data
                raw_data = daqSession.inputSingleScan;
                handles.SROA_data = SROA_conversion(raw_data);
                % log data !!! change SROA fid to incorporate experiment name eventually
                fprintf(SROA_fid,'%f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \n',handles.common_time,handles.SROA_data);
                % plot data
                disp('SROA Data Collected');
                handles = update_sroa_plot(handles);
            end
            toc
        end
        
        % Vicon
        if handles.vicon.on
            tic
            % Collect data
            handles.common_time = common_clock(handles.common_start_time);
            Vicon_grab
            % Log data
            fprintf(Vicon_fid,'%8.4f \t %d \t %8.4f \t %8.4f \t %8.4f \t %8.4f \t %8.4f \t %8.4f \t %6.4f \t %6.4f \t %6.4f \t %6.4f \t %8.4f \t %8.4f \t %8.4f \t %8.4f \t %8.4f \t %8.4f \t %8.4f \t %6.4f \t %6.4f \t %6.4f \t %8.4f \t %8.4f \t %8.4f \t %6.4f \t %6.4f \t %6.4f \t %6.4f \n',...
                handles.common_time,...
                handles.ViconFrame,...
                handles.ViconOSA.Position,...
                handles.ViconOSA.EulerAngGlobal,...
                handles.ViconOSA.QuaternionGlobal,...
                handles.ViconOSA.EulerAngBody,...
                handles.ViconOSA.QuaternionLocal,...
                handles.ViconSROA.Position,...
                handles.ViconSROA.EulerAngGlobal,...
                handles.ViconSROA.QuaternionGlobal);
            % Update plots
            if abs(mod(handles.common_time,1/handles.vicon.plotDownSample)) < 1e-3 && handles.vicon.on
                handles = update_vicon_plot(handles);
            end
            toc
        end
    end
    
elseif strcmp(str, 'STOP')
    set(hObject, 'String', 'GO');
    
    % Close sockets and files
    if handles.frame.on
        handles = close_frame_imu(handles);
    end
    if handles.osa.on
        handles = close_OSA_imu(handles);
    end
    if handles.sroa.on
        % Close DAQ session
        daqSession.stop;
        daqSession.release;
        fclose(SROA_fid);
    end
    if handles.vicon.on
        fclose(vicon_fid);
    end
    guidata(hObject,handles);
    
    % Record events to experiment log
    t = datestr(now, 'dd/mm/yy HH:MM:SS.FFF');
    fco = '-';
    fca = '-';
    fb = '-';
    fi = '-';
    if get(handles.contact_button, 'Value') == 1
        fco = datestr(now, 'T''HH:MM:SS.FFF');
    end
    if get(handles.capture_button, 'Value') == 1
        fca = datestr(now, 'T''HH:MM:SS.FFF');
    end
    if get(handles.bump_button, 'Value') == 1
        fb = datestr(now, 'T''HH:MM:SS.FFF');
    end
    if get(handles.impact_button, 'Value') == 1
        fi = datestr(now, 'T''HH:MM:SS.FFF');
    end
    
    % Retrieve strings from edit boxes
    notes = get(handles.notes_box,'String');
    d = get(handles.distance, 'String');
    a = get(handles.angle, 'String');
    trial_num_int = int2str(handles.trial_num);
    handles.exp_name = strcat(get(handles.name, 'String'), '_', d, '_', a, '_', trial_num_int);
    
    % Append to excel file
    exc = actxserver('Excel.Application');
    exc.Visible = 1;
    xlsappend('experiment_log.xls', {handles.exp_name t fco fca fb fi notes}, 1);
    
end


% --- Executes on button press in start_button.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
state = get(hObject,'Value');

if state == get(hObject,'Max')
    disp('start down');
    if handles.osa.on
        handles = init_OSA_imu(handles);
    end
    if handles.frame.on
        handles = init_frame_imu(handles);
    end
elseif state == get(hObject,'Min')
    disp('start up');
end
guidata(hObject,handles);


% --- Executes on button press in ifa_check.
function ifa_check_Callback(hObject, eventdata, handles)
% hObject    handle to ifa_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ifa_check
if get(hObject,'Value') == 1
    handles.frame.on = 1;
else
    handles.frame.on = 0;
end
guidata(hObject,handles);


% --- Executes on button press in osa_check.
function osa_check_Callback(hObject, eventdata, handles)
% hObject    handle to osa_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of osa_check
if get(hObject,'Value') == 1
    handles.osa.on = 1;
else
    handles.osa.on = 0;
end
guidata(hObject,handles);


% --- Executes on button press in magnetometer_check.
function magnetometer_check_Callback(hObject, eventdata, handles)
% hObject    handle to magnetometer_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of magnetometer_check
if get(hObject,'Value') == 1
    handles.mag.on = 1;
else
    handles.mag.on = 0;
end
guidata(hObject,handles);


% --- Executes on button press in vicon_check.
function vicon_check_Callback(hObject, eventdata, handles)
% hObject    handle to vicon_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of vicon_check
if get(hObject,'Value') == 1
    handles.vicon.on = 1;
else
    handles.vicon.on = 0;
end
guidata(hObject,handles);


% --- Executes on button press in SROA_check.
function SROA_check_Callback(hObject, eventdata, handles)
% hObject    handle to SROA_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SROA_check
if get(hObject,'Value') == 1
    handles.sroa.on = 1;
else
    handles.sroa.on = 0;
end
guidata(hObject,handles);


% --- Executes on button press in contact_button.
function contact_button_Callback(hObject, eventdata, handles)
% hObject    handle to contact_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of contact_button
state = get(hObject,'Value');
if state == get(hObject,'Max')
    disp('contact down');
elseif state == get(hObject,'Min')
    disp('contact up');
end


% --- Executes on button press in capture_button.
function capture_button_Callback(hObject, eventdata, handles)
% hObject    handle to capture_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of capture_button
state = get(hObject,'Value');
if state == get(hObject,'Max')
    disp('capture down');
elseif state == get(hObject,'Min')
    disp('capture up');
end


% --- Executes on button press in bump_button.
function bump_button_Callback(hObject, eventdata, handles)
% hObject    handle to bump_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bump_button
state = get(hObject,'Value');
if state == get(hObject,'Max')
    disp('bump down');
elseif state == get(hObject,'Min')
    disp('bump up');
end


% --- Executes on button press in impact_button.
function impact_button_Callback(hObject, eventdata, handles)
% hObject    handle to impact_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of impact_button
state = get(hObject,'Value');
if state == get(hObject,'Max')
    disp('impact down');
elseif state == get(hObject,'Min')
    disp('impact up');
end


function notes_box_Callback(hObject, eventdata, handles)
% hObject    handle to notes_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of notes_box as text
%        str2double(get(hObject,'String')) returns contents of notes_box as a double


% --- Executes during object creation, after setting all properties.
function notes_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to notes_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function distance_Callback(hObject, eventdata, handles)
% hObject    handle to distance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of distance as text
%        str2double(get(hObject,'String')) returns contents of distance as a double


% --- Executes during object creation, after setting all properties.
function distance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to distance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function angle_Callback(hObject, eventdata, handles)
% hObject    handle to angle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of angle as text
%        str2double(get(hObject,'String')) returns contents of angle as a double


% --- Executes during object creation, after setting all properties.
function angle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to angle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% a = instrfindall;
% fclose(a(:));

if isfield(handles,'osa')
    % fclose(handles.osa.u);
    delete(handles.osa.u);
end
if isfield(handles,'frame')
    delete(handles.frame.u);
end


% --- Executes on button press in togglebutton10.
function togglebutton10_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton10


% --- Executes on button press in exp_type_closeEQ.
function exp_type_closeEQ_Callback(hObject, eventdata, handles)
% hObject    handle to exp_type_closeEQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of exp_type_closeEQ


% --- Executes on button press in exp_type_SOI.
function exp_type_SOI_Callback(hObject, eventdata, handles)
% hObject    handle to exp_type_SOI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of exp_type_SOI


% --- Executes on button press in exp_type_capture.
function exp_type_capture_Callback(hObject, eventdata, handles)
% hObject    handle to exp_type_capture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of exp_type_capture


function common_time_Callback(hObject, eventdata, handles)
% hObject    handle to common_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of common_time as text
%        str2double(get(hObject,'String')) returns contents of common_time as a double
common_time = common_clock(handles.common_start_time);
set(handles.common_time,'Value',common_time);


% --- Executes during object creation, after setting all properties.
function common_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to common_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end