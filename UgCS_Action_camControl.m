function Z = UgCS_Action_camControl(docNode1,data,seg_order)
% This function appends a wait command to any applicable segment. After a
% waypoint is complete the UAV will wait before it moves.
% inputs:
%       - docNode
%       - data - 5x2 cell (order, tilt, roll, yaw, zoom)


order = data{1,2};
tilt = data{2,2}*pi/180;
roll = data{3,2}*pi/180;
yaw = data{4,2}*pi/180;
zoom = data{5,2};

segments_node = docNode1.getElementsByTagName('segments').item(seg_order);
action_node = docNode1.createElement('actionDefinitions');
segments_node.appendChild(action_node);

    orderNode = docNode1.createElement('order');
    orderNode.setAttribute('v',num2str(order)); 
    action_node.appendChild(orderNode);   

    cam_node = docNode1.createElement('cameraControlDefinition');
    action_node.appendChild(cam_node);  
    
        tilt_node = docNode1.createElement('tilt');
        tilt_node.setAttribute('v',num2str(tilt)); 
        cam_node.appendChild(tilt_node);
        
        roll_node = docNode1.createElement('roll');
        roll_node.setAttribute('v',num2str(roll)); 
        cam_node.appendChild(roll_node);  
        
        yaw_node = docNode1.createElement('yaw');
        yaw_node.setAttribute('v',num2str(yaw)); 
        cam_node.appendChild(yaw_node);  
        
        zoom_node = docNode1.createElement('zoomLevel');
        zoom_node.setAttribute('v',num2str(zoom)); 
        cam_node.appendChild(zoom_node);          

    
Z=docNode1;
end