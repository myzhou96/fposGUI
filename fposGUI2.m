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

% handles = setup_Frame_Plots(handles);
% handles = setup_OSA_Plots(handles);
% handles = setup_SROA_Plots(handles);
% handles = setup_Vicon_Plots(handles);

set(handles.magnetometer_check,'Value',1);
handles.mag.on = 1;

set(handles.SROA_check,'Value',1);
handles.sroa.on = 1;

set(handles.vicon_check,'Value',0);
handles.vicon.on = 0;

handles.trial_num = 0;

% Update handles structure
guidata(hObject, handles);

% addpath('C:\Users\user\Box Sync\SPECTRE\Code and Sensors\GUI\SROA_scripts')
% addpath('C:\Users\user\Box Sync\SPECTRE\Code and Sensors\GUI\IMU_scripts')
% addpath('C:\Users\user\Box Sync\SPECTRE\Code and Sensors\GUI\Vicon_scripts\Given Library');

% UIWAIT makes fposGUI2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% netsh wlan connect name="FPOS"
% putty -- 10.0.0.200, log data
% python TCPserver.py
% netsh wlan disconnect


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
    
    c = clock();
    handles.common_start_time = [c(4) c(5) c(6)];
    
    set(hObject, 'String', 'STOP');
    set(handles.contact_button, 'Value', 0);
    set(handles.capture_button, 'Value', 0);
    set(handles.bump_button, 'Value', 0);
    set(handles.impact_button, 'Value', 0);
    set(handles.notes_box, 'String', '-');
    
    handles.trial_num = handles.trial_num + 1;
    set(handles.run_num, 'String', handles.trial_num);
    
%     if handles.osa.on UNCOMMENT LATER
%         handles = reset_OSA_imu(handles);
%     end
%     if handles.frame.on
%         handles = reset_frame_imu(handles);
%     end
    guidata(hObject, handles);
    
    % initialize DAQ
%     cdaq_init UNCOMMENT LATER
    % initialize Vicon
%     Vicon_init
    
    % start collecting data from all sensors

%     while strcmp(get(hObject, 'String'), 'STOP') UNCOMMENT LATER
%         
%         disp('mark');
%         %IMUs
%         if handles.frame.on
%             tic
%             handles = update_frame_plot(handles);
%             toc
%         end
%         if handles.osa.on
%             tic
%             handles = update_osa_plots(handles);
%             toc
%         end
%         
%         if handles.sroa.on
%             % DAQ
%             tic
%             handles.common_time = common_clock(handles.common_start_time);
%             if abs(mod(handles.common_time,1/handles.sroa.plotDownSample)) < 1e-2
%                 % get data
%                 raw_data = daqSession.inputSingleScan;
%                 handles.SROA_data = SROA_conversion(raw_data);
%                 % log data !!! change SROA fid to incorporate experiment name eventually
%                 fprintf(SROA_fid,'%f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \n',handles.common_time,handles.SROA_data);
%                 % plot data
%                 if handles.sroa.on
%                     disp('plotting!');
%                     handles = update_sroa_plot(handles);
%                 end
%             end
%             toc
%         end
%         
%         % Vicon
%         if handles.vicon.on
%             tic
%             handles.common_time = common_clock(handles.common_start_time);
%             Vicon_grab
%             fprintf(Vicon_fid,'%8.4f \t %d \t %8.4f \t %8.4f \t %8.4f \t %8.4f \t %8.4f \t %8.4f \t %6.4f \t %6.4f \t %6.4f \t %6.4f \t %8.4f \t %8.4f \t %8.4f \t %8.4f \t %8.4f \t %8.4f \t %8.4f \t %6.4f \t %6.4f \t %6.4f \t %8.4f \t %8.4f \t %8.4f \t %6.4f \t %6.4f \t %6.4f \t %6.4f \n',...
%                 handles.common_time,...
%                 handles.ViconFrame,...
%                 handles.ViconOSA.Position,...
%                 handles.ViconOSA.EulerAngGlobal,...
%                 handles.ViconOSA.QuaternionGlobal,...
%                 handles.ViconOSA.EulerAngBody,...
%                 handles.ViconOSA.QuaternionLocal,...
%                 handles.ViconSROA.Position,...
%                 handles.ViconSROA.EulerAngGlobal,...
%                 handles.ViconSROA.QuaternionGlobal);
%             if abs(mod(handles.common_time,1/handles.vicon.plotDownSample)) < 1e-3 && handles.vicon.on
%                 handles = update_vicon_plot(handles);
%             end
%             toc
%         end
%     end
    
elseif strcmp(str, 'STOP')
    set(hObject, 'String', 'GO');
    
    % DAQ
    % stops the daq session
    %     daqSession.stop;
    %     daqSession.release;
    % closes the log file
    %     fclose(all);
    
    %Save IMU data
%     if handles.frame.on UNCOMMENT LATER
%         handles = close_frame_imu(handles);
%     end
%     if handles.osa.on
%         handles = close_OSA_imu(handles);
%     end
%     guidata(hObject,handles);
    
    % Record to run log
    t = datestr([datetime]);
    fco = '-';
    fca = '-';
    fb = '-';
    fi = '-';
    if get(handles.contact_button, 'Value') == 1
        fco = 'Contact';
    end
    if get(handles.capture_button, 'Value') == 1
        fca = 'Capture';
    end
    if get(handles.bump_button, 'Value') == 1
        fb = 'Bump';
    end
    if get(handles.impact_button, 'Value') == 1
        fi = 'Impact';
    end
    notes = get(handles.notes_box,'String');
    d = get(handles.distance, 'String');
    a = get(handles.angle, 'String');
    trial_num_int = int2str(handles.trial_num);
    exp_name = strcat(get(handles.name, 'String'), '_', d, '_', a, '_', trial_num_int);
    exc = actxserver('Excel.Application');
    exc.Visible = 1;
    xlsappend('experiment_log.xls', {exp_name t fco fca fb fi notes}, 1);
    
end


% --- Executes on button press in start_button.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
state = get(hObject,'Value');
if state == get(hObject,'Max')
    display('start down');
%     if handles.osa.on UNCOMMENT LATER
%         handles = init_OSA_imu(handles);
%     end
%     if handles.frame.on
%         handles = init_frame_imu(handles);
%     end
elseif state == get(hObject,'Min')
    display('start up');
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
    display('contact down');
elseif state == get(hObject,'Min')
    display('contact up');
end


% --- Executes on button press in capture_button.
function capture_button_Callback(hObject, eventdata, handles)
% hObject    handle to capture_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of capture_button
state = get(hObject,'Value');
if state == get(hObject,'Max')
    display('capture down');
elseif state == get(hObject,'Min')
    display('capture up');
end


% --- Executes on button press in bump_button.
function bump_button_Callback(hObject, eventdata, handles)
% hObject    handle to bump_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bump_button
state = get(hObject,'Value');
if state == get(hObject,'Max')
    display('bump down');
elseif state == get(hObject,'Min')
    display('bump up');
end


% --- Executes on button press in impact_button.
function impact_button_Callback(hObject, eventdata, handles)
% hObject    handle to impact_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of impact_button
state = get(hObject,'Value');
if state == get(hObject,'Max')
    display('impact down');
elseif state == get(hObject,'Min')
    display('impact up');
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
    %     fclose(handles.osa.u);
    delete(handles.osa.u);
end
if isfield(handles,'frame')
    delete(handles.frame.u);
end
