function [new_lat,new_long] = newPosition (old_lat, old_long, bearing, distance)
% This function will provide the new lat/long of a point given an
% initial point, initial bearing and distance. This formula applies great
% circle formula.
% inputs
%       - old_lat       - latitude in decimal degrees (can be a vector)
%       - old_long      - longitude in decimal degrees (can be a vector)
%       - bearing       - degrees true north (can be a vector)
%       - distance      - in metres(can be a vector) if km is more convenient
%       then R must be changed)
% outputs 
%       - new_lat/new_long - in decimal degrees (will be a vector or
%       scalar)
% Equations from website: http://www.movable-type.co.uk/scripts/latlong.html
R= 6378140;
new_lat = asin(sin(old_lat*pi/180).*cos(distance/R)+cos(old_lat*pi/180).*sin(distance/R).*cos(bearing*pi/180))*180/pi;
new_long = old_long + atan2(sin(bearing*pi/180).*sin(distance/R).*cos(old_lat*pi/180),cos(distance/R)-sin(old_lat*pi/180).*sin(new_lat*pi/180))*180/pi;

end