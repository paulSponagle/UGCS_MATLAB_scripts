function [lat,long]=xy2latLong(up, down, left, right, rows, cols, x, y)
%This function allows a user to convert x,y coordinates of an image into
%lat & long if the coordinates of both corners of an image are known.
%inputs
%       - up, down, left, right - coords in DD Lat/Long North and East are
%       - rows, cols - size of mercator image in pixels
%       - x,y   - column and row of a pixel of the mercator projection
%       positive
%outputs
% latlong - decimal degrees of a point North & East are positive
lat = (y-1)*(down-up)/(rows-1)+up;
long = (x-1)* (right-left)/(cols-1)+left;

end