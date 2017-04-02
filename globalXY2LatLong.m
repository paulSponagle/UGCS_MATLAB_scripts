function [Lat, Long]=globalXY2LatLong(OriginLat,OriginLong,x,y)
% This function converts x and y coordinates to Lat and long space where
% y-axis points North. This intended for a local areas.
% inputs:
%       OriginLat - Latitude of Origin [DD]
%       OriginLong - Longitude of Origin [DD]
%       x - x-coordinate [metres]
%       y - y-coordinates [metres]
% Outputs:
%       Lat - [DD]
%       Long - [DD]
format long
distance2origin = (x.^2 + y.^2).^.5;
bearing = 90-atan2d(y,x); 
bearing(bearing<0)=bearing(bearing<0)+360;
bearing(bearing>=360)=bearing(bearing>=360)-360;
[Lat,Long] = newPosition (OriginLat, OriginLong, bearing, distance2origin);



end