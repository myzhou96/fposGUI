function handles = init_OSA_imu(handles,collect_time)
%Sends a message to the Raspberry Pi, telling it to turn on the IMU

if nargin < 2
    collect_time = 60;
end

%Set mode = 0 to generate fake data for testing purposes
mode = 1;

%Use a default sample rate of 125 samples/sec.
samplerate = 125;
filename = 'osa_flight_log.csv';

if mode == 1
    
    display('**OPERATING IN OSA NORMAL MODE**');
    
    %Open a socket connection to the OSA
    fopen(handles.osa.u);
    
    %Send IMU commands
    fwrite(handles.osa.u,['/dev/ttyUSB0,',num2str(collect_time),',',filename,',',num2str(samplerate)]);
    
    %Read the first 8 bytes sent back
    reply = fread(handles.osa.u,8);
    if strcmp('Approved',char(reply'))
        disp('**OSA Successfully Started**');
    else
        warning('**OSA did not recieve start command**');
        fclose(handles.osa.u);
    end
    
else
    
    display('**OPERATING IN OSA TEST MODE**');
    !python PythonFiles/test_TCPclient.py &
    
end

display('OSA IMU started');

end