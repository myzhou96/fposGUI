function handles = update_osa_plots(handles)
%Update function for the OSA IMU. Reads a putty generated log file that is
%independent of data collection, and updates the plots of the GUI.

%Inputs:
%   handles -       The structure containing all of the handles in the GUI.

%Outputs:
%   handles -       An updated structure containing all of the updated handles in the GUI

%tic
if handles.osa.starttime == -1
    flushinput(handles.osa.u);
    handles.osa.starttime = 0;
end

if handles.osa.u.BytesAvailable >= 119
    %% Read Data
    %tic
    single_measurement = fread(handles.osa.u,119);
    
    if strcmp(char(single_measurement(1:4)'),'Done') == 1
        set(handles.go, 'String','GO');
        guidata(gcbo,handles);
        return
    end
    
    A = sscanf(char(single_measurement'),'%f,%f,%f,%f,%f,%f,%f,%f,%f,%f');
    %toc

    %% Assign to Pre-allocated Variables
    if length(A) == 10
    %tic
    
    %Save starting time
    if handles.osa.starttime == 0
        handles.osa.starttime = A(10);
    end
    
    %Assignments   
    handles.osa.sample_num(handles.osa.k) = A(1);
    handles.osa.time(handles.osa.k) = A(10)-handles.osa.starttime;
    handles.osa.Gx(handles.osa.k) = A(2);
    handles.osa.Gy(handles.osa.k) = A(3);
    handles.osa.Gz(handles.osa.k) = A(4);
    handles.osa.Ax(handles.osa.k) = A(5);
    handles.osa.Ay(handles.osa.k) = A(6);
    handles.osa.Az(handles.osa.k) = A(7);

    %Save to log file
    fprintf(handles.osa.fid, '%d,%f,%f,%f,%f,%f,%f,%f,%d,,%f\n', A);
    
    %toc
    
    %% Plot data
    %tic
    if mod(A(1),handles.osa.plotDownSample) == 0 && handles.osa.on == 1
        
        % Update plot x and y axes
        set(handles.osa.Ax_axis,...
            'Xdata',handles.osa.time(handles.osa.lefttime:handles.osa.k),...
            'Ydata',handles.osa.Ax(handles.osa.lefttime:handles.osa.k));
        set(handles.osa.Ay_axis,...
            'Xdata',handles.osa.time(handles.osa.lefttime:handles.osa.k),...
            'Ydata',handles.osa.Ay(handles.osa.lefttime:handles.osa.k));
        set(handles.osa.Az_axis,...
            'Xdata',handles.osa.time(handles.osa.lefttime:handles.osa.k),...
            'Ydata',handles.osa.Az(handles.osa.lefttime:handles.osa.k));
        
        set(handles.osa.Gx_axis,...
            'Xdata',handles.osa.time(handles.osa.lefttime:handles.osa.k),...
            'Ydata',handles.osa.Gx(handles.osa.lefttime:handles.osa.k));
        set(handles.osa.Gy_axis,...
            'Xdata',handles.osa.time(handles.osa.lefttime:handles.osa.k),...
            'Ydata',handles.osa.Gy(handles.osa.lefttime:handles.osa.k));
        set(handles.osa.Gz_axis,...
            'Xdata',handles.osa.time(handles.osa.lefttime:handles.osa.k),...
            'Ydata',handles.osa.Gz(handles.osa.lefttime:handles.osa.k));

        %Update time series
        if handles.osa.time(handles.osa.k) - handles.osa.time(handles.osa.lefttime) > 10
            
            handles.osa.lefttime = floor((handles.osa.lefttime + handles.osa.k)/2);
            
            set(handles.angv_time,...
                'xlim',[handles.osa.time(handles.osa.k)-5, handles.osa.time(handles.osa.k)+5]);
            set(handles.oacc_time,...
                'xlim',[handles.osa.time(handles.osa.k)-5, handles.osa.time(handles.osa.k)+5]);
        
        end
        
        drawnow;
        
    end
%toc
    
%   Number of data points archived
    handles.osa.k = handles.osa.k+1;
    
    %% Allocate More Space (if needed)
    
    %Increase the size of these arrays by 5000 spots if already full
    if handles.osa.k == length(handles.osa.time)
        handles.osa.sample_num = [handles.osa.sample_num, zeros(1,5000)];
        handles.osa.time = [handles.osa.time, zeros(1,5000)];
        handles.osa.Ax = [handles.osa.Ax, zeros(1,5000)];
        handles.osa.Ay = [handles.osa.Ay, zeros(1,5000)];
        handles.osa.Az = [handles.osa.Az, zeros(1,5000)];
        handles.osa.Gx = [handles.osa.Gx, zeros(1,5000)];
        handles.osa.Gy = [handles.osa.Gy, zeros(1,5000)];
        handles.osa.Gz = [handles.osa.Gz, zeros(1,5000)];
        handles.osa.temp = [handles.osa.temp, zeros(1,5000)];
    end
    
    %toc
    end
end
end


