
totals = dlmread('half_decimated\time_recorder.txt','\t',1,0);
%totals = dlmread('readEveryPass\time_recorder.txt','\t',1,0);

t_frame = mean(totals(totals(:,1)>0,1));
std_frame = std(totals(totals(:,1)>0,1));

t_osa = mean(totals(totals(:,2)>0,2));
std_osa = std(totals(totals(:,2)>0,2));

t_sroa = mean(totals(totals(:,3)>0,3));
std_sroa = std(totals(totals(:,3)>0,3));

t_vicon = mean(totals(totals(:,4)>0,4));
std_vicon = std(totals(totals(:,4)>0,4));

t_draw = mean(totals(totals(:,5)>0,5));
std_draw = std(totals(totals(:,5)>0,5));

t_all = mean(totals(totals(:,6)>0,6));
std_all = std(totals(totals(:,6)>0,6));

fprintf('Total Times\nFrame:\t%f\nOSA:\t%f\nSROA:\t%f\ndraw:\t%f\nFrame:\t%f\n',...
    t_frame,t_osa,t_sroa,t_vicon,t_draw);
fprintf('Grand Total:\t%f\n',t_all);

fprintf('\nSTDs\nFrame:\t%f\nOSA:\t%f\nSROA:\t%f\ndraw:\t%f\nFrame:\t%f\n',...
    std_frame,std_osa,std_sroa,std_vicon,std_draw);
fprintf('Grand Total:\t%f\n',std_all);

%%
totals = dlmread('half_decimated\time_recorder_frame.txt','\t',1,0);

t_frame = mean(totals(totals(:,1)>0,1));
std_frame = std(totals(totals(:,1)>0,1));

t_osa = mean(totals(totals(:,2)>0,2));
std_osa = std(totals(totals(:,2)>0,2));

t_sroa = mean(totals(totals(:,3)>0,3));
std_sroa = std(totals(totals(:,3)>0,3));

t_vicon = mean(totals(totals(:,4)>0,4));
std_vicon = std(totals(totals(:,4)>0,4));

t_draw = mean(totals(totals(:,5)>0,5));
std_draw = std(totals(totals(:,5)>0,5));

t_all = mean(totals(totals(:,6)>0,6));
std_all = std(totals(totals(:,6)>0,6));

fprintf('Frame Times\nInit:\t%f\nFlush:\t%f\nRead:\t%f\n2Num:\t%f\nParse:\t%f\n',...
    t_frame,t_osa,t_sroa,t_vicon,t_draw);
fprintf('Frame Total:\t%f\n',t_all);

fprintf('\nFrame STDs\nInit:\t%f\nFlush:\t%f\nRead:\t%f\n2Num:\t%f\nParse:\t%f\n',...
    std_frame,std_osa,std_sroa,std_vicon,std_draw);

%%
totals = dlmread('half_decimated\time_recorder_osa.txt','\t',1,0);

t_frame = mean(totals(totals(:,1)>0,1));
std_frame = std(totals(totals(:,1)>0,1));

t_osa = mean(totals(totals(:,2)>0,2));
std_osa = std(totals(totals(:,2)>0,2));

t_sroa = mean(totals(totals(:,3)>0.001,3));
std_sroa = std(totals(totals(:,3)>0.001,3));

t_vicon = mean(totals(totals(:,4)>0,4));
std_vicon = std(totals(totals(:,4)>0,4));

t_draw = mean(totals(totals(:,5)>0,5));
std_draw = std(totals(totals(:,5)>0,5));

t_all = mean(totals(totals(:,6)>0,6));
std_all = std(totals(totals(:,6)>0,6));

fprintf('OSA Times\nInit:\t%f\nFlush:\t%f\nRead:\t%f\n2Num:\t%f\nParse:\t%f\n',...
    t_frame,t_osa,t_sroa,t_vicon,t_draw);
fprintf('OSA Total:\t%f\n',t_all);

fprintf('\nOSA STDs\nInit:\t%f\nFlush:\t%f\nRead:\t%f\n2Num:\t%f\nParse:\t%f\n',...
    std_frame,std_osa,std_sroa,std_vicon,std_draw);
