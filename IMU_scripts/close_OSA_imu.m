function handles = close_OSA_imu(handles)
%Writes into a .CSV file.

handles.osa.stopdate = datestr(now);

fprintf(handles.osa.fid,'Log Start,%s\n',handles.osa.startdate);
fprintf(handles.osa.fid,'Log End,%s\n',handles.osa.stopdate);
fprintf(handles.osa.fid,'Log Duration,%f\n',handles.osa.time(end));
fprintf(handles.osa.fid,'Sample Count,%f\n',length(handles.osa.time));
fprintf(handles.osa.fid,'Sample Error Count\n');
fprintf(handles.osa.fid,'Data Rate,%f,sps\n',mean(length(handles.osa.time)/handles.osa.time(end)));
fclose(handles.osa.fid);

