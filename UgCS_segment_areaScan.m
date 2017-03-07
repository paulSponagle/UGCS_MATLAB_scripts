function Z = UgCS_segment_areaScan(docNode1,data,polygon)
% This function appends an 'Area Scan' Segment to a UgCS xml flight plan file
% inputs:
%       -docNode1 - the xml document
%       - data - 13x2 cell
%       - polygon - matrix with latitude and longitude in columns
order= data{1,2};
speed=data{2,2};
turn=data{3,2};
if turn==1
    turn='STOP_AND_TURN';
else
    turn='STRAIGHT';
end
height=data{4,2};
altType = data{5,2};
if altType==1
    altType='WGS84';
else
    altType='AGL';
end
sideDistance=data{6,2};
direction=data{7,2};
obstacles=data{8,2};
if obstacles==1
    obstacles='True';
else
    obstacles='False';
end
action = data{9,2};
if action==2;
    action='ONLY_AT_START';
elseif action==3
    action='ACTIONS_ON_FORWARD_PASSES';
else
    action='ACTIONS_EVERY_POINT';
end

overshoot= data{10,2};

partialCalc=data{11,2};
if partialCalc==1||True
    partialCalc='True';
else
    partialCalc='False';
end

tolerance=data{12,2};

actionsAtLast=data{13,2};
if actionsAtLast==1
    actionsAtLast='True';
else
    actionsAtLast='False';
end

lat= polygon(:,1)*pi/180;
long = polygon(:,2)*pi/180;
alt = 0;

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
            algorithmClassName_node.setAttribute('v','com.ugcs.ucs.service.routing.impl.AreaScanAlgorithm');
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
                o_node.setAttribute('v2','height');%
                o_node.setAttribute('v3', num2str(height));%
                ugcsList_node.appendChild(o_node); %
                
                o_node = docNode1.createElement('o');
                o_node.setAttribute('v2','altitudeType');
                o_node.setAttribute('v3', altType);
                ugcsList_node.appendChild(o_node);
                
                o_node = docNode1.createElement('o');
                o_node.setAttribute('v2','sideDistance');
                o_node.setAttribute('v3', num2str(sideDistance)); 
                ugcsList_node.appendChild(o_node); 
                
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
                o_node.setAttribute('v2','overshoot');
                o_node.setAttribute('v3', num2str(overshoot));
                ugcsList_node.appendChild(o_node); 
                
                o_node = docNode1.createElement('o');
                o_node.setAttribute('v2','areaScanAllowPartialCalculation');
                o_node.setAttribute('v3', partialCalc);
                ugcsList_node.appendChild(o_node);

                o_node = docNode1.createElement('o');
                o_node.setAttribute('v2','tolerance');
                o_node.setAttribute('v3', num2str(tolerance)); 
                ugcsList_node.appendChild(o_node); 
                
                o_node = docNode1.createElement('o');
                o_node.setAttribute('v2','noActionsAtLastPoint');
                o_node.setAttribute('v3', actionsAtLast);
                ugcsList_node.appendChild(o_node);
Z=docNode1;
end