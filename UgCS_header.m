function Z = UgCS_header()

%% This function creates a header for the xml file to be read into UgCS
docNode = com.mathworks.xml.XMLUtils.createDocument('ugcs-Transfer');
    ver_Node = docNode.createElement('Version');
    docNode.getDocumentElement.appendChild(ver_Node);
    
        maj_Node = docNode.createElement('major');
        maj_Node.setAttribute('v','2');
        ver_Node.appendChild(maj_Node);
        
        min_Node = docNode.createElement('minor');
        min_Node.setAttribute('v','9');
        ver_Node.appendChild(min_Node);
        
        build_Node = docNode.createElement('build');
        build_Node.setAttribute('v','1230');
        ver_Node.appendChild(build_Node);

        component_Node = docNode.createElement('component');
        component_Node.setAttribute('v','DATABASE');
        ver_Node.appendChild(component_Node); 
        Z=docNode;
        
end