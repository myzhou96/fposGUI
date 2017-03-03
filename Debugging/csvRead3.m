function [out] = csvRead3(path,fileName)
% Parses CSV files to obtain gyroscope and accelerometer data from raw IMU
% output files using textscan.

% Uses:
%   None

% Inputs:
%   path - folder being parsed
%   fileName - file being read

% Outputs:
%   out - structure with the fields [time,Gx...z,Ax...z,sps,samples,path,fileName]
%   Note: All tests done before July 5 have unreliable timestamps!!


% path = 'Compiled_Data/''Test''/';
% fileName = 'timestamps5.csv';
fileName = '20_Feb_17__15_23_58_frame_log.csv';
path = [];  
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

%fileID = 'init_conditions/slope_1_imu';

%Open csv file and read each line into a cell array
fileString = [path,fileName];
f = fopen(fileString);
if f == -1
    fprintf(['\nERROR: Bad Filename\n\t"',fileString,'"\n']);
else
    rawData = textscan(f,'%f %f %f %f %f %f %f %f %f %s %f','Delimiter',',','HeaderLines',4);
    info = textscan(f,'%s %s','Delimiter',',','MultipleDelimsAsOne',1);
    
    %Convert cells into arrays
    duration = str2double(info{1,2}(3));
    data = [rawData{1,1} rawData{1,2} rawData{1,3} rawData{1,4} rawData{1,5} rawData{1,6} rawData{1,7},rawData{1,9},rawData{1,11}];
    data(strcmp(rawData{1,10},'!'),:) = [];            %Remove error data
    samples = data(:,1)-1;
    
    %Assign names to data
    Gx = data(:,2);
    Gy = data(:,3);
    Gz = data(:,4);
    Ax = data(:,5);
    Ay = data(:,6);
    Az = data(:,7);
    count = data(:,8);  %Counter Values used for all June, 2016 tests
    time = data(:,9);   %Timestamps recorded starting on July 5, 2016
    time = time - time(1);
    
    %     figure
    %     plot(count)
    
    %Create timestamps based on counter data if time does not exist
    if sum(isnan(time))==length(time)
        
        i = find(abs(diff(count))>10000);
        add = (65535-count(i)) + count(i+1);
        maxCounterValue = 65535;
        
        for m = 1:length(i)
            count(i(m)+1:end) = count(i(m)+1:end) + (maxCounterValue+1);% + add(m));
        end
        
        secPerCount = duration/count(end);
        time = count*secPerCount;
    end
    
    sps = 1./diff(time);
    
    %     figure
    %     plot(-1*diff(count))
    %     figure
    %     plot(count);
    %     figure
    %     plot(time,Ax,timestamps,Ax,'r');
    
    fclose(f);
end

out = struct('time',time,'Gx',Gx,'Gy',Gy,'Gz',...
    Gz,'Ax',Ax,'Ay',Ay,'Az',Az,'sps',sps,'samples',samples,...
    'path',path,'filename',fileName);

end