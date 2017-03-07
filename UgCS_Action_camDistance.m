function Z = UgCS_Action_camDistance(docNode1,data,seg_order)
% This function adds a camera operation based on time
% inputs
%       -docNode1 - xml document
%       - data - 4x2 cell array
%               - order
%               - interval
%               - shotsNumber
%               - startDelay
%               -                           ?autoCalc  % 0 =false, 1= true?
order=data{1,2};
interval=data{2,2};
shots=data{3,2};
delay=data{4,2};
%autoCalc=data{5,2};
segments_node = docNode1.getElementsByTagName('segments').item(seg_order);
action_node = docNode1.createElement('actionDefinitions');
segments_node.appendChild(action_node);

    orderNode = docNode1.createElement('order');
    orderNode.setAttribute('v',num2str(order)); 
    action_node.appendChild(orderNode);   

    cam_node = docNode1.createElement('cameraSeriesByDistanceDefinition');
    action_node.appendChild(cam_node);  
    
        int_node = docNode1.createElement('interval');
        int_node.setAttribute('v',num2str(interval)); 
        cam_node.appendChild(int_node);  
        
        num_node = docNode1.createElement('shotsNumber');
        num_node.setAttribute('v',num2str(shots)); 
        cam_node.appendChild(num_node);  
        
        delay_node = docNode1.createElement('startDelay');
        delay_node.setAttribute('v',num2str(delay)); 
        cam_node.appendChild(delay_node);    
        
        calc_node = docNode1.createElement('autoCalc');
%         if autoCalc==1
%             autoCalc='true';
%         else
%             autoCalc='false';
%         end
        calc_node.setAttribute('v','false'); 
        cam_node.appendChild(calc_node);          

Z= docNode1;

end

