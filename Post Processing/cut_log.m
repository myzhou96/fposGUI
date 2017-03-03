function cut_data = cut_log(full_log, IDs)

start_ID = IDs(1);
end_ID = IDs(2);

I = find(abs(full_log.ID - start_ID) < 0.5);
start_cut = min(I)

J = find(abs(full_log.ID - end_ID) < 0.5);
end_cut = min(J)

cut_data.time = full_log.time(start_cut:end_cut);
cut_data.Gx = full_log.Gx(start_cut:end_cut);
cut_data.Gy = full_log.Gy(start_cut:end_cut);
cut_data.Gz = full_log.Gz(start_cut:end_cut);
cut_data.Ax = full_log.Ax(start_cut:end_cut);
cut_data.Ay = full_log.Ay(start_cut:end_cut);
cut_data.Az = full_log.Az(start_cut:end_cut);
cut_data.count = full_log.count(start_cut:end_cut);
cut_data.ID = full_log.ID(start_cut:end_cut);