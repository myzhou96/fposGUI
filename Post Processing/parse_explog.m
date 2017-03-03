% read experiment_log and load IMU logs
path = 'C:\Users\user\Box Sync\SPECTRE\Code and Sensors\GUI\Test_Data\Mar_01\';
fileID = fopen([path 'experiment_log_3_1.csv'],'r');
fprintf('\nProcessing data for following directory: \n %s',path)
data = textscan(fileID,'%s%s%s%s%s%s%s%s%s','delimiter',',');
load([path 'FlightLogs\frame_log.mat'])
load([path 'FlightLogs\OSA_log.mat'])

% find unique experiment names
fprintf('\n with the following experiments: \n')
experiment_names = data{1,1}
start_times = data{1,2};
contact_times = data{1,3};
capture_times = data{1,4};
OSA_bump_times = data{1,5};
frame_bump_times = data{1,6};
good_test_times = data{1,7};
notes = data{1,8};
% for each experiment, generate the following information:
    % time of start: 'HH:MM:SS.FFF' string, hour int, min int, sec float
    % type of experiment: 'SOI', 'Capture', 'Close_EQ', 'Sync' string
    % displacement_set: distance cm double
    % path_angle_set: degrees double
    % run_number: number of experiments since start of flight day int
    % start time: when the experiment started
    % capture: binary event, 1 for captured, 0 for escaped int
    % contact: binary event, 1 for contact, 0 for no contact
    % OSA_bumped: empty vs. populated, no bumps if empty, bumps if
        % populated with time, hour int, min int, sec float, or all 0's
    % frame_bumped: empty vs. populated, no bumps if empty, bumps if
        % populated with time, hour int, min int, sec float, or all 0's
    % good_test: binary event, 1 for good, 0 for bad
    % Notes: any miscellaneous notes from observation, string
    % Vicon_data: struct generated from parse_Vicon
    % frame_data: struct generated from parse_IMU
    % OSA_data: struct generated from parse_IMU
    % SROA_data: struct generated from parse_SROA
num_exp = length(experiment_names);
for i = 1:num_exp
    % the following information obtained from experiment_log.csv
    exp.name = char(experiment_names{i,1});
    [exp.type, remain] = strtok(experiment_names(i,1), '_');
    [displacement_set_str, remain] = strtok(remain,'_');
    exp.displacement_set = str2double(displacement_set_str);
    [path_angle_set_str, remain] = strtok(remain,'_');
    exp.path_angle_set = str2double(path_angle_set_str);
    run_number_str = strtok(remain,'_');
    exp.start_time = start_times{i,1}(10:end);
    exp.run_number = str2double(run_number_str);
    exp.capture_flag = abs(1 - isempty(capture_times{i,1}));
    exp.capture_timestamps = capture_times{i,1};
    exp.contact_flag = abs(1 - isempty(contact_times{i,1}));
    exp.contact_timestamps = contact_times{i,1};
    exp.OSA_bump_flag = abs(1 - isempty(OSA_bump_times{i,1}));
    exp.OSA_bump_timestamps = OSA_bump_times{i,1};
    exp.frame_bump_flag = abs(1 - isempty(frame_bump_times{i,1}));
    exp.frame_bump_timestamps = frame_bump_times{i,1};
    exp.good_flag = abs(1 - isempty(good_test_times{i,1}));
    exp.notes = notes{i,1};
    % the following information obtained from respective sensor logs
    exp.Vicon_data = parse_Vicon(path,[exp.name '_VICON.txt']);
        % change to log once implemented
    exp.OSA_GUI = parse_IMU(path,[exp.name '_OSA.csv']);
    OSA_ID = [exp.OSA_GUI.ID(1) exp.OSA_GUI.ID(end)];
    exp.OSA_data = cut_log(OSA_log,OSA_ID);
    exp.IFA_GUI = parse_IMU(path,[exp.name '_IFA.csv']);
    IFA_ID = [exp.IFA_GUI.ID(1) exp.IFA_GUI.ID(end)];
    exp.IFA_data = cut_log(frame_log,IFA_ID);
%     exp.SROA_data = parse_SROA(path,[exp.name '_SROA.txt']);
    % save as a mat file for easy access later
    save([path experiment_names{i,1} '_merged'],'exp')
    fprintf('parsed %s\n',experiment_names{i,1})
%     pause
end