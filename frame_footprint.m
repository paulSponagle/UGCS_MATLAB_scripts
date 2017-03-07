function Z=frame_footprint(WP, bearing,camera_foot_l, camera_foot_w)
% This function provides the coordinates for the footprint of an image. The
% function assumes that the earth is a perfect sphere of infinite radius.
% inputs:
%       WP - location of imaging events
%       bearing - degrees from true north (can be 180 degrees off)
%       altitude - in metres
%       camera_foot_l - image footprint cross track
%       camera_foot_w- image footprint along track
% output
%       Z - four points in lat/long coordinates in decimal degrees (4x2 matrix).

% step 1 find two points of edge of frame along flight path.
[A_lat, A_long] = newPosition (WP(:,1), WP(:,2), bearing, camera_foot_w/2);
[B_lat, B_long] = newPosition (WP(:,1), WP(:,2), bearing-180, camera_foot_w/2);

% step 2 find two points orthoginal of each point at half the cross-track
% footprint
[P1_lat,P1_long] =  newPosition (A_lat, A_long, bearing-90, camera_foot_l/2);
[P2_lat,P2_long] =  newPosition (A_lat, A_long, bearing+90, camera_foot_l/2);
[P3_lat,P3_long] =  newPosition (B_lat, B_long, bearing+90, camera_foot_l/2);
[P4_lat,P4_long] =  newPosition (B_lat, B_long, bearing-90, camera_foot_l/2);
Z = [P1_lat,P1_long,P2_lat,P2_long,P3_lat,P3_long, P4_lat,P4_long];
end