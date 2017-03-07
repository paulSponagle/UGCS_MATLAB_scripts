function Z = UgCS_Action_camTrigger(docNode1,data,seg_order)
% This function will append the xml document with start/stop video recording, or take a single still
% inputs: 
%       - docNode1 - xml Document
%       - data 
%               - order
%               - action - 1 = START_RECORDING
%                        - 2 = STOP_RECORDING
%                        - 3 = SINGLE_SHOT 

order = data{1,2};
action = data{2,2};

segments_node = docNode1.getElementsByTagName('segments').item(seg_order);
action_node = docNode1.createElement('actionDefinitions');
segments_node.appendChild(action_node);

    orderNode = docNode1.createElement('order');
    orderNode.setAttribute('v',num2str(order)); 
    action_node.appendChild(orderNode);
    
    definition_node = docNode1.createElement('cameraTriggerDefinition');
    action_node.appendChild(definition_node);  
    
    state_node = docNode1.createElement('state');
    if action ==1
        state ='START_RECORDING';
    elseif action==2
        state='STOP_RECORDING';
    else
        state='SINGLE_SHOT';
    end
    state_node.setAttribute('v',num2str(state)); 
    definition_node.appendChild(state_node);


Z=docNode1;
end