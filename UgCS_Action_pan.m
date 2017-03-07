function Z = UgCS_Action_pan(docNode1,data,seg_order)
% This function permits camera panning in video or stills
% inputs 
%       - docNode1 - Entire xml structure
%       - data - 7X2 cell containing order, angle, stepAngle, stepDelay,
%       rotationDirection,rotationSpeed, panoramaMode

order             = data{1,2};
angle             = data{2,2}*pi/180;
stepAngle         = data{3,2}*pi/180;
stepDelay         = data{4,2};
rotationDirection = data{5,2};  % 1 for'CLOCKWISE', else 'COUNTERCLOCKWISE'
if rotationDirection==1
    rotationDirection='CLOCKWISE';
else
    rotationDirection='COUNTERCLOCKWISE';
end 
rotationSpeed     = data{6,2}*pi/180;
panoramaMode      = data{7,2}; % 1 for 'VIDEO', else 'PHOTO'
if rotationDirection==1
    panoramaMode='VIDEO';
else
    panoramaMode='PHOTO';
end

segments_node = docNode1.getElementsByTagName('segments').item(seg_order);
action_node = docNode1.createElement('actionDefinitions');
segments_node.appendChild(action_node);

    orderNode = docNode1.createElement('order');
    orderNode.setAttribute('v',num2str(order)); 
    action_node.appendChild(orderNode);   

    cam_node = docNode1.createElement('panoramaDefinition');
    action_node.appendChild(cam_node);  
    
        angle_node = docNode1.createElement('angle');
        angle_node.setAttribute('v',num2str(angle)); 
        cam_node.appendChild(angle_node);  
        
        step_node = docNode1.createElement('stepAngle');
        step_node.setAttribute('v',num2str(stepAngle)); 
        cam_node.appendChild(step_node);  
        
        delay_node = docNode1.createElement('stepDelay');
        delay_node.setAttribute('v',num2str(stepDelay)); 
        cam_node.appendChild(delay_node);    
        
        rot_node = docNode1.createElement('rotationDirection');
        rot_node.setAttribute('v',rotationDirection); 
        cam_node.appendChild(rot_node);          

        speed_node = docNode1.createElement('rotationSpeed');
        speed_node.setAttribute('v',num2str(rotationSpeed)); 
        cam_node.appendChild(speed_node);   
        
        mode_node = docNode1.createElement('panoramaMode');
        mode_node.setAttribute('v',panoramaMode); 
        cam_node.appendChild(mode_node);   
        
Z= docNode1;

end