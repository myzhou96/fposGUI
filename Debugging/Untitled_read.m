
% data = csvread('1_frame.csv',0,10);
% 
% data(data == 0) = [];

% figure
% subplot(211)
% plot(data)
% subplot(212)
% ddata = diff(data);
% ddata(ddata > 1) = [];
% plot(ddata)


data = load('time_log.txt');

figure
plot(data(2:end-2,1),'.')
hold on
plot(data(2:end-2,2),'.')

plot(data(2:end-2,1)+data(2:end-2,2))

plot(xlim,[0.008,0.008])

legend('Frame Update Period','OSA_Update_Period','Time Between Samples','Actual IMU Sample Period');