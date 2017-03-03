function [out] = parse_IMU(path,fileName)
% Parses CSV files to obtain gyroscope and accelerometer data from raw IMU
% output files. This scripts is meant to be used as a helper function.

%Modified to use counter values to calculate time stamps rather than sample
%numbers. This was done to mitigate the effect of error data points.

%Updated csvRead3 to parse_IMU on 2.24.17
% Changed timestamping to use log start and log end instead of log duration

%close all

time = [];
Gx = [];
Gy = [];
Gz = [];
Ax = [];
Ay = [];
Az = [];
sps = [];
samples = [];
ID = [];

%fileID = 'init_conditions/slope_1_imu';

%Open csv file and read each line into a cell array
fileString = [path,fileName];
f = fopen(fileString,'r');
if f == -1
    fprintf(['\nERROR: Bad Filename\n\t"',fileString,'"\n']);
else
    rawData = textscan(f,'%f %f %f %f %f %f %f %f %f %s %s','Delimiter',',','HeaderLines',4);
    info = textscan(f,'%s %s','Delimiter',',','MultipleDelimsAsOne',1);
    if isempty(rawData{1,1})
        fprintf(['\nERROR: No IMU Data for this experiment \t"',fileName,'"\n']);
    else
        %Convert cells into arrays
        start_time = mystr2double_time(info{1,2}(1));
        end_time = mystr2double_time(info{1,2}(2));
        if end_time < start_time
            end_time = end_time + 3600;
        end
        duration = end_time - start_time;
        if size(rawData{1,1},1) == size(rawData{1,11},1)
            data = [rawData{1,1} rawData{1,2} rawData{1,3} rawData{1,4} rawData{1,5} rawData{1,6} rawData{1,7},rawData{1,9},str2double(rawData{1,11})];
        else
            cut = size(rawData{1,11},1);
            ID_num = str2double(rawData{1,11});
            data = [rawData{1,1}(1:cut) rawData{1,2}(1:cut) rawData{1,3}(1:cut)...
                rawData{1,4}(1:cut) rawData{1,5}(1:cut) rawData{1,6}(1:cut)...
                rawData{1,7}(1:cut),rawData{1,9}(1:cut),ID_num(1:cut)];
        end
        data(strcmp(rawData{1,10},'!'),:) = [];            %Remove error data
        samples = data(:,1)-1;
        
        %Assign names to data
        Gx = data(:,2);
        Gy = data(:,3);
        Gz = data(:,4);
        Ax = data(:,5);
        Ay = data(:,6);
        Az = data(:,7);
        count = data(:,8);
        ID = data(:,9);
        
        %Create timestamps based on counter data
        i = find(abs(diff(count))>10000);
        add = (65535-count(i)) + count(i+1);
        maxCounterValue = 65535;
        
        for m = 1:length(i)
            count(i(m)+1:end) = count(i(m)+1:end) + (maxCounterValue + add(m));
        end
        
        secPerCount = duration/count(end);
        time = count*secPerCount;
        sps = samples(end)/time(end);
    end
    
    out = struct('time',time,'start_time',start_time,...
        'Gx',Gx,'Gy',Gy,'Gz',Gz,...
        'Ax',Ax,'Ay',Ay,'Az',Az,...
        'sps',sps,'samples',samples,'ID',ID,...
        'path',path,'filename',fileName);
end
end

function d = mystr2double_time(s)
% given a cell array of information in DD/MM/YY HH:MM:SS 
% string format, convert to double

    [~, remain] = strtok(s{1,1}, ':');
    [min, remain] = strtok(remain, ':');
    [sec, remain] = strtok(remain, ':');
    d = str2double(min)*60 + str2double(sec);
    
end 