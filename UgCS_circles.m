function UgCS_circles(waypoint_data,initial_data,sensor_data)
% This function creates an xml file that will fly multiple concentric
% circles around a specified point for Structure from Motion flights.
% inputs:
%       - circle_data -  consists of lat, long, altitude, radius, speed,
%       laps, and a direction (clockwise?) flag for each circle
% outputs:
%       - xml file
lat = waypoint_data(:,1)*pi/180;
long = waypoint_data(:,2)*pi/180;
alt_AGL = waypoint_data(:,3);
radius=waypoint_data(:,4);
ground_speed = waypoint_data(:,5);
laps = waypoint_data (:,6);
direction = waypoint_data(:,7); % 1 is clockwise, 0 is counterclockwise
routeName='MatlabGenerated';

home_lat = 43.0771069*pi/180;
home_long= -77.6707551*pi/180;

%% header
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
        
%%initial data
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
         safeAltitude_node.setAttribute('v','3');
         route_node.appendChild(safeAltitude_node);
         
         maxAltitude_node = docNode.createElement('maxAltitude');
         maxAltitude_node.setAttribute('v','10.0');
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
         checkAerodromeNfz_node.setAttribute('v','true');
         route_node.appendChild(checkAerodromeNfz_node);
         
         CheckCustomNfz_node = docNode.createElement('checkCustomNfz');
         CheckCustomNfz_node.setAttribute('v','false');
         route_node.appendChild(CheckCustomNfz_node);
         
         vehicleProfile_node = docNode.createElement('vehicleProfile');
         route_node.appendChild(vehicleProfile_node);
         
            platform_node = docNode.createElement('platform');
            vehicleProfile_node.appendChild(platform_node);
            
                code_node = docNode.createElement('code');
                code_node.setAttribute('v','ArDrone');
                platform_node.appendChild(code_node);   
%% segments
for ii=1: length(alt_AGL)
         segments_node = docNode.createElement('segments');
         route_node.appendChild(segments_node);
         
            uuid_node = docNode.createElement('modificationUuid');
            uuid_node.setAttribute('v',uuid());
            segments_node.appendChild(uuid_node); 
            
            order_node = docNode.createElement('order');
            order_node.setAttribute('v',num2str(ii-1)); 
            segments_node.appendChild(order_node);   
            
            algorithmClassName_node = docNode.createElement('algorithmClassName');
            algorithmClassName_node.setAttribute('v','com.ugcs.ucs.service.routing.impl.CircleAlgorithm');
            segments_node.appendChild(algorithmClassName_node);  
                       
            figure_node = docNode.createElement('figure');
            segments_node.appendChild(figure_node);
            
                type_node = docNode.createElement('type');
                type_node.setAttribute('v','CIRCLE');
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
                    o_node.setAttribute('v3',num2str(lat(ii),16));  
                    o_node.setAttribute('v4',num2str(long(ii),16));  
                    o_node.setAttribute('v6',num2str(alt_AGL(ii)));  
                    o_node.setAttribute('v7','AGL');  
                    ugcsList_node.appendChild(o_node);
                    
                ugcsList_node = docNode.createElement('ugcs-List');
                ugcsList_node.setAttribute('name','parameters');
                ugcsList_node.setAttribute('type','FigureParameter');
                ugcsList_node.setAttribute('v0','id');
                ugcsList_node.setAttribute('v1','version');
                ugcsList_node.setAttribute('v2','order');
                ugcsList_node.setAttribute('v3','value');            
                figure_node.appendChild(ugcsList_node);  
                
                    o_node = docNode.createElement('o');
                    o_node.setAttribute('v2',num2str(0));  
                    o_node.setAttribute('v3',num2str(radius(ii)));
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
                o_node.setAttribute('v3','STOP_AND_TURN'); 
                ugcsList_node.appendChild(o_node); 
                
                o_node = docNode.createElement('o');
                o_node.setAttribute('v2','loops'); 
                o_node.setAttribute('v3','1');
                ugcsList_node.appendChild(o_node); 

                o_node = docNode.createElement('o');
                o_node.setAttribute('v2','flightClockwise'); 
                if direction(ii)
                    orbit='True';
                else
                    orbit=false;
                end
                o_node.setAttribute('v3',orbit);
                ugcsList_node.appendChild(o_node); 
                
                o_node = docNode.createElement('o');
                o_node.setAttribute('v2','basePointsQnt');
                o_node.setAttribute('v3','60'); %feel free, but too many may cause issues with upload to UAV
                ugcsList_node.appendChild(o_node);                 
                
                o_node = docNode.createElement('o');
                o_node.setAttribute('v2','followTerrain');
                o_node.setAttribute('v3','True');
                ugcsList_node.appendChild(o_node); 
                
                o_node = docNode.createElement('o');
                o_node.setAttribute('v2','actionExecution');
                o_node.setAttribute('v3','ACTIONS_EVERY_POINT');
                ugcsList_node.appendChild(o_node); 
                
                o_node = docNode.createElement('o');
                o_node.setAttribute('v2','avoidObstacles');
                o_node.setAttribute('v3','True');
                ugcsList_node.appendChild(o_node); 
                
                o_node = docNode.createElement('o');
                o_node.setAttribute('v2','avoidTerrain');
                o_node.setAttribute('v3','True');
                ugcsList_node.appendChild(o_node);                

                o_node = docNode.createElement('o');
                o_node.setAttribute('v2','noActionsAtLastPoint');
                o_node.setAttribute('v3','True');
                ugcsList_node.appendChild(o_node);                 
end
%          segments_node = docNode.createElement('segments');
%          route_node.appendChild(segments_node);
%          
%             uuid_node = docNode.createElement('modificationUuid');
%             uuid_node.setAttribute('v',uuid());
%             segments_node.appendChild(uuid_node); 
%             
%             order_node = docNode.createElement('order');
%             order_node.setAttribute('v',num2str(ii)); 
%             segments_node.appendChild(order_node);   
%             
%             algorithmClassName_node = docNode.createElement('algorithmClassName');
%             algorithmClassName_node.setAttribute('v','com.ugcs.ucs.service.routing.impl.WaypointAlgorithm');
%             segments_node.appendChild(algorithmClassName_node);   
%             
%             figure_node = docNode.createElement('figure');
%             segments_node.appendChild(figure_node);
%             
%                 type_node = docNode.createElement('type');
%                 type_node.setAttribute('v','POINT');
%                 figure_node.appendChild(type_node); 
%                 
%                 ugcsList_node = docNode.createElement('ugcs-List');
%                 ugcsList_node.setAttribute('name','points');
%                 ugcsList_node.setAttribute('type','FigurePoint');
%                 ugcsList_node.setAttribute('v0','id');
%                 ugcsList_node.setAttribute('v1','version');
%                 ugcsList_node.setAttribute('v2','order');
%                 ugcsList_node.setAttribute('v3','latitude');
%                 ugcsList_node.setAttribute('v4','longitude');
%                 ugcsList_node.setAttribute('v5','wgs84Altitude');
%                 ugcsList_node.setAttribute('v6','aglAltitude');
%                 ugcsList_node.setAttribute('v7','altitudeType');
%                 figure_node.appendChild(ugcsList_node); 
%                 
%                     o_node = docNode.createElement('o');
%                     o_node.setAttribute('v2','0');  
%                     o_node.setAttribute('v3',num2str(home_lat,16));  
%                     o_node.setAttribute('v4',num2str(home_long,16));  
%                     o_node.setAttribute('v6',num2str('2'));  
%                     o_node.setAttribute('v7','AGL');  
%                     ugcsList_node.appendChild(o_node);
%                     
%             ugcsList_node = docNode.createElement('ugcs-List');
%             ugcsList_node.setAttribute('name','parameterValues');
%             ugcsList_node.setAttribute('type','ParameterValue');
%             ugcsList_node.setAttribute('v0','id');
%             ugcsList_node.setAttribute('v1','version');
%             ugcsList_node.setAttribute('v2','name');
%             ugcsList_node.setAttribute('v3','value');            
%             segments_node.appendChild(ugcsList_node);   
%             
%                 o_node = docNode.createElement('o');
%                 o_node.setAttribute('v2','speed');  
%                 o_node.setAttribute('v3','0.5');
%                 ugcsList_node.appendChild(o_node); 
%                 o_node = docNode.createElement('o');                
%                 o_node.setAttribute('v2','wpTurnType');                
%                 o_node.setAttribute('v3','STOP_AND_TURN'); 
%                 ugcsList_node.appendChild(o_node); 
%                 o_node = docNode.createElement('o');
%                 o_node.setAttribute('v2','avoidObstacles');
%                 o_node.setAttribute('v3','True');
%                 ugcsList_node.appendChild(o_node); 
%                 o_node = docNode.createElement('o');
%                 o_node.setAttribute('v2','avoidTerrain');
%                 o_node.setAttribute('v3','True');
%                 ugcsList_node.appendChild(o_node);
%             
%           action_node = docNode.createElement('actionDefinitions');
%           segments_node.appendChild(action_node);
%               
%             order_node = docNode.createElement('order');
%             order_node.setAttribute('v','0');
%             action_node.appendChild(order_node);
%             
%             wait_node = docNode.createElement('waitDefinition');
%             action_node.appendChild(wait_node);
%             
%                 interval_node = docNode.createElement('interval');
%                 interval_node.setAttribute('v','60'); % This is a safety feature to wait at home for 30 s
%                 wait_node.appendChild(interval_node);

fileName = 'MatlabCircles';
xmlFileName = [fileName,'.xml'];
xmlwrite(xmlFileName,docNode);
type(xmlFileName);                
end