% This is file was used to crate the function "footprintFrameOblique" Use
% the function instead of this script.

% top of sensor must be kept below horizon for footprint to be calculated

roll = -20;    %rotation about long axis (x-axis). Positive is a roll to the right.
pitch = 20; %rotation about lat axis (y-axis). Positive is nose up.
heading = 0; %rotation about the normal axis (Z-axis). Positive is right rudder.
sensor_w = 35;
sensor_h = 24;
altitude = 1600;
f = 60;
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
factor_FL = -altitude/FL(3);
factor_FR = -altitude/FR(3);
factor_RR = -altitude/RR(3);
factor_RL = -altitude/RL(3);
%coordinates projected on the ground
FL = FL*factor_FL;
FR = FR*factor_FR;
RR = RR*factor_RR;
RL = RL*factor_RL;
figure(1), 
plot(0,0,'bs'), hold on
plot (FL(1),FL(2),'ro');
plot (FR(1),FR(2),'go');
plot (RR(1),RR(2),'bo');
plot (RL(1),RL(2),'ko');
disp([FL;FR;RR;RL])
coords_xy = [FL(1:2);FR(1:2);RR(1:2);RL(1:2)];
plane=max(coords_xy(:))+100;
axis([-plane, plane,-plane,plane])
% bearing to each point.  
%Keep in mind:
%       that bearings are measured clockwise from North
%       polar coordinates are measured counter clockwise from the x-axis
%       negative y-values are to the left of the aircraft
bearings = atan2d(coords_xy(:,2),coords_xy(:,1));
distances_xy = (coords_xy(:,1).^2+coords_xy(:,2).^2).^.5;

