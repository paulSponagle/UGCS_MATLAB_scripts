function Z = UgCS_Action_Yaw(docNode1,data,seg_order)
% This function appends a wait command to any applicable segment. After a
% waypoint is complete the UAV will wait before it moves.
% inputs:
%       - docNode
%       - data
% data consists of a 2 x 2 as follows:
%    'order'       []           (order of action)
%    'interval'    []           (in seconds)
order = data{1,2};
heading = data{2,2}*pi/180;

segments_node = docNode1.getElementsByTagName('segments').item(seg_order);
action_node = docNode1.createElement('actionDefinitions');
segments_node.appendChild(action_node);

    order_node = docNode1.createElement('order');
    order_node.setAttribute('v',num2str(order)); 
    action_node.appendChild(order_node);   

    definition_node = docNode1.createElement('headingDefinition');
    action_node.appendChild(definition_node);  
    
        heading_node = docNode1.createElement('heading');
        heading_node.setAttribute('v',num2str(heading)); 
        definition_node.appendChild(heading_node);       

    
Z=docNode1;
end