function Z = distance_to_next_point (points,TO_lat, TO_long)
% This function returns the distance to the next point point starting at the TO
% location and ending back at the same location.
% inputs:
%       - points - lat/long in DD of several points
%       - TO_lat, TO_long - lat/long in DD of point of takeoff (assumes
%       same point of landing
% outputs:
%       -Z - vector containing distance to next point in metres
Z= zeros(size(points,1)+1,1);
Z(1) = greatCircleEarth(TO_lat,TO_long, points(1,1), points(1,2));
for ii=2:size(points,1)
    Z(ii) = greatCircleEarth(points(ii-1,1), points(ii-1,2),points(ii,1), points(ii,2));
end
Z(size(points,1)+1) = greatCircleEarth(points(size(points,1),1), points(size(points,1),2),TO_lat,TO_long);
end 