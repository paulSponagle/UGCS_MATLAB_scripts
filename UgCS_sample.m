% this script allows for segments to amended as required for use in UgCS
%% create the header
docNode1 = UgCS_header();
%% create Route Settings
routeName='debug';
initialData{1,1} = 'Route Name'; initialData{1,2} = routeName;
initialData{2,1} = 'Home - Set Explicitly'; initialData{2,2}= 'EXPLICIT';
initialData{3,1} = 'Home Lat'; initialData{3,2}= 43.0771836;      %[DD] North is positive
initialData{4,1} = 'Home Long'; initialData{4,2}= -77.6706067;    %[DD] East is positive
initialData{5,1} = 'Home Altitude'; initialData{5,2}= 151;      % [m AMSL or m AGL]
initialData{6,1} = 'Avoid aerodromes'; initialData{6,2} = 'true';
initialData{7,1} = 'Avoid Custom Zones'; initialData{7,2} = 'false';
initialData{8,1} = 'Maximum Altitude'; initialData{8,2} = 200;   % [m AMSL or m AGL]
initialData{9,1} = 'Emergency return Altitude'; initialData{9,2}= 175;
initialData{10,1} = 'Vehicle Profile'; initialData{10,2}= 5; % 1 = ArDrone, 2 = DjiPhantom3, 3 = DjiPhantom4, 3 = S-900/1000, 5 = matrice ;
initialData{11,1} = 'Altitude mode'; initialData{11,2} = 'AGL'; %AGL, WGS84
initialData{12,1} = 'Trajectory Type'; initialData{12,2}= 151+50;
%InitialData{13,1} = 'Action on loss of telemetry'; InitialData{13,2}= ;

docNode1 = UgCS_initialData(docNode1,initialData);

%% create a takeoff point
seg_order=0;
WP_data=cell(7,2);
WP_data{1,1}='order';
WP_data{1,2}=seg_order;
WP_data{2,1} = 'latitude';
WP_data{2,2} = 43.0770450;
WP_data{3,1} = 'longitude';
WP_data{3,2} = -77.6708453;
WP_data{4,1} = 'altitude';
WP_data{4,2} = 0;
WP_data{5,1} = 'speed, m/s';
WP_data{5,2} = 0.5;
WP_data{6,1} = 'Avoid Obstacles?';
WP_data{6,2} = 'True';
WP_data{7,1} = 'Avoid Terrain?';
WP_data{7,2} = 'True';
docNode1 = UgCS_segment_takeoff(docNode1,WP_data);
%% create a waypoint
seg_order=seg_order+1;
WP_data=cell(9,2);
WP_data{1,1}='order';
WP_data{1,2}=seg_order;
WP_data{2,1} = 'latitude';
WP_data{2,2} = 43.0770450;
WP_data{3,1} = 'longitude';
WP_data{3,2} = -77.6708453;
WP_data{4,1} = 'altitude';
WP_data{4,2} = 2;
WP_data{5,1} = 'speed, m/s';
WP_data{5,2} = 0.5;
WP_data{6,1} = 'Avoid Obstacles?';
WP_data{6,2} = 'True';
WP_data{7,1} = 'Avoid Terrain?';
WP_data{7,2} = 'True';
WP_data{8,1} = 'Turn type'; 
WP_data{8,2} = 1;           % use 1 for STOP_AND_TURN or 2 for SPLINE
WP_data{9,1}='Altitude Type';
WP_data{9,2}='WGS84';
docNode1 = UgCS_segment_WP(docNode1,WP_data);
%% add wait action to a segment
% The order of each action must be specified in data
act_order=0;
data = cell(2);
data{1,1}='order';
data{2,1}='interval';
data{1,2}=act_order;
data{2,2}=30;
docNode1 = UgCS_Action_Wait(docNode1,data,seg_order);
%% create a waypoint
seg_order=seg_order+1;
WP_data=cell(9,2);
WP_data{1,1}='order';
WP_data{1,2}=seg_order;
WP_data{2,1} = 'latitude';
WP_data{2,2} = 43.0780450;
WP_data{3,1} = 'longitude';
WP_data{3,2} = -77.6718453;
WP_data{4,1} = 'altitude';
WP_data{4,2} = 0;
WP_data{5,1} = 'Avoid Obstacles?';
WP_data{5,2} = 'True';
WP_data{6,1} = 'Avoid Terrain?';
WP_data{6,2} = 'True';
WP_data{8,1} = 'Turn type'; 
WP_data{8,2} = 1;           % use 1 for STOP_AND_TURN or 2 for SPLINE
WP_data{9,1}='Altitude Type';
WP_data{9,2}=1; %1='WGS84'   2='AGL'
docNode1 = UgCS_segment_WP(docNode1,WP_data);

%% add yaw action
act_order=0;
yaw_data{1,1}='order';
yaw_data{2,1}='heading';
yaw_data{1,2}=act_order;
yaw_data{2,2}=180;
docNode1 = UgCS_Action_Yaw(docNode1,yaw_data,seg_order);
%% add camera action
act_order=act_order+1;
cam_data{1,1}='order';
cam_data{1,2}=act_order;
cam_data{2,1}='tilt';
cam_data{2,2}=10;
cam_data{3,1}='roll';
cam_data{3,2}=0;
cam_data{4,1}='yaw';
cam_data{4,2}=0;
cam_data{5,1}='zoom';
cam_data{5,2}=1;
docNode1 = UgCS_Action_camControl(docNode1,cam_data,seg_order);

%% add POI (point of interest) action (stare point)
act_order=act_order+1;
poi_data=cell(4,2);
poi_data{1,1}='order';
poi_data{2,1}='latitude';
poi_data{3,1}='longitude';
poi_data{4,1}='altitude';
poi_data{1,2}=act_order;
poi_data{2,2}=43.0770450;
poi_data{3,2}=-77.6708453;
poi_data{4,2}=3;
docNode1= UgCS_Action_poi(docNode1,poi_data,seg_order);

%% Turn video camera on
act_order=act_order+1;
act_data = cell(2,2);
act_data{1,1}='order';
act_data{2,1}='state';
act_data{1,2}=act_order;
act_data{2,2}=1; % states: 1 - Start recording, 2 - stop, 3-single shot
docNode1 = UgCS_Action_camTrigger(docNode1,act_data,seg_order);

%% Add camera action by time definition
%- order
%               - interval
%               - shotsNumber
%               - startDelay
%               - autoCalc  % 0 =false, 1= true
act_order = act_order+1;
time_data=cell(4,2);
time_data{1,1} = 'order';
time_data{2,1} = 'interval';
time_data{3,1} = 'Number of Shots';
time_data{4,1} = 'Start Delay';
time_data{1,2} = act_order;
time_data{2,2} = 30;
time_data{3,2} = 5;
time_data{4,2} = 3;

docNode1 = UgCS_Action_camTimer(docNode1,time_data,seg_order);
%% Add camera action based on distance
act_order=act_order+1;
dist_data=cell(4,2);
dist_data{1,1} = 'order';
dist_data{2,1} = 'distance';
dist_data{3,1} = 'Number of Shots';
dist_data{4,1} = 'Start Delay';
dist_data{1,2} = act_order;
dist_data{2,2} = 30;
dist_data{3,2} = 5;
dist_data{4,2} = 3;

docNode1 = UgCS_Action_camDistance(docNode1,dist_data,seg_order);


%% add panning camera action
act_order=act_order+1;
pan_data=cell(7,2);
pan_data{1,1} = 'order';
pan_data{2,1} = 'angle';
pan_data{3,1} = 'stepAngle';
pan_data{4,1} = 'stepDelay';
pan_data{5,1} = 'rotationDirection';
pan_data{6,1} = 'rotationSpeed (degrees/s)';
pan_data{7,1} = 'panoramaMode';
pan_data{1,2} = act_order;
pan_data{2,2} = 180;
pan_data{3,2} = 5;
pan_data{4,2} = 1;
pan_data{5,2} = 2; % 1 for 'CLOCKWISE' else 'COUNTERCLOCKWISE'
pan_data{6,2} = 30;
pan_data{7,2} = 2; % 1 for 'VIDEO' else 'PHOTO'

docNode1= UgCS_Action_pan(docNode1,pan_data,seg_order);
%% create photogrammetry tool segment:
seg_order=seg_order+1;
photo_data=cell(5,2);
photo_data{1,1} = 'order';      photo_data{1,2} =seg_order;
photo_data{2,1} = 'speed';      photo_data{2,2} =0.5;
photo_data{3,1} = 'Turn Type';  photo_data{3,2} = 1;
photo_data{4,1} = 'camera';     photo_data{4,2} = 38; %38 for Phantom 3
photo_data{5,1} = 'GSD';        photo_data{5,2} = 0.5;
photo_data{6,1} = 'Forward Overlap';            photo_data{6,2} = 50;
photo_data{7,1} = 'Cross Track overlap';        photo_data{7,2} = 50;
photo_data{8,1} = 'Camera Top Facing forward';  photo_data{8,2} = 1;
photo_data{9,1} = 'direction Angle';            photo_data{9,2} = 0;
photo_data{10,1} = 'Avoid Obstacles';           photo_data{10,2} = 1;
photo_data{11,1} = 'Action Execution'; 
photo_data{11,2} = 1; % 1 ACTIONS_EVERY_POINT, 2 ONLY_AT_START, 3 ACTIONS_ON_FORWARD_PASSES
photo_data{12,1} = 'Generate Additional Waypoints'; photo_data{12,2} = 0;
photo_data{13,1} = 'overshoot';     photo_data{13,2} = 3;
photo_data{14,1} = 'altitude Type'; photo_data{14,2} = 1; % 1 - WGS84, 2 - AGL
photo_data{15,1} = 'Allow Partial calculation'; photo_data{15,2} = 1; %1 True
photo_data{16,1} = 'No Actions at last point';  photo_data{16,2} = 1; %1 True

polyCoords=[43.0770800,-77.6707941,3;43.0771645,-77.6708351,3; 43.0772508, -77.6708217,3; 43.0772333, -77.6705777,3; 43.0771614, -77.6705773,3; 43.0770425, -77.6705919,3];

docNode1=UgCS_segment_photogrammetry(docNode1,photo_data, polyCoords);
%% add an 'Area Scan' segment
seg_order=seg_order+1;
area_data=cell(13,2);
area_data{1,1}='order';         area_data{1,2} = seg_order;
area_data{2,1} = 'speed';       area_data{2,2} = 0.5;
area_data{3,1}='Turn Type';     area_data{3,2} = 1; % 1 'STOP_AND_TURN', 2 'SPLINE'
area_data{4,1}='height';        area_data{4,2} = 4;
area_data{5,1}='Altitude Type'; area_data{5,2} = 1; %1 AGL, %2 AMSL
area_data{6,1}='Side Distance'; area_data{6,2} = 1;
area_data{7,1}='Direction angle';  area_data{7,2}=0;
area_data{8,1}='Avoid Obstacels';   area_data{8,2}=1; % 1=True
area_data{9,1}='Action Execution'; 
area_data{9,2}=1; % 1 ACTIONS_EVERY_POINT, 2 ONLY_AT_START, 3 ACTIONS_ON_FORWARD_PASSES
area_data{10,1}='overshoot'; area_data{10,2}=1.1;
area_data{11,1}='Allow Partial Calculation';area_data{11,2}=1;% 1='True' 
area_data{12,1}='Tolerance';area_data{12,2}=1; 
area_data{13,1}='no actions at last point?';area_data{13,2}=0; % 1='True' 
docNode1 = UgCS_segment_areaScan(docNode1,area_data,polyCoords);
%% Create 'Cirlce' segment
seg_order=seg_order+1;
circle_data=cell(15,2);
circle_data{1,1}= 'order';                  circle_data{1,2}=seg_order;
circle_data{2,1}='Lattitude (DD)';          circle_data{2,2}=43.0771425;
circle_data{3,1}='Longitude (DD)';          circle_data{3,2}=-77.6706869;
circle_data{4,1}='Altitude AGL (m)';        circle_data{4,2}=3;
circle_data{5,1}='radius (m)';              circle_data{5,2}=7;
circle_data{6,1}='speed (m)';               circle_data{6,2}=0.5;
circle_data{7,1}='Waypoint Turn Type (1,2)';
% 1 = STOP_AND_TURN, 2= STRAIGHT
                                            circle_data{7,2}=1;
circle_data{8,1}='loops';                   circle_data{8,2}=2;
circle_data{9,1}='Fly Clockwise? 1= yes';   circle_data{9,2}=1;
circle_data{10,1}='Base Points';            circle_data{10,2}=30;
circle_data{11,1}='Follow Terrain 1= True'; circle_data{11,2}=1;
circle_data{12,1}='Action Execution';       
            % 1= AT_EVERY_POINT, 2= ONLY_AT_START
                                            circle_data{12,2}=1;
circle_data{13,1}='Avoid Obstacles? 1=True';circle_data{13,2}=1;
circle_data{14,1}='Avoid Terrain? 1= True'; circle_data{14,2}=1;
circle_data{15,1}='Action at last point? 1=True';circle_data{15,2}=0;

docNode1 = UgCS_segment_circles(docNode1,circle_data);
%% add a 'Perimeter' segment
seg_order=seg_order+1;
perimeter_data=cell(15,2);
perimeter_data{1,1}= 'order';             perimeter_data{1,2}=seg_order;
perimeter_data{2,1}='speed (m)';          perimeter_data{2,2}=0.5;
perimeter_data{3,1}='Waypoint Turn Type (1,2)';perimeter_data{3,2}=1;
% 1 = STOP_AND_TURN, 2= STRAIGHT
perimeter_data{4,1}='Altitude AGL (m)';        perimeter_data{4,2}=3;
perimeter_data{5,1}='Altitude type(1=AGL)';    perimeter_data{5,2}=7;
perimeter_data{6,1}='Number of loops';         perimeter_data{6,2}=1;
perimeter_data{7,1}='Action execution (1=True)';
%                                   1= AT_EVERY_POINT, 2= ONLY_AT_START
                                               perimeter_data{7,2}=1;
perimeter_data{8,1}='Avoid Obstacles 1=True';  perimeter_data{8,2}=1;
perimeter_data{9,1}='Avoid Terrain 1= True';    perimeter_data{9,2}=1;
perimeter_data{10,1}='Actions at Last Point 1=True';perimeter_data{10,2}=0;

polygon_perim = [ 43.0770046,-77.6705557;43.0770290,-77.6708808;43.0772767,-77.6708509;43.0772242,-77.6705107];
docNode1 = UgCS_segment_perimeter(docNode1,perimeter_data,polygon_perim);

%% add "Landing" segment
seg_order=seg_order+1;
land_data{1,1}='order';          land_data{1,2}=seg_order;
land_data{2,1}='Lattitude (DD)'; land_data{2,2}=43.0771467;
land_data{3,1}='Longitude (DD)'; land_data{3,2}=-77.6705560;
land_data{4,1}='altitude (m)';   land_data{4,2}=3;
land_data{5,1}='speed';          land_data{5,2}=0.5;
land_data{6,1}='obstacles (1=True)';      land_data{6,2}=1;
land_data{7,1}='terrain (1=True)';        land_data{7,2}=1;
docNode1 = UgCS_segment_land(docNode1,land_data);

%% add UgCSfooter
%% write the file and display in commmand window
fileName=strcat(routeName,'.xml');
xmlwrite(fileName,docNode1);
type(fileName);