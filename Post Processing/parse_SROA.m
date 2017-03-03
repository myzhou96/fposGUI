function SROA_data = parse_SROA(path,filename)
% data = [cold_tip, SC_diodes, pressure, thermocouple1, thermocouple2]
fileID = fopen([path filename],'r');
A = textscan(fileID,'%s %f %f %f %f %f %f %f','Delimiter','\t','HeaderLines',1);
SROA_data.common_time = mystr2double_time(A(1,1));
SROA_data.cold_tip = A{1,2};
SROA_data.SC_diode1 = A{1,3};
SROA_data.SC_diode2 = A{1,4};
SROA_data.pressure = A{1,5};
SROA_data.compressor = A{1,6};
SROA_data.expander = A{1,7};
SROA_data.filename = filename;
SROA_data.path = path;

end

function d = mystr2double_time(s)
% given a cell array of a column of information in DD/MM/YY HH:MM:SS 
% string format, convert to doubles 
d = zeros(size(s{1,1},1),1);
for i = 1:size(s{1,1},1)
    [~, remain] = strtok(s{1,1}(i,1), ':');
    [min, remain] = strtok(remain, ':');
    [sec, remain] = strtok(remain, ':');
    d(i) = str2double(min)*60 + str2double(sec);
end
end   