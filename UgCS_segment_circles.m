function Z = UgCS_segment_circles(docNode1,data)
order=data{1,2};
lat=data{2,2}*pi/180;
long=data{3,2}*pi/180;
alt_AGL=data{4,2};
radius=data{5,2};
speed=data{6,2};
turn=data{7,2};
if turn ==2
    turn= 'STOP_AND_TURN';
else
    turn='STRAIGHT';
end
loops=data{8,2};
flightClockwise=data{9,2};
if flightClockwise ==0
    flightClockwise='False';
else
    flightClockwise='True';
end
basePoints=data{10,2};
followTerrain=data{11,2};
if followTerrain==0
    followTerrain='False';
else
    followTerrain='True';
end
action=data{12,2};
if action==0,
    action='ACTIONS_EVERY_POINT';
else
    action='ONLY_AT_START';
end
obstacles=data{13,2};
if obstacles==0
    obstacles='False';
else
    obstacles='True';
end
avoidTerrain=data{14,2};
if avoidTerrain ==0 
    avoidTerrain='False';
else
    avoidTerrain='True';
end
actionsAtLast=data{15,2};
if actionsAtLast ==0 
    actionsAtLast='False';
else
    actionsAtLast='True';
end
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
            algorithmClassName_node.setAttribute('v','com.ugcs.ucs.service.routing.impl.CircleAlgorithm');
            segments_node.appendChild(algorithmClassName_node);   

            figure_node = docNode1.createElement('figure');
            segments_node.appendChild(figure_node);
            
                type_node = docNode1.createElement('type');
                type_node.setAttribute('v','CIRCLE');
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
                    o_node.setAttribute('v3',num2str(lat,10));  
                    o_node.setAttribute('v4',num2str(long,10));  
                    o_node.setAttribute('v6',num2str(alt_AGL));  
                    o_node.setAttribute('v7','AGL');  
                    ugcsList_node.appendChild(o_node);
                
               
                ugcsList_node = docNode1.createElement('ugcs-List');
                ugcsList_node.setAttribute('name','parameters');
                ugcsList_node.setAttribute('type','FigureParameter');
                ugcsList_node.setAttribute('v0','id');
                ugcsList_node.setAttribute('v1','version');
                ugcsList_node.setAttribute('v2','order');
                ugcsList_node.setAttribute('v3','value');            
                figure_node.appendChild(ugcsList_node);  
                
                    o_node = docNode1.createElement('o');
                    o_node.setAttribute('v2','0');  
                    o_node.setAttribute('v3',num2str(radius)); 
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
                o_node.setAttribute('v2','loops');%
                o_node.setAttribute('v3', num2str(loops));%
                ugcsList_node.appendChild(o_node); %
                
                o_node = docNode1.createElement('o');
                o_node.setAttribute('v2','flightClockwise');
                o_node.setAttribute('v3', flightClockwise);
                ugcsList_node.appendChild(o_node);
                
                o_node = docNode1.createElement('o');
                o_node.setAttribute('v2','basePointsQnt');
                o_node.setAttribute('v3', num2str(basePoints)); 
                ugcsList_node.appendChild(o_node); 
                
                o_node = docNode1.createElement('o');
                o_node.setAttribute('v2','followTerrain');
                o_node.setAttribute('v3', followTerrain); 
                ugcsList_node.appendChild(o_node); 

                o_node = docNode1.createElement('o');
                o_node.setAttribute('v2','actionExecution');
                o_node.setAttribute('v3', action); 
                ugcsList_node.appendChild(o_node);
                
                o_node = docNode1.createElement('o');%                                
                o_node.setAttribute('v2','avoidObstacles');%
                o_node.setAttribute('v3', obstacles);%
                ugcsList_node.appendChild(o_node); %  
                
                o_node = docNode1.createElement('o');
                o_node.setAttribute('v2','avoidTerrain');
                o_node.setAttribute('v3', num2str(avoidTerrain));
                ugcsList_node.appendChild(o_node); 
                              
                o_node = docNode1.createElement('o');
                o_node.setAttribute('v2','noActionsAtLastPoint');
                o_node.setAttribute('v3', actionsAtLast);
                ugcsList_node.appendChild(o_node);

Z=docNode1;
end