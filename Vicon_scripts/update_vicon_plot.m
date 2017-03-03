function handles = update_vicon_plot(handles)
%Update function for the vicon sensors. Pulls data off of daq session
%listener and updates the plots of the GUI.

%Inputs:
%   handles -       The structure containing all of the handles in the GUI.

%Outputs:
%   handles -       An updated structure containing all of the updated handles in the GUI

disp('vicon mark');

%% Assign to Pre-allocated Variables

%Assignments
handles.vicon.time(handles.vicon.k) = handles.common_time;
handles.vicon.posx(handles.vicon.k) = handles.ViconOSA.Position(1);
handles.vicon.posy(handles.vicon.k) = handles.ViconOSA.Position(2);
handles.vicon.posz(handles.vicon.k) = handles.ViconOSA.Position(3);
handles.vicon.qx(handles.vicon.k) = handles.ViconOSA.QuaternionGlobal(1);
handles.vicon.qy(handles.vicon.k) = handles.ViconOSA.QuaternionGlobal(2);
handles.vicon.qz(handles.vicon.k) = handles.ViconOSA.QuaternionGlobal(3);
handles.vicon.qs(handles.vicon.k) = handles.ViconOSA.QuaternionGlobal(4);

%toc

%% Plot data

%  tic

%Update plot
%Update position x and y data
set(handles.vicon.qx_axis,...
    'Xdata',handles.vicon.time(handles.vicon.lefttime:handles.vicon.k),...
    'Ydata',handles.vicon.qx(handles.vicon.lefttime:handles.vicon.k));
set(handles.vicon.qy_axis,...
    'Xdata',handles.vicon.time(handles.vicon.lefttime:handles.vicon.k),...
    'Ydata',handles.vicon.qy(handles.vicon.lefttime:handles.vicon.k));
set(handles.vicon.qz_axis,...
    'Xdata',handles.vicon.time(handles.vicon.lefttime:handles.vicon.k),...
    'Ydata',handles.vicon.qz(handles.vicon.lefttime:handles.vicon.k));
set(handles.vicon.qs_axis,...
    'Xdata',handles.vicon.time(handles.vicon.lefttime:handles.vicon.k),...
    'Ydata',handles.vicon.qs(handles.vicon.lefttime:handles.vicon.k));

%Update position x and y data
set(handles.vicon.posx_axis,...
    'Xdata',handles.vicon.time(handles.vicon.lefttime:handles.vicon.k),...
    'Ydata',handles.vicon.posx(handles.vicon.lefttime:handles.vicon.k));
set(handles.vicon.posy_axis,...
    'Xdata',handles.vicon.time(handles.vicon.lefttime:handles.vicon.k),...
    'Ydata',handles.vicon.posy(handles.vicon.lefttime:handles.vicon.k));
set(handles.vicon.posz_axis,...
    'Xdata',handles.vicon.time(handles.vicon.lefttime:handles.vicon.k),...
    'Ydata',handles.vicon.posz(handles.vicon.lefttime:handles.vicon.k));


%Adjust x limits on plots
if handles.vicon.time(handles.vicon.k) - handles.vicon.time(handles.vicon.lefttime) > 10
    
    handles.vicon.lefttime = floor((handles.vicon.k + handles.vicon.lefttime)/2);
    
    set(handles.quaternion,'xlim',...
        [handles.vicon.time(handles.vicon.k)-5 handles.vicon.time(handles.vicon.k)+5]);
    set(handles.position,'xlim',...
        [handles.vicon.time(handles.vicon.k)-5 handles.vicon.time(handles.vicon.k)+5]);
    
end

if ~handles.vicon.on
    drawnow;
end

drawnow

% Number of data points archived
handles.vicon.k = handles.vicon.k+1;

%   toc


end
