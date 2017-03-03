function Vicon_data = parse_Vicon(path,filename)

fileID = fopen([path filename],'r');

A = textscan(fileID, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s ');
A = A(1,2:end);
Vicon_data.common_time = mystr2double_time(A(1,1));
if Vicon_data.common_time(end) < Vicon_data.common_time(1)
    diff(Vicon_data.common_time);
    val=find(diff(Vicon_data.common_time)<-3599);
    Vicon_data.common_time(val:end) = Vicon_data.common_time(val:end) + 3600;
end
Vicon_data.frame = mystr2double(A(1,2));
Vicon_data.OSA_Position = mystr2double(A(1,3:5));
Vicon_data.OSA_EulerAngGlobal = unwrap(mystr2double(A(1,6:8)));
Vicon_data.OSA_QuaternionGlobal = mystr2double(A(1,9:12));
Vicon_data.OSA_EulerAngBody = unwrap(mystr2double(A(1,13:15)));
Vicon_data.OSA_QuaternionLocal = mystr2double(A(1,16:19));
Vicon_data.SROA_Position = mystr2double(A(1,20:22));
Vicon_data.SROA_EulerAngGlobal = unwrap(mystr2double(A(1,23:25)));
Vicon_data.SROA_QuaternionGlobal = mystr2double(A(1,26:29));
Vicon_data.filename = filename;
Vicon_data.path = path;

end

function d = mystr2double(s)
% given a cell array of columnar information in string format, convert to
% doubles
d = [];
for i = 1:size(s,2)
    d = [d str2double(s{1,i}(2:end))];
end
end   

function d = mystr2double_time(s)
% given a cell array of a column of information in DD/MM/YY HH:MM:SS 
% string format, convert to doubles 
d = zeros(size(s{1,1},1)-1,1);

for i = 2:size(s{1,1},1)
    [~, remain] = strtok(s{1,1}(i,1), ':');
    [min, remain] = strtok(remain, ':');
    [sec, remain] = strtok(remain, ':');
    d(i-1) = str2double(min)*60 + str2double(sec);
end
end   