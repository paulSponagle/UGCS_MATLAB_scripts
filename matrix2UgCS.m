function Z = matrix2UgCS(waypoint_data,initial_data,sensor_data)
% This function converts a matrix containing flightplan variables in each
% column into an xml flight plan for use in UgCS
% inputs:
%       - waypoint_data - matrix consisists fo severlal vectors:
%                - lat, long, height AGL, speed, turn type
%           

size_waypoint_data=size(waypoint_data);
lat = waypoint_data(:,1)*pi/180;
long = waypoint_data(:,2)*pi/180;
alt_AGL = waypoint_data(:,3);
ground_speed = waypoint_data(:,4);
turn_type = waypoint_data (:,5);
routeName='MatlabGenerated';

%% headerdata
docNode = com.mathworks.xml.XMLUtils.createDocument('ugcs-Transfer');
    ver_Node = docNode.createElement('Version');
    docNode.getDocumentElement.appendChild(ver_Node);
    
        maj_Node = docNode.createElement('major');
        maj_Node.setAttribute('v','2');
        ver_Node.appendChild(maj_Node);
        
        min_Node = docNode.createElement('minor');
        min_Node.setAttribute('v','9');
        ver_Node.appendChild(min_Node);

        component_Node = docNode.createElement('component');
        component_Node.setAttribute('v','DATABASE');
        ver_Node.appendChild(component_Node);        
        
%% initial data
route_node = docNode.createElement('Route');
docNode.getDocumentElement.appendChild(route_node);

         uuid_node = docNode.createElement('modificationUuid');
         uuid_node.setAttribute('v',uuid());
         route_node.appendChild(uuid_node);
         
         name_node = docNode.createElement('name');
         name_node.setAttribute('v',routeName);
         route_node.appendChild(name_node);
         
         creationTime_node = docNode.createElement('creationTime');
         creationTime_node.setAttribute('v','2016-07-13T15:36:17.921-04:00'); %no need to alter
         route_node.appendChild(creationTime_node);
         
         altitudeType_node = docNode.createElement('altitudeType');
         altitudeType_node.setAttribute('v','AGL');
         route_node.appendChild(altitudeType_node);
         
         trajectoryType_node = docNode.createElement('trajectoryType');
         trajectoryType_node.setAttribute('v','STRAIGHT');
         route_node.appendChild(trajectoryType_node);
         
         safeAltitude_node = docNode.createElement('safeAltitude');
         safeAltitude_node.setAttribute('v','10');
         route_node.appendChild(safeAltitude_node);
         
         maxAltitude_node = docNode.createElement('maxAltitude');
         maxAltitude_node.setAttribute('v','120.0');
         route_node.appendChild(maxAltitude_node);
         
         initialSpeed_node = docNode.createElement('initialSpeed');
         initialSpeed_node.setAttribute('v','0.0');
         route_node.appendChild(initialSpeed_node);         

         maxSpeed_node = docNode.createElement('maxSpeed');
         maxSpeed_node.setAttribute('v','0.0');
         route_node.appendChild(maxSpeed_node);
         
         homeLocationSource_node = docNode.createElement('homeLocationSource');
         homeLocationSource_node.setAttribute('v','EXPLICIT');
         route_node.appendChild(homeLocationSource_node);
         
         homeLatitude_node = docNode.createElement('homeLatitude');
         homeLatitude_node.setAttribute('v',num2str(mean(lat),10));
         route_node.appendChild(homeLatitude_node);     
         
         homeLongitude_node = docNode.createElement('homeLongitude');
         homeLongitude_node.setAttribute('v',num2str(mean(long),10));
         route_node.appendChild(homeLongitude_node);
         
         homeWgs84Altitude_node = docNode.createElement('homeWgs84Altitude');
         homeWgs84Altitude_node.setAttribute('v','0.0');
         route_node.appendChild(homeWgs84Altitude_node);
         
         homeAglAltitude_node = docNode.createElement('homeAglAltitude');
         homeAglAltitude_node.setAttribute('v','0.0');
         route_node.appendChild(homeAglAltitude_node);
              
         checkAerodromeNfz_node = docNode.createElement('checkAerodromeNfz');
         checkAerodromeNfz_node.setAttribute('v','false');
         route_node.appendChild(checkAerodromeNfz_node);
         
         CheckCustomNfz_node = docNode.createElement('checkCustomNfz');
         CheckCustomNfz_node.setAttribute('v','false');
         route_node.appendChild(CheckCustomNfz_node);
         
         vehicleProfile_node = docNode.createElement('vehicleProfile');
         route_node.appendChild(vehicleProfile_node);
         
            platform_node = docNode.createElement('platform');
            vehicleProfile_node.appendChild(platform_node);
            
                code_node = docNode.createElement('code');
                code_node.setAttribute('v','DjiPhantom4');
                platform_node.appendChild(code_node);   
%% segments
for ii=1:length(lat)
         segments_node = docNode.createElement('segments');
         route_node.appendChild(segments_node);
         
            uuid_node = docNode.createElement('modificationUuid');
            uuid_node.setAttribute('v',uuid());
            segments_node.appendChild(uuid_node); 
            
            order_node = docNode.createElement('order');
            order_node.setAttribute('v',num2str(ii-1)); 
            segments_node.appendChild(order_node);   
            
            algorithmClassName_node = docNode.createElement('algorithmClassName');
            algorithmClassName_node.setAttribute('v','com.ugcs.ucs.service.routing.impl.WaypointAlgorithm');
            segments_node.appendChild(algorithmClassName_node);   
            
            figure_node = docNode.createElement('figure');
            segments_node.appendChild(figure_node);
            
                type_node = docNode.createElement('type');
                type_node.setAttribute('v','POINT');
                figure_node.appendChild(type_node); 
                
                ugcsList_node = docNode.createElement('ugcs-List');
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
                
                    o_node = docNode.createElement('o');
                    o_node.setAttribute('v2','0');  
                    o_node.setAttribute('v3',num2str(lat(ii),10));  
                    o_node.setAttribute('v4',num2str(long(ii),10));  
                    o_node.setAttribute('v6',num2str(alt_AGL(ii)));  
                    o_node.setAttribute('v7','AGL');  
                    ugcsList_node.appendChild(o_node);
                    
            ugcsList_node = docNode.createElement('ugcs-List');
            ugcsList_node.setAttribute('name','parameterValues');
            ugcsList_node.setAttribute('type','ParameterValue');
            ugcsList_node.setAttribute('v0','id');
            ugcsList_node.setAttribute('v1','version');
            ugcsList_node.setAttribute('v2','name');
            ugcsList_node.setAttribute('v3','value');            
            segments_node.appendChild(ugcsList_node);   
            
                o_node = docNode.createElement('o');
                o_node.setAttribute('v2','speed');  
                o_node.setAttribute('v3',num2str(ground_speed(ii)));
                ugcsList_node.appendChild(o_node); 
                o_node = docNode.createElement('o');                
                o_node.setAttribute('v2','wpTurnType');  
                
                if turn_type(ii)==1
                    turn = 'STOP_AND_TURN';
                elseif turn_type(ii)==2
                    turn='SPLINE';
                elseif turn_type(ii)==3
                    turn='STRAIGHT';
                end
                o_node.setAttribute('v3',turn); 
                ugcsList_node.appendChild(o_node); 
                o_node = docNode.createElement('o');
                o_node.setAttribute('v2','avoidObstacles');
                o_node.setAttribute('v3','True');
                ugcsList_node.appendChild(o_node); 
                o_node = docNode.createElement('o');
                o_node.setAttribute('v2','avoidTerrain');
                o_node.setAttribute('v3','True');
                ugcsList_node.appendChild(o_node);
end
%% save and closeout
name = 'xmlFunctionTest';
xmlFileName = [name,'.xml'];
xmlwrite(xmlFileName,docNode);
type(xmlFileName);
Z=docNode;  % change to Z=1 if error occurs
end