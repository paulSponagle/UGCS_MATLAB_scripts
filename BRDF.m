% This script generates a flight plan for gathering BRDF data. The
% algorithm positions the aircraft and the gimbal to keep the desired
% target in the middle of the frame.

% for at sensor irradiance measurements, it is critical that ISO, aperture
% and exposure are kept constant.

%% user inputs - manual inputs required
target_lat = 42.95162;        % [DD]
target_long = -1*(77.492981);      % [DD] negative is West
target_alt_AMSL=241.6;            % [m] determine using measurment tool
home_lat = 42.95162;
home_long = -1*(77.492981);
sensor_distance = 33;   % [m] distance from target
max_points = 90;        % [-] Different UAVs will have different limits (be conservative)
                        % this figure is available in the profile
routeName = 'BRDF_test_20m_Marty_';
aircraftType=5;         % 1 = ArDrone, 2 = DjiPhantom3, 3 = DjiPhantom4, 3 = S-900/1000, 5 = matrice-100
flightSpeed=2;          % [m/s]
turnType=1;             % 1 = Stop and go, 2= spline, 3= Adaptive Bank Turn
altitudeType=2;         % 1 = AGL, 2= WGS84

% The user may wish to define collection points based on a variety of
% factors. For example a UAV platform may only be capable of storing N
% waypoints (99 for the Matrice-100).  This may require multiple flights if
% fine detail is required. There needs to be a minimum altitude for the
% collect for safety reasons. This altitude will be determined by the
% platform or perhaps by the user if larger safety distances are required.
% The user may also wish to specify a specific range of zenith and azimuth
% angles. This is what is done for GRIT-T. The following code is designed
% to use the same coordinate scheme as GRIT-T.

%zenith = (0:15:60)';
%azimuth = (0:30:359)';
zenith = linspace(0,70,7)';
azimuth = linspace(0,360,20)';

%% Calculations
index=2;
points = (length(zenith)-1)*length(azimuth)+1;
flights = ceil(points/max_points);
if points > max_points
    fprintf('\nThere are %d points. %d flight plans are being created.\n',points,flights)
end

sensor_positions=zeros(points,8);
sensor_positions(1,3)=sensor_distance+target_alt_AMSL;
sensor_positions(1,7) =target_lat;
sensor_positions(1,8) = target_long;
for ii=2:length(zenith)
    for jj=1:length(azimuth)
        sensor_positions(index,1) = -sensor_distance * sind(zenith(ii))*cosd(azimuth(jj));    % [m] x-direction
        sensor_positions(index,2) = sensor_distance * sind(zenith(ii))*sind(azimuth(jj));     % [m] y- direction 
        sensor_positions(index,3) = target_alt_AMSL+sensor_distance * cosd(zenith(ii));       % [m] z- direction
        sensor_positions(index,4) = zenith(ii);     %[DD] zenith angle
        sensor_positions(index,5) = azimuth(jj);    % [DD] azimuth angle
        sensor_positions(index,6) = sensor_distance * sind(zenith(ii)); %[m] distance from origin in x-y plane
        [sensor_positions(index,7),sensor_positions(index,8)] = newPosition (target_lat, target_long,sensor_positions(index,5) , sensor_positions(index,6)); % [DD] lat/long
        index=index+1;
    end
end

subplot(1,2,1)
plot(sensor_positions(:,8),sensor_positions(:,7))
title('Flight Path from bird''s eye view')
xlabel('Longitude [DD]')
ylabel('Latitude [DD]')
subplot(1,2,2)
scatter3(sensor_positions(:,8),sensor_positions(:,7),sensor_positions(:,3))
title('Waypoints in 3D')
xlabel('Longitude [DD]')
ylabel('Latitude [DD]')
zlabel('Altitude [m]')
%% prepare flight plan 



% multiple flight plans may be required due to the number of waypoints that
% can be passed to a particular UAV
route_points = floor(points/flights);
begin=1;
cease=route_points;
for jj =1:flights
    newRouteName = strcat(routeName, num2str(jj));
    
    
    
    %% create the header
    docNode1 = UgCS_header();
    %% create Route Settings

initialData{1,1} = 'Route Name'; initialData{1,2} = newRouteName;
initialData{2,1} = 'Home - Set Explicitly'; initialData{2,2}= 'EXPLICIT';
initialData{3,1} = 'Home Lat'; initialData{3,2}= home_lat;      %[DD] North is positive
initialData{4,1} = 'Home Long'; initialData{4,2}= home_long;    %[DD] East is positive
initialData{5,1} = 'Home Altitude'; initialData{5,2}= 151;      % [m AMSL or m AGL]
initialData{6,1} = 'Avoid aerodromes'; initialData{6,2} = 'true';
initialData{7,1} = 'Avoid Custom Zones'; initialData{7,2} = 'false';
initialData{8,1} = 'Maximum Altitude'; initialData{8,2} = 200;   % [m AMSL or m AGL]
initialData{9,1} = 'Emergency return Altitude'; initialData{9,2}= 175;
initialData{10,1} = 'Vehicle Profile'; initialData{10,2}= 5; % 1 = ArDrone, 2 = DjiPhantom3, 3 = DjiPhantom4, 3 = S-900/1000, 5 = matrice ;
initialData{11,1} = 'Altitude mode'; initialData{11,2} = altitudeType; %1= AGL, 2 =AMSL
initialData{12,1} = 'Trajectory Type'; initialData{12,2}= 151+50;
docNode1 = UgCS_initialData(docNode1,initialData);
    
    %% create waypoints
    seg_order=0;
    for ii=begin: cease
        WP_data=cell(8,2);
        WP_data{1,1} = 'order'; WP_data{1,2} = seg_order;
        WP_data{2,1} = 'latitude'; WP_data{2,2} = sensor_positions(ii,7);
        WP_data{3,1} = 'longitude'; WP_data{3,2} = sensor_positions(ii,8);
        WP_data{4,1} = 'altitude'; WP_data{4,2} = sensor_positions(ii,3);
        WP_data{5,1} = 'speed, m/s'; WP_data{5,2} = flightSpeed;
        WP_data{6,1} = 'Avoid Obstacles?'; WP_data{6,2} = 'True';
        WP_data{7,1} = 'Avoid Terrain?'; WP_data{7,2} = 'True';
        WP_data{8,1} = 'Turn type';  WP_data{8,2} = turnType;     % use 1 for STOP_AND_TURN or 2 for SPLINE 3 for straight
        WP_data{9,1} ='Altitude type'; WP_data{9,2} = altitudeType; % for BRDF this needs to be 2 for WGS84
        
        docNode1 = UgCS_segment_WP(docNode1,WP_data);
        
        % attach POI action, camera tilt,  pause?, capture frame.
        %% add POI (point of interest) action (stare point)
        act_order=0;
        poi_data=cell(4,2);
        poi_data{1,1}='order';
        poi_data{1,2}=act_order;
        poi_data{2,1}='latitude';
        poi_data{2,2}=target_lat;
        poi_data{3,1}='longitude';
        poi_data{3,2}=target_long;
        poi_data{4,1}='altitude';
        poi_data{4,2}=0;
        docNode1= UgCS_Action_poi(docNode1,poi_data,seg_order);
        
        %% add camera action
        act_order=1;
        cam_data{1,1}='order';
        cam_data{1,2}=act_order;
        cam_data{2,1}='tilt';
        cam_data{2,2}=90-sensor_positions(ii,4);
        cam_data{3,1}='roll';
        cam_data{3,2}=0;
        cam_data{4,1}='yaw';
        cam_data{4,2}=0;
        cam_data{5,1}='zoom';
        cam_data{5,2}=1;
        docNode1 = UgCS_Action_camControl(docNode1,cam_data,seg_order);
        
        %% Shoot single frame
        act_order=2;
        act_data = cell(2,2);
        act_data{1,1}='order';
        act_data{2,1}='state'; 
        act_data{1,2}=act_order;
        act_data{2,2}=3; % states: 1 - Start recording, 2 - stop, 3-single shot
        docNode1 = UgCS_Action_camTrigger(docNode1,act_data,seg_order);
        seg_order=seg_order+1;
    end
    %% add "Landing" segment (bad idea?)
    % seg_order=points;
    % land_data{1,1}='order';             land_data{1,2}=seg_order;
    % land_data{2,1}='Latitude (DD)';     land_data{2,2}=sensor_positions(end,7);
    % land_data{3,1}='Longitude (DD)';    land_data{3,2}=sensor_positions(end,8);
    % land_data{4,1}='altitude (m)';      land_data{4,2}=0;
    % land_data{5,1}='speed';             land_data{5,2}=0.5;
    % land_data{6,1}='obstacles (1=True)';      land_data{6,2}=1;
    % land_data{7,1}='terrain (1=True)';        land_data{7,2}=1;
    % docNode1 = UgCS_segment_land(docNode1,land_data);
    %% add footer
    Z=UgCS_footer(docNode1);
    %% write the file and display in commmand window
    fileName=strcat(newRouteName,'.xml');
    xmlwrite(fileName,docNode1);
    fprintf('\n%s created.\n',fileName) 
    %type(fileName);
    begin=cease+1;
    cease=begin+route_points;
end

%% This section illustrates the position and orientation of the sensor for each capture 
x=sensor_positions(:,1);
y=sensor_positions(:,2);
height=sensor_positions(:,3)-target_alt_AMSL;
figure
scatter3(x,y,height)
hold on
n=100;
quiver3(x,y,height,-x/n,-y/n,-height/n)
scatter3(0,0,0,'k*')
title('Sensor position and orientation (hemisphere)')
xlabel('x-direction [m]')
ylabel('y-direction [m]')
zlabel('z-direction [m]')
