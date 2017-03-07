function Z = footprintFrameOblique(lat, long, alt, f, sensorXTrack, sensorAlongTrack, roll, pitch, heading)
% This function returns the four corners from a framing camera taken at an
% oblique angle.:

% inputs:
%           lat/long - location where image is taken in DD
%           alt      - altitude in metres
%           f       - focal length in mm
%           SensorXTrack - width of sensor (perpindicular to track) in mm
%           sensorAlongTrack - height of sensor (parallel to track) in mm
%           roll, pitch, and azimuth - in degrees from straight and level
% outputs:
%           Z           - 4X2 matrix containing lat/long in DD of four
%           points of the footprint [FL; FR; RL; RR;]
% 
% Vectors=[ sensorAlongTrack*.5, sensorXTrack*-0.5,f;...
%     sensorAlongTrack*.5, sensorXTrack*0.5,f;...
%     sensorAlongTrack*-.5,sensorXTrack*-0.5,f;...
%     sensorAlongTrack*-.5,sensorXTrack*0.5,f]; % [FL;FR;RL;RR]
% cornerUnitVectors = [Vectors(1,:)/norm(Vectors(1,:)); Vectors(2,:)/norm(Vectors(2,:));Vectors(3,:)/norm(Vectors(3,:)) ;Vectors(4,:)/norm(Vectors(4,:))];
% AlongTrackFOV = atan2d(sensorAlongTrack*.5, f);
% disp('Along track FOV:')
% disp(AlongTrackFOV)
% XTrackFOV=atan2d(sensorXTrack*0.5,f);
% disp('Crosstrack FOV:')
% disp(XTrackFOV)
% cornerAngles =[AlongTrackFOV+pitch,-1*XTrackFOV + roll ;...
%     AlongTrackFOV+pitch , XTrackFOV + roll;...
%     -1*AlongTrackFOV+pitch, -1*XTrackFOV + roll;...
%     -1*AlongTrackFOV+pitch, XTrackFOV + roll]; % [FL_pitch,FL_roll;FR;RL;RR] in degrees
% dFromNadir = alt*atand(cornerAngles); % [along track,cross track] 
% dFootprint = (dFromNadir(:,1).^2+ dFromNadir(:,2).^2).^.5;
% bearing = atan2d(dFromNadir(:,1),dFromNadir(:,2)) + yaw +90;
% disp('Bearing:')
% disp(bearing)
% [new_lat,new_long] = newPosition (lat, long, bearing, dFootprint); % apply great circle to known position, bearing, and distance for approx solution
% Z = [new_lat,new_long] ;
% % first plot in distance space
% figure(1), plot_FL = plot(dFromNadir(1,2),dFromNadir(1,1),'r*'); hold on
% plot_FR= plot(dFromNadir(2,2),dFromNadir(2,1),'g*');
% plot_RL= plot(dFromNadir(3,2),dFromNadir(3,1),'b*');
% plot_RR= plot(dFromNadir(4,2),dFromNadir(4,1),'k*');
% plot_centre = plot(0,0,'ms');

% roll = -20;    %rotation about long axis (x-axis). Positive is a roll to the right.
% pitch = 20; %rotation about lat axis (y-axis). Positive is nose up.
% yaw = 0; %rotation about the normal axis (Z-axis). Positive is right rudder.
sensor_w = sensorXTrack;
sensor_h = sensorAlongTrack;
%alt = 1600;
%f = 60;
FOV_w = atand(sensor_w/2/f);
FOV_h = atand(sensor_h/2/f);
% corner coordinates of sensor with no roll or pitch
l_xz = ((sensor_h/2)^2+f^2)^.5;
l_yz = ((sensor_w/2)^2+f^2)^.5;
l=((sensor_w/2)^2+(sensor_h/2)^2+f^2)^.5;
FL = [l_xz*sind(FOV_h/2+pitch), l_yz*sind(-FOV_w/2+roll),-l*cosd(FOV_h/2+pitch)*cosd(-FOV_w/2+roll)];
FR = [l_xz*sind(FOV_h/2+pitch), l_yz*sind(FOV_w/2+roll),-l*cosd(FOV_h/2+pitch)*cosd(FOV_w/2+roll)];
RR = [l_xz*sind(-FOV_h/2+pitch), l_yz*sind(FOV_w/2+roll),-l*cosd(-FOV_h/2+pitch)*cosd(FOV_w/2+roll)];
RL = [l_xz*sind(-FOV_h/2+pitch), l_yz*sind(-FOV_w/2+roll),-l*cosd(-FOV_h/2+pitch)*cosd(-FOV_w/2+roll)];
disp([FL;FR;RR;RL])
factor_FL = -alt/FL(3);
factor_FR = -alt/FR(3);
factor_RR = -alt/RR(3);
factor_RL = -alt/RL(3);
%coordinates projected on the ground
FL = FL*factor_FL;
FR = FR*factor_FR;
RR = RR*factor_RR;
RL = RL*factor_RL;
% figure(1), 
% plot(0,0,'bs'), hold on
% plot (FL(1),FL(2),'ro');
% plot (FR(1),FR(2),'go');
% plot (RR(1),RR(2),'bo');
% plot (RL(1),RL(2),'ko');
disp([FL;FR;RR;RL])
coords_xy = [FL(1:2);FR(1:2);RR(1:2);RL(1:2)];
plane=max(coords_xy(:))+100;
axis([-plane, plane,-plane,plane])
% bearing to each point.  
%Keep in mind:
%       that bearings are measured clockwise from North
%       polar coordinates are measured counter clockwise from the x-axis
%       negative y-values are to the left of the aircraft
%       positive roll makes footprint move left
bearing = atan2d(coords_xy(:,2),coords_xy(:,1)); % direction relative to aircraft
bearing2 = -bearing+360-heading; % direction relative to true north
if bearing2 >=360
    bearing2=bearing2-360;
end
distance = (coords_xy(:,1).^2+coords_xy(:,2).^2).^0.5;
[new_lat,new_long] = newPosition (lat, long, bearing2, distance);
Z = [new_lat,new_long];

end