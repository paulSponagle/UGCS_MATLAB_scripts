function Z = UgCS_segment_photogrammetry(docNode1,data, polygon)
% CAUTION: 
% ****** Before using this Algorithm, verify camera type is correct.***

% This function adds a Photogrammetry segment onto an existing UgCS xml
% flight plan.
% inputs:
%       - docNode1
%       - data - cell containing order, speed, 
%       - polygon - matrix containing order, lat, long, altitude, camera, GSD,
%                    overlapForward,overlapSide
%
order= data{1,2};
speed=data{2,2};
turn=data{3,2};
if turn==1
    turn='STOP_AND_TURN';
else
    turn='STRAIGHT';
end
camera=data{4,2};
GSD = data{5,2};
overlapForward=data{6,2};
overlapSide=data{7,2};
camForward=data{8,2};
if camForward==1||camForward=='True'
    camForward='True';
else
    camForward='False';
end
direction = data{9,2};
obstacles= data{10,2};
if obstacles==1||True
    obstacles='True';
else
    obstacles='False';
end
action=data{11,2};
if action==2;
    action='ONLY_AT_START';
elseif action==3
    action='ACTIONS_ON_FORWARD_PASSES';
else
    action='ACTIONS_EVERY_POINT';
end
additionalWP=data{12,2};
if additionalWP ~=1
    additionalWP='False';
else
    additionalWP='True';
end
overshoot = data{13,2};
altType=data{14,2};
if altType==1
    altType='WGS84';
else
    altType='AGL';
end
partialCalc=data{15,2};
if partialCalc==1
    partialCalc='True';
else
    partialCalc='False';
end
actionsAtLast=data{16,2};
if actionsAtLast==1
    actionsAtLast='True';
else
    actionsAtLast='False';
end

lat= polygon(:,1)*pi/180;
long = polygon(:,2)*pi/180;
alt = polygon(:,3);

route_node = docNode1.getElementsByTagName('Route').item(0);

    segments_node = docNode1.createElement('segments');
    route_node.appendChild(segments_node);

            uuid_node = docNode1.createElement('modificationUuid');
            uuid_node.setAttribute('v',uuid());
            segments_node.appendChild(uuid_node);
            
            order_node = docNode1.createElement('order');
            order_node.setAttribute('v',num2str(order)); 
            segments_node.appendChild(order_node); 
            
            algorithmClassName_node = docNode1.createElement('algorithmClassName');
            algorithmClassName_node.setAttribute('v','com.ugcs.ucs.service.routing.impl.PhotogrammetryAlgorithm');
            segments_node.appendChild(algorithmClassName_node);   

            figure_node = docNode1.createElement('figure');
            segments_node.appendChild(figure_node);
            
                type_node = docNode1.createElement('type');
                type_node.setAttribute('v','POLYGON');
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
                
                for ii=1:size(polygon,1);
                    o_node = docNode1.createElement('o');
                    o_node.setAttribute('v2',num2str(ii-1));  
                    o_node.setAttribute('v3',num2str(lat(ii),16));  
                    o_node.setAttribute('v4',num2str(long(ii),16));  
                    o_node.setAttribute('v6',num2str(alt(ii)));  
                    o_node.setAttribute('v7','AGL');  
                    ugcsList_node.appendChild(o_node);
                end
                    o_node = docNode1.createElement('o');
                    o_node.setAttribute('v2',num2str(ii+1));  
                    o_node.setAttribute('v3',num2str(lat(1),16));  
                    o_node.setAttribute('v4',num2str(long(1),16));  
                    o_node.setAttribute('v6',num2str(alt(1)));  
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
                
                o_node = docNode1.createElement('o');%
                o_node.setAttribute('v2','speed');  %
                o_node.setAttribute('v3',num2str(speed));%
                ugcsList_node.appendChild(o_node); %
                o_node = docNode1.createElement('o');%                
                o_node.setAttribute('v2','wpTurnType');%               
                o_node.setAttribute('v3',turn);% 
                ugcsList_node.appendChild(o_node); %
                o_node = docNode1.createElement('o');%                
                o_node.setAttribute('v2','camera');% put if statement for different cameras available to DIRS               
                o_node.setAttribute('v3',num2str(camera));%                 
                ugcsList_node.appendChild(o_node); %
                o_node = docNode1.createElement('o');%
                o_node.setAttribute('v2','groundSampleDistance');%
                o_node.setAttribute('v3', num2str(GSD));%
                ugcsList_node.appendChild(o_node); %
                o_node = docNode1.createElement('o');%                
                o_node.setAttribute('v2','overlapForward');%
                o_node.setAttribute('v3', num2str(overlapForward));%
                ugcsList_node.appendChild(o_node); %
                o_node = docNode1.createElement('o');%                                
                o_node.setAttribute('v2','overlapSide');%
                o_node.setAttribute('v3', num2str(overlapSide));%
                ugcsList_node.appendChild(o_node); %
                o_node = docNode1.createElement('o');%                                
                o_node.setAttribute('v2','camTopFacingForward');%
                o_node.setAttribute('v3', camForward);%
                ugcsList_node.appendChild(o_node); %
                o_node = docNode1.createElement('o');
                o_node.setAttribute('v2','directionAngle');
                o_node.setAttribute('v3', num2str(direction)); 
                ugcsList_node.appendChild(o_node); 
                o_node = docNode1.createElement('o');
                o_node.setAttribute('v2','avoidObstacles');
                o_node.setAttribute('v3', obstacles); 
                ugcsList_node.appendChild(o_node);
                o_node = docNode1.createElement('o');%                                
                o_node.setAttribute('v2','actionExecution');%
                o_node.setAttribute('v3', action);%
                ugcsList_node.appendChild(o_node); %                  
                o_node = docNode1.createElement('o');
                o_node.setAttribute('v2','generateAdditionalWaypoints');
                o_node.setAttribute('v3', additionalWP);
                ugcsList_node.appendChild(o_node); 
                o_node = docNode1.createElement('o');
                o_node.setAttribute('v2','overshoot');
                o_node.setAttribute('v3', num2str(overshoot));
                ugcsList_node.appendChild(o_node);  
                o_node = docNode1.createElement('o');
                o_node.setAttribute('v2','altitudeType');
                o_node.setAttribute('v3', altType);
                ugcsList_node.appendChild(o_node);
                o_node = docNode1.createElement('o');
                o_node.setAttribute('v2','areaScanAllowPartialCalculation');
                o_node.setAttribute('v3', partialCalc);
                ugcsList_node.appendChild(o_node);
                
                o_node = docNode1.createElement('o');
                o_node.setAttribute('v2','noActionsAtLastPoint');
                o_node.setAttribute('v3', actionsAtLast);
                ugcsList_node.appendChild(o_node);
Z=docNode1;
end