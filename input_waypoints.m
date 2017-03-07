function [lat,long]=input_waypoints(img,up,down,left,right)
figure(1), imshow(img), hold on, title('Select the AOIs and then press ''enter'' key')
img_size=size(img);
[uav_x,uav_y] = ginput;
hold on, plot([uav_x;uav_x(1)],[uav_y;uav_y(1)],'r-')
[lat,long]=xy2latLong(up, down, left, right, img_size(1), img_size(2), uav_x, uav_y);
end



