function Z = UgCS_segment_takeoff(docNode1,data)

    order = data{1,2};
    latitude = data{2,2}*pi/180;    % DD is converted to radians
    longitude = data{3,2}*pi/180;   % DD is converted to radians
    altitude = data{4,2};   % m
    speed = data{5,2};      % m/s
    obstacles = data{6,2};  % True or False
    if obstacles==0
        obstacles='False';
    else
        obstacles='True';
    end
    terrain = data{7,2};    % True or False
        if terrain==0
        terrain='False';
    else
        terrain='True';
    end

         route_node=docNode1.getElementsByTagName('Route').item(0);
         segments_node = docNode1.createElement('segments');
         %node = route_node.getFirstChild;
         route_node.appendChild(segments_node);
         
            uuid_node = docNode1.createElement('modificationUuid');
            uuid_node.setAttribute('v',uuid());
            segments_node.appendChild(uuid_node); 
            
            order_node = docNode1.createElement('order');
            order_node.setAttribute('v',num2str(order)); 
            segments_node.appendChild(order_node);   
            
            algorithmClassName_node = docNode1.createElement('algorithmClassName');
            algorithmClassName_node.setAttribute('v','com.ugcs.ucs.service.routing.impl.TakeOffAlgorithm');
            segments_node.appendChild(algorithmClassName_node);   
            
            figure_node = docNode1.createElement('figure');
            segments_node.appendChild(figure_node);
            
                type_node = docNode1.createElement('type');
                type_node.setAttribute('v','TAKEOFF_POINT');
                figure_node.appendChild(type_node); 
                
                ugcsList_node = docNode1.createElement('ugcs-List');
                ugcsList_node.setAttribute('name','points');
                ugcsList_node.setAttribute('type','FigurePoint');
                ugcsList_node.setAttribute('v0','id');
                ugcsList_node.setAttribute('v1','version');
                ugcsList_node.setAttribute('v2','order');
                ugcsList_node.setAttribute('v3','latitude');
                ugcsList_node.setAttribute('v4','longitude');
                ugcsList_node.setAttribute('v5','wgs84Altitude');
                ugcsList_node.setAttribute('v6','aglAltitude');
                ugcsList_node.setAttribute('v7','altitudeType');
                figure_node.appendChild(ugcsList_node); 
                
                    o_node = docNode1.createElement('o');
                    o_node.setAttribute('v2','0');  
                    o_node.setAttribute('v3',num2str(latitude,16));  
                    o_node.setAttribute('v4',num2str(longitude,16));  
                    o_node.setAttribute('v6',num2str(altitude));  
                    o_node.setAttribute('v7','AGL');  
                    ugcsList_node.appendChild(o_node);
                    
            ugcsList_node = docNode1.createElement('ugcs-List');
            ugcsList_node.setAttribute('name','parameterValues');
            ugcsList_node.setAttribute('type','ParameterValue');
            ugcsList_node.setAttribute('v0','id');
            ugcsList_node.setAttribute('v1','version');
            ugcsList_node.setAttribute('v2','name');
            ugcsList_node.setAttribute('v3','value');            
            segments_node.appendChild(ugcsList_node);   
            
                o_node = docNode1.createElement('o');
                o_node.setAttribute('v2','speed');  
                o_node.setAttribute('v3',num2str(speed));
                ugcsList_node.appendChild(o_node);                
                o_node = docNode1.createElement('o');
                o_node.setAttribute('v2','avoidObstacles');
                o_node.setAttribute('v3', obstacles);
                ugcsList_node.appendChild(o_node); 
                o_node = docNode1.createElement('o');
                o_node.setAttribute('v2','avoidTerrain');
                o_node.setAttribute('v3', terrain);
                ugcsList_node.appendChild(o_node);

Z=docNode1;
end