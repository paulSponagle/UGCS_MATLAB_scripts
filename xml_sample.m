docNode = com.mathworks.xml.XMLUtils.createDocument... 
    ('root_element');
docRootNode = docNode.getDocumentElement;
docRootNode.setAttribute('attr_name','attr_value');
for i=1:20
    thisElement = docNode.createElement('child_node'); 
    thisElement.setAttribute('v',uuid());
    docRootNode.appendChild(thisElement);
end
docNode.appendChild(docNode.createComment('this is a comment'));
name = 'xmlTest';
xmlFileName = [name,'.xml'];
xmlwrite(xmlFileName,docNode);
type(xmlFileName);