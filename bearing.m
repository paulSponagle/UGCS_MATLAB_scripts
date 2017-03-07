function Z = bearing(lat1,long1,lat2,long2)
% all inputs are in DD
% output is bearing from point 1 to point 2 in degrees
Z=atan2d(sind(long2-long1)*cosd(lat2),cosd(lat1)*sind(lat2)-sind(lat1)*cosd(lat2*cosd(long2-long1)));
if Z>=360
    Z=Z-360;
end
if Z<0
    Z=Z+360;
end

end