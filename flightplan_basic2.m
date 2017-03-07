% This script produces a flight plan based on a varity of inputs:
% Inputs
%       - AOI - N waypoints (lat and long in decimal degrees) click on the
%       map.
%       - FOV of sensor in degrees along track and cross track
%       - per cent overlap
%       - ground speed
% Outputs
%       - WP (lat and long in decmal degrees)
%       - leg info (distance, bearing, time)  ==> separate function
%       - camera events (centres and footprints) ==> separate function

% The general idea is to find the directionality of the polygon, fly the
% aircraft to the point on AOI polygon that has the largest orthoginal
% distance.
% Corners of the AOI must be entered in sequential
% order (clockwise or counter-clockwise).  In the future, I would like to be able to use
% the mouse to select the image if MATLAB can project a geo-referenced image onto a mercator projection.
% It is assumed that the sensor is not symetric and the short edge is
% alligned in the direction of travel.
clear all
close all
%format long

%% The following section allows you to pick lat/long coordinates from a mercator projection
% The user must update up,down, left,right variables manually.
img=imread('/Users/Paul/Documents/Courses/Project/flight planning/Geneva/Geneva_tiff.tif');
       % mercator projection created using ENVI
figure(1), imshow(img), hold on, title('Select the AOI - Click 3 or more points and press return.')
up = 42 + 52/60+ 27.26/3600;        % latitude of the top of the frame
down = 42 +52/60+22.88/3600;        % latitude of the bottom of the frame
left = -1*(77+1/60+39.59/60);       % longitude of the left side of the frame
right =-1*(77+1/60+35.52/60);       % longitude of the right side of the frame
img_size=size(img);
[uav_x,uav_y] = ginput;
hold on, plot([uav_x;uav_x(1)],[uav_y;uav_y(1)],'c-')
[lat,long]=xy2latLong(up, down, left, right, img_size(1), img_size(2), uav_x, uav_y);
%% camera settings
overlap_along_track = .6;
overlap_cross_track = .6;
altitude = 100;             % in metres
uav_groundspeed = 5;        % in m/s
camera_f = 60;              % focal length in mm
camera_l_pixels = 7360;
camera_l_array_size = 35.9; % in mm
camera_w_pixels = 4912;
camera_w_array_size = 24;   % in mm
camera_foot_l = altitude*camera_l_array_size/camera_f; % crosstrack in metres
camera_foot_w = altitude*camera_w_array_size/camera_f; % alongtrack in metres
%buffer = 40; % buffer permits aircraft time to establish itself before reaching AOI.

AOI = [lat,long];%csvread('bounding_box_dd.csv',1, 0); % entered in either clockwise or ccw order
AOI_points = size(AOI,1);
AOI_max_lat = max(AOI(:,1));
AOI_min_lat = min(AOI(:,1));
AOI_max_long = max(AOI(:,2));
AOI_min_long = min(AOI(:,2));
AOI_mid_lat = (AOI_max_lat + AOI_min_lat)*.5; %next 2 lines find centre of scene
AOI_mid_long = (AOI_max_long+AOI_min_long)*.5;
AOI_delta_lat = AOI_max_lat-AOI_min_lat;
AOI_delta_long = AOI_max_long-AOI_min_long;

TO_lat = AOI_mid_lat+0.001; % arbitrary
TO_long = AOI_mid_long+0.001;
[TO_x,TO_y]=latLong2xy(up, down, left, right, img_size(1), img_size(2), TO_lat, TO_long);
% find closest AOI polygon corner to takeoff point
distance_home=zeros(AOI_points,1);
for ii=1:AOI_points
    distance_home(ii) = greatCircleEarth(TO_lat,TO_long,AOI(ii,1),AOI(ii,2));  % consider using repmat instead of loop
end

WP_1 = find(distance_home == min(distance_home)); % this point will be th first waypoint.
WP_1=WP_1(1); % precaution in case equidistant
% find the longer side of the AOI polygon adjacent to the first point.
if WP_1 ~= AOI_points && WP_1 ~= 1      %first condition is asking if closest point is not at top or bottom of list.
    distance_prior = greatCircleEarth(AOI(WP_1,1),AOI(WP_1,2),AOI(WP_1-1,1),AOI(WP_1-1,2));
    distance_later = greatCircleEarth(AOI(WP_1,1),AOI(WP_1,2),AOI(WP_1-1,1),AOI(WP_1-1,2));
    if distance_later > distance_prior
        WP_2 = WP_1+1;
    else
        WP_2 = WP_1-1;
    end
elseif WP_1==1
    distance_prior = greatCircleEarth(AOI(WP_1,1),AOI(WP_1,2),AOI(AOI_points,1),AOI(AOI_points,2));
    distance_later = greatCircleEarth(AOI(WP_1,1),AOI(WP_1,2),AOI(2,1),AOI(2,2));
    if distance_later > distance_prior
        WP_2 = AOI_points;
    else
        WP_2 = 2;
    end
elseif WP_1==AOI_points
    distance_prior = greatCircleEarth(AOI(WP_1,1),AOI(WP_1,2),AOI(AOI_points-1,1),AOI(AOI_points-1,2));
    distance_later = greatCircleEarth(AOI(WP_1,1),AOI(WP_1,2),AOI(1,1),AOI(1,2));
    if distance_later > distance_prior
        WP_2 = AOI_points;
    else
        WP_2 = 2;
    end
end
distance_between_legs = (1-overlap_cross_track)*camera_foot_l;
distance_between_events = (1-overlap_along_track)*camera_foot_w;
% find directionality of the AOI polygon
vect = pca(fliplr(AOI));
direction_of_flight=vect(:,1);
bearing = atan2(direction_of_flight(1),direction_of_flight(2))*180/pi;
if bearing>=360
    bearing=bearing-360;
end
direction_orthog_to_flight=vect(:,2);
% aircraft flies from home to furthest orthoginal point to the above first
% principal component. note: assumes lat long have same physical distance
dist_orth_to_TO = zeros(AOI_points,1);
for ii=1:AOI_points
    AOI_x=AOI(ii,2)-TO_long;    
    AOI_y=AOI(ii,1)-TO_lat;
    vect_to_AOI = [AOI_x,AOI_y];
    dist_orth_to_TO(1) = dot(vect_to_AOI,direction_orthog_to_flight)*distance_home(ii);
end
new_WP1 = find(dist_orth_to_TO==max(dist_orth_to_TO));
new_WP1 = new_WP1(1);
% find the extreme lat and longs (min/max), go to NW corner and fly
% cross-track trajectory (rhumb line)to, marking camera points at distance between legs
% until outside of AOI polygon. Find mid-point. Calculate greatcircle
% trajectories orthoginal to this trajectory.
% What is the NS distance between northern most point and southern most point?
% What is distance along the mean parallel of the scene?
% Alternate method: Find mid-lat & mid-long of scene. Use DOF+90 degree to find next
% point along great circle until off scene (include one point off scene, return to midpoint and revers
% course. Find orthoginal great circle and plot points in same manner.

% For now, grid whole scene then cut out items outside of AOI
ii=1;
new_lat = AOI_mid_lat;
new_long = AOI_mid_long;
while new_lat < AOI_max_lat+0.25*AOI_delta_lat && new_lat > AOI_min_lat-0.25*AOI_delta_lat && new_long < AOI_max_long + 0.25*AOI_delta_long && new_long > AOI_min_long-0.25*AOI_delta_long
[new_lat,new_long] = newPosition (AOI_mid_lat, AOI_mid_long, bearing + 90, ii*distance_between_legs);
orthoginal_points_1(ii,:) = [new_lat,new_long];
ii=ii+1;
end
ii=1;
new_lat = AOI_mid_lat;
new_long = AOI_mid_long;
while new_lat < AOI_max_lat+0.25*AOI_delta_lat && new_lat > AOI_min_lat-0.25*AOI_delta_lat && new_long < AOI_max_long + 0.25*AOI_delta_long && new_long > AOI_min_long-0.25*AOI_delta_long
[new_lat,new_long] = newPosition (AOI_mid_lat, AOI_mid_long, bearing + 270, (ii-1)*distance_between_legs);
orthoginal_points_2(ii,:) = [new_lat,new_long];
ii=ii+1;
end
orthoginal_points=[flipud(orthoginal_points_1);orthoginal_points_2];
legs_total=length(orthoginal_points);
max_lat=max([AOI(:,1);orthoginal_points(:,1)]);
min_lat = min([AOI(:,1);orthoginal_points(:,1)]);
max_long=max([AOI(:,2);orthoginal_points(:,2)]);
min_long = min([AOI(:,2);orthoginal_points(:,2)]);
for leg=1:legs_total
    new_lat= orthoginal_points(leg,1);
    new_long = orthoginal_points(leg,2);
    ii=1;
    while new_lat <= max_lat && new_lat >= min_lat && new_long <= max_long && new_long >= min_long
        [new_lat,new_long] = newPosition (orthoginal_points(leg,1), orthoginal_points(leg,2), bearing, ii*distance_between_events);
        points_1(ii,:) = [new_lat,new_long];
        ii=ii+1;
    end
    new_lat= orthoginal_points(leg,1);
    new_long = orthoginal_points(leg,2);
    ii=1;
    while new_lat <= max_lat && new_lat >= min_lat && new_long <= max_long && new_long >= min_long
        [new_lat,new_long] = newPosition (orthoginal_points(leg,1), orthoginal_points(leg,2), bearing-180, (ii-1)*distance_between_events);
        points_2(ii,:) = [new_lat,new_long];
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
    points = [ points; new_points];
    end
end
%% reduce points
%use function 'inpoly': in=inpoly(xq,yq,xv,yv) to get rid of points outside
%of the AOI
points_lat=points(:,1);
points_long = points(:,2);
in = inpolygon(points_long,points_lat,AOI(:,2),AOI(:,1));
% figure, plot (points_long(in),points_lat(in),'r+')
% hold on, plot (points_long(~in),points_lat(~in),'bx')

%% find waypoint1 
% find the first and last camera event. This corresponds to the first and
% last point. Waypoint 1 is the closer of the two to the launch point.
X = points_long(in);
Y = points_lat(in);
dist_ends = greatCircleEarth(TO_lat,TO_long,[Y(1),Y(end)],[X(1),X(end)]);
if dist_ends(1)<=dist_ends(2)
    WP = [Y,X];% WP one is the first location in the points_long, points_lat
else
    X=flipud(X);
    Y=flipud(Y);
    WP = [Y,X];% WP one is the last location in the points_long, points_lat
end
camera_events = [Y,X];
%% plots
% figure, hold on,plot([TO_long,TO_long+vect(1,1)*.3/max(distance_home)],[TO_lat,TO_lat+vect(2,1)*.3/max(distance_home)],'r-')
% plot([TO_long, AOI(new_WP1,2) ],[TO_lat,AOI(new_WP1,1)],'g-')
% plot (TO_long,TO_lat,'rs')
% hold on, plot(AOI(:,2),AOI(:,1),'b-'), plot([AOI(AOI_points,2),AOI(1,2)],[AOI(AOI_points,1),AOI(1,1)],'b-'),plot([TO_long,AOI(WP_1,2), AOI(WP_2,2)],[TO_lat, AOI(WP_1,1),AOI(WP_2,1) ] , 'm--')
% plot(orthoginal_points(:,2),orthoginal_points(:,1),'k*')
% plot(points(:,2),points(:,1), 'k.')
% plot(AOI_mid_long,AOI_mid_lat,'ms')
% title ('Flight plan - mercator projection')

[uav_x,uav_y] = latLong2xy(up, down, left, right, img_size(1), img_size(2), Y, X);
figure(1),plot(uav_x,uav_y,'rs-'), plot([TO_x,uav_x(1)],[TO_y,uav_y(1)],'m*-')
plot([TO_x,TO_x+vect(2,1)*.3*img_size(2)],[TO_y,TO_y+vect(1,1)*.3*img_size(2)],'b-')
title('flight plan')
legend('AOI','camera events', 'Takeoff point to WP 1','principal component','Location','southeast')
 
fp_corners = frame_footprint(WP, bearing,camera_foot_l, camera_foot_w);
fp_corners_xy = 0*fp_corners;
[fp_corners_xy(:,1),fp_corners_xy(:,2)] = latLong2xy(up, down, left, right, img_size(1), img_size(2), fp_corners(:,1), fp_corners(:,2));
[fp_corners_xy(:,3),fp_corners_xy(:,4)] = latLong2xy(up, down, left, right, img_size(1), img_size(2), fp_corners(:,3), fp_corners(:,4));
[fp_corners_xy(:,5),fp_corners_xy(:,6)] = latLong2xy(up, down, left, right, img_size(1), img_size(2), fp_corners(:,5), fp_corners(:,6));
[fp_corners_xy(:,7),fp_corners_xy(:,8)] = latLong2xy(up, down, left, right, img_size(1), img_size(2), fp_corners(:,7), fp_corners(:,8));
% 
% for ii=1:size(fp_corners_xy,1)
%     frame_x = fp_corners_xy(ii,1:2:7);
%     frame_y = fp_corners_xy(ii,2:2:8);
%     H = fill(frame_x,frame_y,'y');
%     set(H,'facealpha',.1)
%     set(H,'edgealpha',.9)
% end
plot(uav_x,uav_y,'rs-'), plot([TO_x,uav_x(1)],[TO_y,uav_y(1)],'m*-')
plot([TO_x,TO_x+vect(2,2)*.3*img_size(2)],[TO_y,TO_y+vect(1,2)*.3*img_size(2)],'b-')

dist_to_next_event = distance_to_next_point (camera_events,TO_lat, TO_long);
dist_to_next_event=[dist_to_next_event;0];
total_distance = sum(dist_to_next_event);
time_to_next_event = dist_to_next_event/uav_groundspeed;
total_time = sum(time_to_next_event);
coords=[[TO_lat;Y;TO_lat],[TO_long;X;TO_long]];
event=(0:length(uav_x)+1)';
flightPlan=[event,coords,dist_to_next_event,time_to_next_event];
T=table(event,coords,dist_to_next_event,time_to_next_event);
disp(T)