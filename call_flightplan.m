lat=43;
long =-73;
alt=50;
f=50;
sensorXTrack=35;
sensorAlongTrack=24;
roll=0;
pitch=0;
yaw=0;
Z = footprintFrameOblique(lat, long, alt, f, sensorXTrack, sensorAlongTrack, roll, pitch, yaw);
Y = footprintFrameOblique(lat, long, alt, f, sensorXTrack, sensorAlongTrack, roll, pitch, 45); 
X = footprintFrameOblique(lat, long, alt, f, sensorXTrack, sensorAlongTrack, 20, pitch, 45);
W = footprintFrameOblique(lat, long, alt, f, sensorXTrack, sensorAlongTrack, roll, 20, yaw);
figure(1), current_location = plot(long,lat,'rs'); hold on
angles_none =plot(Z(:,2),Z(:,1),'bs');
angles_yaw = plot(Y(:,2),Y(:,1),'g+');
angles_roll_yaw = plot(X(:,2),X(:,1),'m*');
angles_pitch =  plot(W(:,2),W(:,1),'yo');

