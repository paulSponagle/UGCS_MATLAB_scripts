function Z =uuid()
% this function is copied from the "tempname" function and the last
% underscore was changed to hyphen. This is designed to be useful when
% several UUIDs are required. 
Z=strrep(char(java.util.UUID.randomUUID),'-','-');
end