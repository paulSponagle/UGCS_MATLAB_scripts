function Z = UgCS_Action_Wait(docNode1,data,seg_order)
% This function appends a wait command to any applicable segment. After a
% waypoint is complete the UAV will wait before it moves.
% inputs:
%       - docNode
%       - data
order = data{1,2};
interval = data{2,2};

segments_node = docNode1.getElementsByTagName('segments').item(seg_order);
action_node = docNode1.createElement('actionDefinitions');
segments_node.appendChild(action_node);

    orderNode = docNode1.createElement('order');
    orderNode.setAttribute('v',num2str(order)); 
    action_node.appendChild(orderNode);   

    wait_node = docNode1.createElement('waitDefinition');
    action_node.appendChild(wait_node);  
    
        interval_node = docNode1.createElement('interval');
        interval_node.setAttribute('v',num2str(interval)); 
        wait_node.appendChild(interval_node);       

    
Z=docNode1;
end