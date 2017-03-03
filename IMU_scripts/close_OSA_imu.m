function handles = close_OSA_imu(handles)
%Writes into a .CSV file.

handles.osa.stopdate = datestr(now,'dd-mmm-yyyy HH:MM:SS.FFF');

fprintf(handles.osa.fid,'Log Start,%s\n',handles.osa.startdate);
fprintf(handles.osa.fid,'Log End,%s\n',handles.osa.stopdate);
fprintf(handles.osa.fid,'Log Duration,%f\n',handles.osa.time(handles.osa.k-1));
fprintf(handles.osa.fid,'Sample Count,%f\n',handles.osa.sample_num([1,handles.osa.k-1]));
fprintf(handles.osa.fid,'Sample Error Count\n');
fprintf(handles.osa.fid,'Data Rate,%f,sps\n',(handles.osa.k-1)/handles.osa.time(handles.osa.k-1));
fclose(handles.osa.fid);

