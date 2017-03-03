
f = fopen('latency_test4.txt');
t = textscan(f,'%s');

z = t{1};
z(strcmp(z,'Elapsed'))=[];
z(strcmp(z,'time'))=[];
z(strcmp(z,'in'))=[];
z(strcmp(z,'seconds.'))=[];
z(strcmp(z,'is'))=[];
z(strcmp(z,'mark'))=[];

i = cell2mat(z);
n = str2num(i);

figure

plot(n,'.:')
hold on
plot(xlim,[0.008 0.008],'-');
a = mean(n(4:10:end));
%plot(xlim,[a a],'--');
d = n;
d(4:10:end) = [];
b = mean(d);
%plot(xlim,[b b]);
legend('GUI Latency','IMU sample rate','Avg. latency when plotting');%,'Avg. latency when not plotting');
text(500,0.09,sprintf('Avg. latency when plotting = %0.4f s\nAvg. latency when not plotting = %0.4f s',a,b));
xlabel('Sample Number');
ylabel('Elapsed time since last point, (s)');
title('GUI Latency for the OSA');

