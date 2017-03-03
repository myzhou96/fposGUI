function omega=quat2omega(time, quat)
%% given a time history of quaterion, [qx(t) qy(t) qz(t) qs(t)], find angular velocity over time
% uses the formula q_dot= 1/2*q cross omega
% omega = 2* pseudo(q_cross)*q_dot

% Uses:
%   None

% Inputs:
%   time - VICON raw time
%   quat - n x 4 matrix with raw quaternion data

% Ouputs:
%   omega - n x 3 matrix with angular velocity in the global frame

% !! Warnings disabled when performing matrix calculation because matrix
%    may be rank deficient when the OSA is not present in VICON field of view 


% ensure even sampling of quaternion
% [~,q_x]=filter1D(time,quat(:,1));
% [~,q_y]=filter1D(time,quat(:,2));
% [~,q_z]=filter1D(time,quat(:,3));
% [time_even,q_s]=filter1D(time,quat(:,4));
%dt=time_even(2)-time_even(1);


q_x = quat(:,1);
q_y = quat(:,2);
q_z = quat(:,3);
q_s = quat(:,4);
%dt = time(2)-time(1);
dt = diff(time);

% find the quaternion derivative
dq_x_dt=diff(q_x)./dt;
dq_y_dt=diff(q_y)./dt;
dq_z_dt=diff(q_z)./dt;
dq_s_dt=diff(q_s)./dt;

omega=zeros(length(time),3);

warning('off','MATLAB:rankDeficientMatrix');
for i=1:length(time)-1
    q_vec=[q_x(i) q_y(i) q_z(i)]';
    q_crs=[0 -q_z(i) q_y(i); q_z(i) 0 -q_x(i); -q_y(i) q_x(i) 0];
    q_cross=[q_s(i)*eye(3)-q_crs/norm(q_vec); -q_vec'/norm(q_vec)];
    q_dot=[dq_x_dt(i) dq_y_dt(i) dq_z_dt(i) dq_s_dt(i)]';
    omega(i,:)=2*(q_cross\q_dot)';
end
warning('on','MATLAB:rankDeficientMatrix');
