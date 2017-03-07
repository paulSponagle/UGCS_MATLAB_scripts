function Z=UgCS_footer(docNode1)

% This function adds the following lines to the xml file: 

%       <ugcs-List name="failsafes" type="Failsafe" v0="id" v1="version" v2="reason" v3="action">
%			<o v2="RC_LOST" v3="CONTINUE"/>
%       </ugcs-List>

         route_node=docNode1.getElementsByTagName('Route').item(0);
         ugcsList_node = docNode1.createElement('ugcs-List');
         %node = route_node.getFirstChild;

            ugcsList_node = docNode1.createElement('ugcs-List');
            ugcsList_node.setAttribute('name','failsafes');
            ugcsList_node.setAttribute('type','Failsafe');
            ugcsList_node.setAttribute('v0','id');
            ugcsList_node.setAttribute('v1','version');
            ugcsList_node.setAttribute('v2','reason');
            ugcsList_node.setAttribute('v3','action');
            route_node.appendChild(ugcsList_node);
                o_node = docNode1.createElement('o');
                o_node.setAttribute('v2','RC_LOST');  
                o_node.setAttribute('v3','CONTINUE');  
                ugcsList_node.appendChild(o_node);
    Z=docNode1;
end