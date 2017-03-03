files = dir('*_osa_log.csv');
log.time = [];
log.Gx = [];
log.Gy = [];
log.Gz = [];
log.Ax = [];
log.Ay = [];
log.Az = [];
log.count = [];
log.ID = [];

for j = 1:size(files)
    
    fileString = files(j).name
    
    f = fopen(fileString,'r');
    
    rawData = textscan(f,'%f %f %f %f %f %f %f %f %f %s %s','Delimiter',',','HeaderLines',4);
    info = textscan(f,'%s %s','Delimiter',',','MultipleDelimsAsOne',1);
    if isempty(rawData{1,1})
        fprintf(['\nERROR: No IMU Data for this experiment \t"',fileName,'"\n']);
    else
        %Convert cells into arrays
        start_time = mystr2double_time(info{1,2}(size(info{1,1},1)-6,1));
        end_time = mystr2double_time(info{1,2}(size(info{1,1},1)-5,1));
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
        unique_ID = data(:,9);
        
        %Create timestamps based on counter data
        i = find(abs(diff(count))>10000);
        add = (65535-count(i)) + count(i+1);
        maxCounterValue = 65535;
        
        for m = 1:length(i)
            count(i(m)+1:end) = count(i(m)+1:end) + (maxCounterValue + add(m));
        end
        
        secPerCount = duration/count(end);
        time = start_time + count*secPerCount;
        sps = samples(end)/duration;
    end
    
    figure
    subplot(2,1,1)
    plot(time, Gx, time, Gy, time, Gz)
    title('angular velocity [dps]')
    legend('x','y','z')
    subplot(2,1,2)
    plot(time, Ax, time, Ay, time, Az)
    title('acceleration [mG]')
    legend('x','y','z')
    
    figure
    plot(time,unique_ID)
    title('unique ID over time')
    
    log.time = [log.time; time];
    log.Gx = [log.Gx; Gx];
    log.Gy = [log.Gy; Gy];
    log.Gz = [log.Gz; Gz];
    log.Ax = [log.Ax; Ax];
    log.Ay = [log.Ay; Ay];
    log.Az = [log.Az; Az];
    log.count = [log.count; count];
    log.ID = [log.ID; unique_ID];
%     pause
end
    