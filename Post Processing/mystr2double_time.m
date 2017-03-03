function d = mystr2double_time(s)
% given a cell array of information in DD/MM/YY HH:MM:SS 
% string format, convert to double

    [~, remain] = strtok(s{1,1}, ':');
    [min, remain] = strtok(remain, ':');
    [sec, remain] = strtok(remain, ':');
    d = str2double(min)*60 + str2double(sec);
    
end 