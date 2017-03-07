% this script creates a flight plan for structure-from motion flights

%% user must enter this data to begin with
image_angle = 180;      % +/- 65degrees
swaths = 25;            % whole number
distance = 15;          % distance from target
speed = 2;              % m/s
turn_type=1;            % 1=STOP_AND_GO, 2='SPLINE', 3 = 'STRAIGHT'

%safe_lat = ;          %it may be desirable to specify a safe place to
                        % start from in order to avoid obstacles (future
                        % capability)
%safe_long = ;         %
start_lat = 43.0947178; % DD - pick start point before the structure, but aligned with it. 
start_long = -77.4292718;% DD 
start_height = 10;       % metres
span = 18;              % metres
direction = 32;         % degrees - orientation of span.
                        % The direction might not be known and it may be
                        % necessary to calculate from providing start and
                        % end points.
homeLat=start_lat;
homeLong=start_long;
interval = 5; % metres
routeName='Elevated Span (Geneva)';
[midLat,midLong] = newPosition(start_lat, start_long, direction, span/2);
%% WP calculation
angles= linspace(-image_angle/2,image_angle/2,swaths)';
altitude=distance*cosd(angles)+start_height;
obj_distance=distance*sind(angles); % distance from target
% enter loop to create array for start points and separate array for end
% points. each leg will correspond to an element in angels vector
home_lat=0*angles;
home_long=home_lat;

for ii=1:length(angles)
    [home_lat(ii),home_long(ii)]=newPosition(start_lat, start_long, direction+90, obj_distance(ii));
end
scatter3(home_long,home_lat,altitude,'bo')
[end_lat, end_long]=newPosition(home_lat, home_long, direction, span);
hold on, scatter3(end_long,end_lat,altitude,'ro')

% order start and end_points to get  [WP_lat, WP_long, alt]
WP=zeros(2*length(angles),6);
jj=1;
for ii=1:length(angles)         % ii corresponds to leg
    if mod(ii,2)~=0 % if odd
        WP(2*ii-1,1) = home_lat(ii);
        WP(2*ii-1,2) = home_long(ii);
        WP(2*ii,1) = end_lat(ii);
        WP(2*ii,2)= end_long(ii);
    else
        WP(2*ii-1,1) = end_lat(ii); 
        WP(2*ii-1,2) = end_long(ii);
        WP(2*ii,1) = home_lat(ii);
        WP(2*ii,2)= home_long(ii);
    end
        WP(2*ii-1:2*ii,3)=altitude(ii);
        tilt=90-abs(angles(ii));
        if tilt<0
            tilt=0;
        end
        WP(2*ii-1:2*ii,6)=tilt; %tilt angle
end
WP(1:end,4)=speed;
WP(1:end,5)=turn_type;

figure(1)
subplot(1,2,1), plot(WP(:,2),WP(:,1),'bo-')
title('Bird''s eye Flight path')
xlabel('Longitude [DD]')
ylabel('Latitude [DD]')
subplot(1,2,2), scatter3(WP(:,2),WP(:,1),WP(:,3),'r*')
title('Waypoints in 3D')
xlabel('Longitude [DD]')
ylabel('Latitude [DD]')
zlabel('Altitude [m]')

% find yaw angles
yaw=zeros(size(WP,1),1);
[centerLat,centerLong] = newPosition(start_lat, start_long, direction, span/2);

%% create the header
docNode1 = UgCS_header();
%% create Route Settings

initialData{1,1} = 'Route Name'; initialData{1,2} = 'Elevated Span';
initialData{2,1} = 'Home - Set Explicitly'; initialData{2,2}= 'EXPLICIT';
initialData{3,1} = 'Home Lat'; initialData{3,2}= homeLat;      %[DD] North is positive
initialData{4,1} = 'Home Long'; initialData{4,2}= homeLong;    %[DD] East is positive
initialData{5,1} = 'Home Altitude'; initialData{5,2}= 0;      % [m AMSL or m AGL]
initialData{6,1} = 'Avoid aerodromes'; initialData{6,2} = 'true';
initialData{7,1} = 'Avoid Custom Zones'; initialData{7,2} = 'false';
initialData{8,1} = 'Maximum Altitude'; initialData{8,2} = 200;   % [m AMSL or m AGL]
initialData{9,1} = 'Emergency return Altitude'; initialData{9,2}= 30;
initialData{10,1} = 'Vehicle Profile'; initialData{10,2}= 5; % 1 = ArDrone, 2 = DjiPhantom3, 3 = DjiPhantom4, 3 = S-900/1000, 5 = matrice ;
initialData{11,1} = 'Altitude mode'; initialData{11,2} = 'AGL'; %AGL, WGS84

docNode1 = UgCS_initialData(docNode1,initialData);
seg_order=0;
for ii=1:size(WP,1)
WP_data=cell(9,2);
WP_data{1,1}='order';
WP_data{1,2}=seg_order;
WP_data{2,1} = 'latitude';
WP_data{2,2} = WP(ii,1);
WP_data{3,1} = 'longitude';
WP_data{3,2} = WP(ii,2);
WP_data{4,1} = 'altitude';
WP_data{4,2} = WP(ii,3);
WP_data{5,1} = 'speed, m/s';
WP_data{5,2} = speed;
WP_data{6,1} = 'Avoid Obstacles?';
WP_data{6,2} = 'True';
WP_data{7,1} = 'Avoid Terrain?';
WP_data{7,2} = 'True';
WP_data{8,1} = 'Turn type'; 
WP_data{8,2} = 1;           % use 1 for STOP_AND_TURN or 2 for SPLINE
WP_data{9,1}='Altitude Type';
WP_data{9,2}='AGL';
docNode1 = UgCS_segment_WP(docNode1,WP_data);

act_order=0;

% Add POI action to stare at middle of span
%poi_data=cell(4,2);
poi_data{1,1}='order';
poi_data{2,1}='latitude';
poi_data{3,1}='longitude';
poi_data{4,1}='altitude';
poi_data{1,2}=act_order;
poi_data{2,2}=midLat;
poi_data{3,2}=midLong;
poi_data{4,2}=start_height;
docNode1= UgCS_Action_poi(docNode1,poi_data,seg_order);

act_order = act_order+1;

% Add camera tilt angle
cam_data{1,1}='order';
cam_data{1,2}=act_order;
cam_data{2,1}='tilt'; % This is lookdown angle
cam_data{2,2}=WP(ii,6);
cam_data{3,1}='roll';
cam_data{3,2}=0;
cam_data{4,1}='yaw';
cam_data{4,2}=0;
cam_data{5,1}='zoom';
cam_data{5,2}=1;
docNode1 = UgCS_Action_camControl(docNode1,cam_data,seg_order);

act_order = act_order+1;
% add camera action
% dist_data=cell(4,2);
% dist_data{1,1} = 'order';
% dist_data{2,1} = 'distance';
% dist_data{3,1} = 'Number of Shots';
% dist_data{4,1} = 'Start Delay';
% dist_data{1,2} = act_order;
% dist_data{2,2} = interval;
% dist_data{3,2} = ceil(span/interval);
% dist_data{4,2} = 0;
% 
% docNode1 = UgCS_Action_camDistance(docNode1,dist_data,seg_order);
seg_order=seg_order+1;

end
% add footer
docNode1=UgCS_footer(docNode1);
%save
fileName=strcat(routeName,'.xml');
xmlwrite(fileName,docNode1);
type(fileName);

% for ii=1:size(WP,1)-1
%     nextPoint=bearing(WP(ii,1),WP(ii,2),WP(ii+1,1),WP(ii+1,2)); %bearing to next waypoint
%     targetDir=bearing(WP(ii,1),WP(ii,2), centerLat,centerLong); %bearing to target center
%     bearingDif = nextPoint - targetDir;
%     if bearingDif<0
%         bearingDif=bearingDif+360;
%     elseif bearingDif >= 360
%         bearingDif=bearingDif-360;
%     end    
%      if (bearingDif>=0 && bearingDif<45) ||  (bearingDif>=315 && bearingDif<360)
%          yaw(ii)=0;
%      elseif bearingDif>=45 && bearingDif<135
%          yaw(ii)=90;
%      elseif bearingDif>=135 && bearingDif<225
%          yaw(ii) = 180;
%      elseif bearingDif>=225 && bearingDif<315
%          yaw(ii) = 270;
%      end    
% end
% Z = matrix2UgCS(WP,0,0);
% tilt = 90-angles;

%% Add quivers

%basic geometry
x = distance * sind(angles); % x axis is perpindicular to span
y1 = 0 * cosd(angles);
y2 = span + y1;
z = distance * cosd(angles);

figure
scatter3(x,y1,z,'bo')
hold on
scatter3(x,y2,z,'bo')
scatter3(x,y2/2,z,'bo')
scatter3([0, 0,0],[0, span/2,span],[0,0,0],'k*')
quiver3(x,y1,z,-x,-y1,-z)
quiver3(x,y2,z,-x,y1,-z)
quiver3(x,y2/2,z,-x,y1,-z)
title('Sensor position and orientation (Bridge Inspection)')
xlabel('x-direction [m]')
ylabel('y-direction [m]')
zlabel('z-direction [m]')



