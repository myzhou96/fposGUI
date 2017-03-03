function [handles] = setup_Vicon_Plots(handles)

%Automatically turn on plot
% set(handles.vicon_check,'Value',1);
handles.vicon.on = 1;


%% Create Pressure Plot
% quaternion: the handle of the vicon quaternion plot

handles.vicon.qx_axis = plot(handles.quaternion,0,nan(1),'-r');
hold(handles.quaternion,'on');
handles.vicon.qy_axis = plot(handles.quaternion,0,nan(1),'-g');
handles.vicon.qz_axis = plot(handles.quaternion,0,nan(1),'-b');
handles.vicon.qs_axis = plot(handles.quaternion,0,nan(1),'-k');
hold(handles.quaternion,'off');

title(handles.quaternion,'OSA Quaternion-Time','FontSize',10,'FontWeight','bold');
xlabel(handles.quaternion,'Time, t (s)');
ylabel(handles.quaternion,'Quaternion');

axis(handles.quaternion,'auto');
box(handles.quaternion,'on');

xlim(handles.quaternion,[0 10]);



%% Create Position Plot

handles.vicon.posx_axis = plot(handles.position,0,nan(1),'-r');
hold(handles.position,'on');
handles.vicon.posy_axis = plot(handles.position,0,nan(1),'-g');
handles.vicon.posz_axis = plot(handles.position,0,nan(1),'-b');
hold(handles.position,'off');

title(handles.position,'OSA Position-Time','FontSize',10,'FontWeight','bold');
xlabel(handles.position,'Time, t (s)');
ylabel(handles.position,'Position [mm]');

axis(handles.position,'auto');
box(handles.position,'on');
xlim(handles.position,[0 10]);

%% Pre-allocate Data for Plots
%Creates new fields in the handles structure
%so that this data can be used in other functions in this GUI

handles.vicon.time = 1:5000;
handles.vicon.posx = zeros(1,5000);
handles.vicon.posy = zeros(1,5000);
handles.vicon.posz = zeros(1,5000);
handles.vicon.qx = zeros(1,5000);
handles.vicon.qy = zeros(1,5000);
handles.vicon.qz = zeros(1,5000);
handles.vicon.qs = zeros(1,5000);

%% Other variables for updating plots
handles.vicon.k = 1;
handles.vicon.idx = 1;
handles.vicon.commontime = 0;
handles.vicon.lefttime = 1;

%vicon Plots will update every 1/n sample points
handles.vicon.plotDownSample = 5;

