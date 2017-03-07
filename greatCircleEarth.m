function [arclength]=greatCircleEarth(lat1,long1,lat2,long2)
% This function calculates the arclength along a great circle assuming that
% the Earth is a perfect sphere.
%inputs - lat and long for two points in decimal degrees (i.e. 44.54 deg)
%       - lat and long can be vectors
radius_earth = 6378140; % metres
arclength = acos(sind(lat1).*sind(lat2)+cosd(lat1).*cosd(lat2).*cosd(long1-long2));
arclength = arclength*radius_earth;
end