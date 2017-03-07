% This script will provide a flightplan when the user enters:
%       - AOI, by clicking on a map.
%       - speed used throughout
%       - location of calibration panels
%close all
clear all
format long

%% Current bug sometimes a leg is skipped


%% Section 1 - Upload imagery
img=imread('/Users/Paul/Documents/Courses/Project/flight planning/Geneva/Geneva_tiff.tif');
img_size=size(img);
rows=img_size(1);
cols=img_size(2);
up = 42 + 52/60+ 27.26/3600;        % latitude of the top of the frame
down = 42 +52/60+22.88/3600;        % latitude of the bottom of the frame
left = -1*(77+1/60+39.59/3600);       % longitude of the left side of the frame
right =-1*(77+1/60+35.52/3660);       % longitude of the right side of the frame
figHandle=figure(1);
%figHandle.OuterPosition = [ 1000 500 size(img,2)*4 size(img,1)*2];
imshow(img)
hold on
%% Section 2 - User-defined variables using map as a GUI
% click on map to locate ROI
hold on
imshow(img)
title('Step 1 - Identify ROI, press ''Return'' when done')
[AOI_x,AOI_y] = ginput;
[AOI_lat,AOI_long] = xy2latLong(up, down, left, right, rows, cols, AOI_x, AOI_y);
plot([AOI_x;AOI_x(1)],[AOI_y;AOI_y(1)],'c-')
%figHandle.Position = [100 size(img,1) size(img,2)*1.5 size(img,1)*1.5];
%legend('Bounded area','Location', 'EastOutside')
title('Step 2 - Identify launch location')
[TO_x,TO_y] = ginput(1);
[TO_lat,TO_long] = xy2latLong(up, down, left, right, rows, cols, TO_x, TO_y);
plot(TO_x,TO_y,'gs')
%figHandle.Position = [100 size(img,1) size(img,2)*1.5 size(img,1)*1.5];
%figHandle.OuterPosition = [ 1000 500 size(img,2)*1.5 size(img,1)*1.5];
%legend('Bounded area','launch point','Location', 'EastOutside')
title('Step 3 - Identify location of cal panels, press ''return'' when done')
[cal_x,cal_y] = ginput(1);
plot(cal_x,cal_y,'m*')
[cal_lat,cal_long]=xy2latLong(up, down, left, right, rows, cols, cal_x, cal_y);
% figHandle.Position = [100 size(img,1) size(img,2)*1.5 size(img,1)*1.5];
% figHandle.OuterPosition = [ 1000 500 size(img,2)*1.5 size(img,1)*1.5];
%legend('Bounded area','launch point','Cal targets','Location', 'EastOutside')

min_cal_time = 180;

% **************
% 'min_cal_time' is the minimum time between overflying the calibration
% target.  After completing each leg the algorithm will check to see if
% this time has been exceded. If so, it will fly to the cal target.
%       If required, Future code will be modified to allow cal target to be
%       moved.  The target position will be adjusted along a straight line.
%       The UAV will overfly the closest position first, then the
%       move towards the other end of the line.

%% Section 3 - Camera settings for Nikon D800.
speed = 5; % m/s
overlap_along_track = .6;
overlap_cross_track = .6;
altitude = 30;             % in metres AGL
uav_groundspeed = 5;        % in m/s
camera_f = 60;              % focal length in mm
camera_l_pixels = 7360;
camera_l_array_size = 35.9; % in mm
camera_w_pixels = 4912;
camera_w_array_size = 24;   % in mm
camera_foot_l = altitude*camera_l_array_size/camera_f; % crosstrack in metres
camera_foot_w = altitude*camera_w_array_size/camera_f; % alongtrack in metres
distance_between_legs = (1-overlap_cross_track)*camera_foot_l;
distance_between_events = (1-overlap_along_track)*camera_foot_w;

%% Section 4 - Algorithm to find imaging events
% find extreme lat/long in the scene:
AOI_max_y = max(AOI_y);
AOI_min_y = min(AOI_y);
AOI_max_x = max(AOI_x);
AOI_min_x = min(AOI_x);
[AOI_max_lat,AOI_max_long] = xy2latLong(up, down, left, right, rows, cols, AOI_min_x, AOI_min_y);
[AOI_min_lat, AOI_min_long] = xy2latLong(up, down, left, right, rows, cols, AOI_max_x, AOI_max_y);
AOI_delta_lat = abs(AOI_max_lat-AOI_min_lat);
AOI_delta_long = abs(AOI_max_long-AOI_min_long);

% find approximate center of the AOI
AOI_mid_x = (AOI_min_x + AOI_max_x)*.5;
AOI_mid_y = (AOI_min_y + AOI_max_y)*.5;
% convert AOI, and AOI_mids to lat/long
[AOI_mid_lat, AOI_mid_long]=xy2latLong(up, down, left, right, rows,cols, AOI_mid_x, AOI_mid_y);
[AOI_lat, AOI_long]=xy2latLong(up, down, left, right, rows, cols, AOI_x, AOI_y);

% find principal component of AOI in xy coords
AOI = [AOI_x,AOI_y];

vect = pca(fliplr(AOI));

direction_of_flight=vect(:,2);
heading = 90-atan2(direction_of_flight(2),direction_of_flight(1))*180/pi;
heading(heading<0)=heading+180;
heading(heading>360)=heading-360;
orthog = heading+90;
orthog(orthog<0)=orthog+180;
orthog(orthog>180)=orthog-180;


plot([TO_x,TO_x+vect(2,1)*.3*img_size(2)],[TO_y,TO_y+vect(1,1)*.3*img_size(2)],'g-')
plot([TO_x,TO_x+vect(2,2)*.3*img_size(2)],[TO_y,TO_y+vect(1,2)*.3*img_size(2)],'b-')
legend('Bounded area','launch point','Cal panel', 'direction of flight','orthoginal')


% Find cross-track locations from center point:
ii=0;
new_lat = AOI_mid_lat;
new_long = AOI_mid_long;
while new_lat <= up && new_lat >= down && ...
        new_long <= right && new_long >= left
    [new_lat,new_long] = newPosition (AOI_mid_lat, AOI_mid_long, orthog, ii*distance_between_legs);
    [new_x,new_y] = latLong2xy(up, down, left, right, rows, cols, new_lat, new_long);
    %plot(new_x,new_y,'co')
    orthoginal_points_1(ii+1,:) = [new_lat,new_long];
    ii=ii+1;
end
ii=1;
new_lat = AOI_mid_lat;
new_long = AOI_mid_long;
while new_lat <= up && new_lat >= down && ...
        new_long <= right && new_long >= left
    [new_lat,new_long] = newPosition (AOI_mid_lat, AOI_mid_long, orthog+180, ii*distance_between_legs);
    orthoginal_points_2(ii,:) = [new_lat,new_long];
    [new_x,new_y] = latLong2xy(up, down, left, right, rows, cols, new_lat, new_long);
    %plot(new_x,new_y,'go')
    ii=ii+1;
end
orthoginal_points=[flipud(orthoginal_points_1);orthoginal_points_2];
orthoginal_points=orthoginal_points(2:end-1,:);
[orthoginal_points_x,orthoginal_points_y]=latLong2xy(up, down, left, right, rows, cols, orthoginal_points(:,1), orthoginal_points(:,2));
%plot(orthoginal_points_x,orthoginal_points_y,'rx')
legs_total=length(orthoginal_points);
max_lat=max([AOI(:,1);orthoginal_points(:,1)]);
min_lat = min([AOI(:,1);orthoginal_points(:,1)]);
max_long=max([AOI(:,2);orthoginal_points(:,2)]);
min_long = min([AOI(:,2);orthoginal_points(:,2)]);
for leg=1:legs_total
    new_lat= orthoginal_points(leg,1);
    new_long = orthoginal_points(leg,2);
    ii=2;
    while new_lat <= up +0.1*AOI_delta_lat && ...
            new_lat >= down - 0.25*AOI_delta_lat && ...
            new_long >= left - 0.25*AOI_delta_long && ...
            new_long <= right + 0.25*AOI_delta_long
        [new_lat,new_long] = newPosition (orthoginal_points(leg,1), orthoginal_points(leg,2), heading, ii*distance_between_events);
        points_1(ii,:) = [new_lat,new_long,leg];
        ii=ii+1;
    end
    new_lat= orthoginal_points(leg,1);
    new_long = orthoginal_points(leg,2);
    ii=1;
    while new_lat <= up +0.25*AOI_delta_lat && ...
            new_lat >= down - 0.25*AOI_delta_lat && ...
            new_long >= left - 0.25*AOI_delta_long && ...
            new_long <= right + 0.25*AOI_delta_long
        [new_lat,new_long] = newPosition (orthoginal_points(leg,1), orthoginal_points(leg,2), heading+180, (ii-2) * distance_between_events);
        points_2(ii,:) = [new_lat,new_long,leg];
        ii=ii+1;
    end
    if leg == 1
        points = [flipud(points_1);points_2];
        points=flipud(points);
    else
        new_points = [flipud(points_1);points_2];
        if (-1)^leg<0
            new_points=flipud(new_points);
        end
        %waypoints(2*leg-1,:) = new_points(1,:);
        %waypoints(2*leg,:) = new_points(end,:);
        points = [ points; new_points];
    end
end
%% reduce points
%use function 'inpolygon': in=inpolygon(xq,yq,xv,yv) to get rid of points outside
%of the AOI
points_lat=points(:,1);
points_long = points(:,2);
in = inpolygon(points_long,points_lat,AOI_long,AOI_lat);
points=points(in,:);
points_lat=points(:,1);
points_long=points(:,2);
[in_x,in_y] = latLong2xy(up,down,left,right,rows,cols,points_lat,points_long);
plot (in_x,in_y,'r+-')
% hold on, plot (points_long(~in),points_lat(~in),'bx')
legend('Bounded area','launch point','Cal panel', 'direction of flight','orthoginal','flight path')
title('flight path')

%% only use leg end points - remove all others

points_abrev = points(1:2,1:3);  %start with first two points and build onto it
legs_unique = unique(points(:,3));
for index=2:length(legs_unique)
    leg_index =find (points(:,3)==legs_unique(index));
    if length(leg_index)==1
        points_abrev=[points_abrev;points(leg_index,1:3)];
    else
        leg_start = leg_index(1);
        leg_end =leg_index(end);
        points_abrev=[points_abrev;points(leg_start,1:3);points(leg_end,1:3)];
    end
    
end
points=points_abrev;
%% build flight plan table
points=[TO_lat,TO_long,0;cal_lat,cal_long,0;points;cal_lat,cal_long,0;TO_lat,TO_long,0];
distance = zeros(size(points,1),1);
time=distance;
elapsed_time=time;
points=[points,distance,time,elapsed_time];
for index=1:(size(points,1)-1)
    points(index,4) = greatCircleEarth(points(index,1),points(index,2),points(index+1,1),points(index+1,2));
    points(index,5) = points(index,4)/speed;
    if index~=1
        points(index,6) = points(index-1,6)+points(index-1,5);
    end
end
points(end,6) = points(end-1,6) + points(end-1,5);
%% Add Cal panels
format short
fprintf('The total flight time with no re-visits to cal panels is %5.1f minutes \n',points(end,6)/60)
disp('There is a trip to the cal panels at the beginning and end of the flight')
disp('How many additional trips to the cal panels are required? ')
cal_trips=input('==>  \n');
time_interval=(points(end-1,6)-points(2,6))/(cal_trips+1);
time_start = points(2,6);
time_stop = time_start+time_interval;
insert_points=zeros(1,cal_trips);
index2 = 1;
if cal_trips==0
    disp('Your route is calculated')
else        % find indices to insert cal panel
    for index = 2:(size(points,1)-2)
        if points(index,6)>=time_stop
            insert_points (index2)=index;
            index2=index2+1;
            time_stop = points(index,6)+time_interval;
        end
    end
end
points=points(:,1:3);  % (may need legs)
insert_points=fliplr(insert_points);

for index=insert_points % adds trips to cal panels starting with the last trip first.
    points = [points(1:index,:);cal_lat,cal_long,0;points(index+1:end,:)];
end
distance = zeros(size(points,1),1);
time=distance;
elapsed_time=time;
points=[points,distance,time,elapsed_time];
for index=1:(size(points,1)-1)
    points(index,4) = greatCircleEarth(points(index,1),points(index,2),points(index+1,1),points(index+1,2)); %distance
    points(index,5) = points(index,4)/speed; % time
    if index~=1
        points(index,6) = points(index-1,6)+points(index-1,5);% elapsed_time
    end
end
points(end,6) = points(end-1,6) + points(end-1,5);
figure(2), plot(points(:,2),points(:,1),'.-'), hold on
plot(points(1,2),points(1,1),'bs') % home location
plot(points(2,2),points(2,1),'ro') % cal target
plot(points(3,2),points(3,1),'m*') % first point
xlabel('longitude'), ylabel('latitude')
legend('Flight Path','Home', 'Cal panel','First Point')
fprintf('The total flight time with specified cal panel observations is %5.1f minutes \n',points(end,6)/60)
%% make xml file
format long
docNode1 = UgCS_header();
aircraftType=2; % 1 = ArDrone, 2 = DjiPhantom3, 3 = DjiPhantom4, 3 = S-900/1000
home_lat = TO_lat;
home_long = TO_long;
routeName = 'Geneva_MATLAB';

initialData{1,1} = 'Route Name'; initialData{1,2} = routeName;
initialData{2,1} = 'Home - Set Explicitly'; initialData{2,2}= 'EXPLICIT';
initialData{3,1} = 'Home Lat'; initialData{3,2}= home_lat;      %[DD] North is positive
initialData{4,1} = 'Home Long'; initialData{4,2}= home_long;    %[DD] East is positive
initialData{5,1} = 'Home Altitude'; initialData{5,2}= 0;      % [m AMSL or m AGL]
initialData{6,1} = 'Avoid aerodromes'; initialData{6,2} = 'true';
initialData{7,1} = 'Avoid Custom Zones'; initialData{7,2} = 'false';
initialData{8,1} = 'Maximum Altitude'; initialData{8,2} = 200;   % [m AMSL or m AGL]
initialData{9,1} = 'Emergency return Altitude'; initialData{9,2}= 2;
initialData{10,1} = 'Vehicle Profile'; initialData{10,2}= 3; % 1 = ArDrone, 2 = DjiPhantom3, 3 = DjiPhantom4, 3 = S-900/1000, 5 = matrice ;
initialData{11,1} = 'Altitude mode'; initialData{11,2} = 1; %1= AGL, 2 =AMSL
initialData{12,1} = 'Trajectory Type'; initialData{12,2}= 151+50;

docNode1 = UgCS_initialData(docNode1,initialData);
order=(1:size(points,1))'-1;
obstacles=ones(size(points,1),1);
terrain = obstacles;
WP_data=cell(8,2);
for index=1:size(points,1)
    WP_data{1,1} = 'order';
    WP_data{1,2} = order(index);
    WP_data{2,1} = 'latitude';
    WP_data{2,2} = points(index,1);
    WP_data{3,1} = 'longitude';
    WP_data{3,2} = points(index,2);
    WP_data{4,1} = 'altitude';
    WP_data{4,2} = altitude;
    WP_data{5,1} = 'speed, m/s';
    WP_data{5,2} = speed;
    WP_data{6,1} = 'Avoid Obstacles?';
    WP_data{6,2} = 'True';
    WP_data{7,1} = 'Avoid Terrain?';
    WP_data{7,2} = 'True';
    WP_data{8,1} = 'Turn type';
    WP_data{8,2} = 1;           % use 1 for STOP_AND_TURN or 2 for SPLINE
    WP_data{9,1} = 'Altitude Type';
    WP_data{9,2}=1;
    docNode1 = UgCS_segment_WP(docNode1,WP_data);
end
fileName=strcat(routeName,'.xml');
xmlwrite(fileName,docNode1);
type(fileName);
