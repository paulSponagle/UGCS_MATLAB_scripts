function [x,y] = latLong2xy(up, down, left, right, rows, cols, lat, long)
%This function allows a user to convert x,y coordinates of an image into
%lat & long if the coordinates of both corners of an image are known.
%inputs
%       - up, down, left, right - coords in DD Lat/Long North and East are
%       - rows, cols - size of mercator image
%       - latlong - decimal degrees of a point North & East are positive

%outputs
%       %       - x,y   - column and row of a pixel of the mercator projection
%       positive
x=(long-left)/(right-left)*(cols-1)+1;
y= (lat-up)/(down-up)*(rows-1)+1;
end