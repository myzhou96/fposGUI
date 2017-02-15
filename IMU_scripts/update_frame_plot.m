function handles = update_frame_plot(handles)
%Update function for the Frame IMU. Reads a python generated log file and
%updates the plots of the GUI. Have not confirmed that reading does not
%hold or otherwise affect measurements.

%Inputs:
%   handles -       The structure containing all of the handles in the GUI.

%Outputs:
%   handles -       An updated structure containing all of the updated handles in the GUI

% disp('Frame mark');
% tic
if handles.frame.starttime == -1
    flushinput(handles.frame.u);
    handles.frame.starttime = 0;
end
if handles.frame.u.BytesAvailable >= 119
    
    %Read in one measurement and format numbers into doubles
    single_measurement = fread(handles.frame.u);
    A = sscanf(char(single_measurement'),'%f,%f,%f,%f,%f,%f,%f,%f,%f,%f');
    
    %toc
    %tic
    
    if length(A) == 10
        %% Assign to Pre-allocated Variables
        
        %Save starting time
        if handles.frame.starttime == 0
            handles.frame.starttime = A(10);
        end
        
        %Assignments
        handles.frame.sample_num(handles.frame.k) = A(1);
        %handles.frame.time(handles.frame.k) = A(10)-handles.frame.starttime;
        handles.frame.time(handles.frame.k) = A(1)/125;
        handles.frame.Ax(handles.frame.k) = A(5);
        handles.frame.Ay(handles.frame.k) = A(6);
        handles.frame.Az(handles.frame.k) = A(7);
        handles.frame.Gx(handles.frame.k) = A(2);
        handles.frame.Gy(handles.frame.k) = A(3);
        handles.frame.Gz(handles.frame.k) = A(4);
        
        %Write to log file
        fprintf(handles.frame.fid, '%d,%f,%f,%f,%f,%f,%f,%f,%d,,%f\n', A);
        
        %toc
        
        %% Plot data
        
        %  tic
        
        %Update plot
        if mod(A(1),handles.frame.plotDownSample) == 0 && handles.frame.on == 1
            
            %Update x and y data
            set(handles.frame.Ax_axis,...
                'Xdata',handles.frame.time(handles.frame.lefttime:handles.frame.k),...
                'Ydata',handles.frame.Ax(handles.frame.lefttime:handles.frame.k));
            set(handles.frame.Ay_axis,...
                'Xdata',handles.frame.time(handles.frame.lefttime:handles.frame.k),...
                'Ydata',handles.frame.Ay(handles.frame.lefttime:handles.frame.k));
            set(handles.frame.Az_axis,...
                'Xdata',handles.frame.time(handles.frame.lefttime:handles.frame.k),...
                'Ydata',handles.frame.Az(handles.frame.lefttime:handles.frame.k));
            
            %Update x and y data
            set(handles.frame.Gx_axis,...
                'Xdata',handles.frame.time(handles.frame.lefttime:handles.frame.k),...
                'Ydata',handles.frame.Gx(handles.frame.lefttime:handles.frame.k));
            set(handles.frame.Gy_axis,...
                'Xdata',handles.frame.time(handles.frame.lefttime:handles.frame.k),...
                'Ydata',handles.frame.Gy(handles.frame.lefttime:handles.frame.k));
            set(handles.frame.Gz_axis,...
                'Xdata',handles.frame.time(handles.frame.lefttime:handles.frame.k),...
                'Ydata',handles.frame.Gz(handles.frame.lefttime:handles.frame.k));
            
            %Adjust x limits on plots
            if handles.frame.time(handles.frame.k) - handles.frame.time(handles.frame.lefttime) > 10
                
                handles.frame.lefttime = floor((handles.frame.k + handles.frame.lefttime)/2);
                
                set(handles.facc_time,'xlim',...
                    [handles.frame.time(handles.frame.k)-5 handles.frame.time(handles.frame.k)+5]);
                set(handles.fangv_time,'xlim',...
                    [handles.frame.time(handles.frame.k)-5 handles.frame.time(handles.frame.k)+5]);
                
            end
            
            % ---- Graphics objects are updated with "drawnow" in update_OSA_plots() -----
            % *Unless OSA plots are disabled
            if ~handles.osa.on
                drawnow;
            end
            
        end
        
        % Number of data points archived
        handles.frame.k = handles.frame.k+1;
        
        %   toc
        
        %% Allocate More Space (if needed)
        
        %Increase the size of these arrays by 1000 spots if full
        if handles.frame.k == length(handles.frame.time)
            handles.frame.time = [handles.frame.time, zeros(1,5000)];
            handles.frame.Ax = [handles.frame.Ax, zeros(1,5000)];
            handles.frame.Ay = [handles.frame.Ay, zeros(1,5000)];
            handles.frame.Az = [handles.frame.Az, zeros(1,5000)];
            handles.frame.Gx = [handles.frame.Gx, zeros(1,5000)];
            handles.frame.Gy = [handles.frame.Gy, zeros(1,5000)];
            handles.frame.Gz = [handles.frame.Gz, zeros(1,5000)];
        end
        
    else
        
        disp('WARNING, FRAME BUFFER FULL');
        %handles.frame.idx = handles.frame.idx + 1;
        %disp(handles.frame.idx);
        
    end
    
end
