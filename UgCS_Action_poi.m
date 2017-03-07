function Z = UgCS_Action_poi(docNode1,data,seg_order)
% This function appends a wait command to any applicable segment. After a
% waypoint is complete the UAV will wait before it moves.
% inputs:
%       - docNode
%       - data
order=data{1,2};
lat=data{2,2}*pi/180;
long=data{3,2}*pi/180;
alt=data{4,2};

segments_node = docNode1.getElementsByTagName('segments').item(seg_order);
action_node = docNode1.createElement('actionDefinitions');
segments_node.appendChild(action_node);

    orderNode = docNode1.createElement('order');
    orderNode.setAttribute('v',num2str(order)); 
    action_node.appendChild(orderNode);   

    poi_node = docNode1.createElement('poiDefinition');
    action_node.appendChild(poi_node);  
    
        mode_node = docNode1.createElement('mode');
        mode_node.setAttribute('v','LOCATION'); 
        poi_node.appendChild(mode_node);  
        
        lat_node = docNode1.createElement('latitude');
        lat_node.setAttribute('v',num2str(lat,10)); 
        poi_node.appendChild(lat_node);  
        
        long_node = docNode1.createElement('longitude');
        long_node.setAttribute('v',num2str(long,10)); 
        poi_node.appendChild(long_node);    
        
        alt_node = docNode1.createElement('aglAltitude');
        alt_node.setAttribute('v',num2str(alt)); 
        poi_node.appendChild(alt_node);  
        
        type_node = docNode1.createElement('altitudeType');
        type_node.setAttribute('v','AGL'); 
        poi_node.appendChild(type_node);  
        
     
Z=docNode1;
end