function Z = UgCS_segment_perimeter(docNode1,data,polygon)
% This function adds a 'Perimeter' Segment to a UgCS xml flightplan.
% You must use ugCS header and UgCS intial data before using a segment.
% inputs - docNode1 - xml document
%        - data (10x2 cell)
%        - polygon (nx2 matrix)
lat=polygon(:,1)*pi/180;
long= polygon(:,2)*pi/180;
alt=0;
order = data{1,2};
speed = data{2,2};
turn = data{3,2};
if turn==2;
    turn='STRAIGHT';
else
    turn='STOP_AND_TURN';
end
height = data{4,2};
aboveGround = data{5,2};
if aboveGround==0
    aboveGround='False';
else
    aboveGround='True';
loops = data{6,2};
action = data{7,2};
if action ==2
    action= ONLY_AT_START;
else
    action = 'ACTIONS_EVERY_POINT';
end
obstacles = data{8,2};
if obstacles==0
    obstacles='False';
else
    obstacles='True';
end
terrain = data{9,2};
if terrain==0
    terrain='False';
else
    terrain='True';
end
actionsAtLast = data{10,2};
if actionsAtLast==0
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
            algorithmClassName_node.setAttribute('v','com.ugcs.ucs.service.routing.impl.PerimeterAlgorithm');
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
                    o_node.setAttribute('v6',num2str(alt));  
                    o_node.setAttribute('v7','AGL');  
                    ugcsList_node.appendChild(o_node);
                end
                    o_node = docNode1.createElement('o');
                    o_node.setAttribute('v2',num2str(ii+1));  
                    o_node.setAttribute('v3',num2str(lat(1),16));  
                    o_node.setAttribute('v4',num2str(long(1),16));  
                    o_node.setAttribute('v6',num2str(alt));  
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
                o_node.setAttribute('v2','height');%
                o_node.setAttribute('v3', num2str(height));%
                ugcsList_node.appendChild(o_node); %
                
                o_node = docNode1.createElement('o');
                o_node.setAttribute('v2','heightAgl');
                o_node.setAttribute('v3', aboveGround);
                ugcsList_node.appendChild(o_node);
                
                o_node = docNode1.createElement('o');
                o_node.setAttribute('v2','loops');
                o_node.setAttribute('v3', num2str(loops)); 
                ugcsList_node.appendChild(o_node); 

                o_node = docNode1.createElement('o');%                                
                o_node.setAttribute('v2','actionExecution');%
                o_node.setAttribute('v3', action);%
                ugcsList_node.appendChild(o_node); %  
                
                o_node = docNode1.createElement('o');
                o_node.setAttribute('v2','avoidObstacles');
                o_node.setAttribute('v3', obstacles); 
                ugcsList_node.appendChild(o_node);
                
                o_node = docNode1.createElement('o');
                o_node.setAttribute('v2','avoidTerrain');
                o_node.setAttribute('v3', terrain);
                ugcsList_node.appendChild(o_node); 
                        
                o_node = docNode1.createElement('o');
                o_node.setAttribute('v2','noActionsAtLastPoint');
                o_node.setAttribute('v3', actionsAtLast);
                ugcsList_node.appendChild(o_node);

Z=docNode1;
end