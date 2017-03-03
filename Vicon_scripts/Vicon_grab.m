% function handles = getVicon()

% Get a frame
while MyClient.GetFrame().Result.Value ~= Result.Success
%     disp('got frame')
end

% Get the frame number
Output_GetFrameNumber = MyClient.GetFrameNumber();

% Get the frame rate
Output_GetFrameRate = MyClient.GetFrameRate();

% Count the number of subjects
SubjectCount = MyClient.GetSubjectCount().SubjectCount;

for SubjectIndex = 1:SubjectCount
    
    % Get the subject name
    SubjectName = MyClient.GetSubjectName( SubjectIndex ).SubjectName;
    
    if strcmp(SubjectName,OSA)
        % Get the root segment
        RootSegment = MyClient.GetSubjectRootSegmentName( SubjectName ).SegmentName;
        
        % Count the number of segments
        SegmentCount = MyClient.GetSegmentCount( SubjectName ).SegmentCount;
        for SegmentIndex = 1:SegmentCount
            
            % Get the segment name
            SegmentName = MyClient.GetSegmentName( SubjectName, SegmentIndex ).SegmentName;
            
            % Get the segment parent
            SegmentParentName = MyClient.GetSegmentParentName( SubjectName, SegmentName ).SegmentName;
            
            % Get the segment's children
            ChildCount = MyClient.GetSegmentChildCount( SubjectName, SegmentName ).SegmentCount;
            for ChildIndex = 1:ChildCount
                ChildName = MyClient.GetSegmentChildName( SubjectName, SegmentName, ChildIndex ).SegmentName;
            end
            
            % Get the global segment translation
            OSA_Output_GetSegmentGlobalTranslation = MyClient.GetSegmentGlobalTranslation( SubjectName, SegmentName );
            
            % Get the global segment rotation in quaternion co-ordinates
            OSA_Output_GetSegmentGlobalRotationQuaternion = MyClient.GetSegmentGlobalRotationQuaternion( SubjectName, SegmentName );
            
            % Get the global segment rotation in EulerXYZ co-ordinates
            OSA_Output_GetSegmentGlobalRotationEulerXYZ = MyClient.GetSegmentGlobalRotationEulerXYZ( SubjectName, SegmentName );
            
            % Get the local segment rotation in quaternion co-ordinates
            OSA_Output_GetSegmentLocalRotationQuaternion = MyClient.GetSegmentLocalRotationQuaternion( SubjectName, SegmentName );
            
            % Get the local segment rotation in EulerXYZ co-ordinates
            OSA_Output_GetSegmentLocalRotationEulerXYZ = MyClient.GetSegmentLocalRotationEulerXYZ( SubjectName, SegmentName );
        end% SegmentIndex
    end
    
    if strcmp(SubjectName,SROA)
        % Get the root segment
        RootSegment = MyClient.GetSubjectRootSegmentName( SubjectName ).SegmentName;
        
        % Count the number of segments
        SegmentCount = MyClient.GetSegmentCount( SubjectName ).SegmentCount;
        for SegmentIndex = 1:SegmentCount
            
            % Get the segment name
            SegmentName = MyClient.GetSegmentName( SubjectName, SegmentIndex ).SegmentName;
            
            % Get the segment parent
            SegmentParentName = MyClient.GetSegmentParentName( SubjectName, SegmentName ).SegmentName;
            
            % Get the segment's children
            ChildCount = MyClient.GetSegmentChildCount( SubjectName, SegmentName ).SegmentCount;
            
            for ChildIndex = 1:ChildCount
                ChildName = MyClient.GetSegmentChildName( SubjectName, SegmentName, ChildIndex ).SegmentName;
            end% for
            
            
            % Get the global segment translation
            SROA_Output_GetSegmentGlobalTranslation = MyClient.GetSegmentGlobalTranslation( SubjectName, SegmentName );
            
            % Get the global segment rotation in quaternion co-ordinates
            SROA_Output_GetSegmentGlobalRotationQuaternion = MyClient.GetSegmentGlobalRotationQuaternion( SubjectName, SegmentName );
            
            % Get the global segment rotation in EulerXYZ co-ordinates
            SROA_Output_GetSegmentGlobalRotationEulerXYZ = MyClient.GetSegmentGlobalRotationEulerXYZ( SubjectName, SegmentName );
            
        end% SegmentIndex
    end
    
%     disp('got data')
    
end% SubjectIndex

handles.ViconFrame = Output_GetFrameNumber.FrameNumber;
handles.ViconOSA.Position = OSA_Output_GetSegmentGlobalTranslation.Translation';
handles.ViconOSA.EulerAngGlobal = OSA_Output_GetSegmentGlobalRotationEulerXYZ.Rotation';
handles.ViconOSA.QuaternionGlobal = OSA_Output_GetSegmentGlobalRotationQuaternion.Rotation';
handles.ViconOSA.EulerAngBody = OSA_Output_GetSegmentLocalRotationEulerXYZ.Rotation';
handles.ViconOSA.QuaternionLocal = OSA_Output_GetSegmentLocalRotationQuaternion.Rotation';
handles.ViconSROA.Position = SROA_Output_GetSegmentGlobalTranslation.Translation';
handles.ViconSROA.EulerAngGlobal = SROA_Output_GetSegmentGlobalRotationEulerXYZ.Rotation';
handles.ViconSROA.QuaternionGlobal = SROA_Output_GetSegmentGlobalRotationQuaternion.Rotation';