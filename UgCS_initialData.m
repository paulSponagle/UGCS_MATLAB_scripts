function Z =UgCS_initialData(docNode,initialData)
% initialData{1,1} = 'Route Name'; initialData{1,2} = routeName;
% initialData{2,1} = 'Home - Set Explicitly'; initialData{2,2}= 'EXPLICIT';
% initialData{3,1} = 'Home Lat'; initialData{3,2}= 43.0771836;      %[DD] North is positive
% initialData{4,1} = 'Home Long'; initialData{4,2}= -77.6706067;    %[DD] East is positive
% initialData{5,1} = 'Home Altitude'; initialData{5,2}= 151;      % [m AMSL or m AGL]
% initialData{6,1} = 'Avoid aerodromes'; initialData{6,2} = 'true';
% initialData{7,1} = 'Avoid Custom Zones'; initialData{7,2} = 'false';
% initialData{8,1} = 'Maximum Altitude'; initialData{8,2} = 200;   % [m AMSL or m AGL]
% initialData{9,1} = 'Emergency return Altitude'; initialData{9,2}= 175;
% initialData{10,1} = 'Vehicle Profile'; initialData{10,2}= 5; % 1 = ArDrone, 2 = DjiPhantom3, 3 = DjiPhantom4, 3 = S-900/1000, 5 = matrice ;
% initialData{11,1} = 'Altitude mode'; initialData{11,2} = 1; %1= AGL, 2 =AMSL
% initialData{12,1} = 'Trajectory Type'; initialData{12,2}= 151+50;

%% initial data
route_node = docNode.createElement('Route');
docNode.getDocumentElement.appendChild(route_node);

         uuid_node = docNode.createElement('modificationUuid');
         uuid_node.setAttribute('v',uuid());
         route_node.appendChild(uuid_node);
         
         name_node = docNode.createElement('name');
         name_node.setAttribute('v',initialData{1,2});
         route_node.appendChild(name_node);
         
         creationTime_node = docNode.createElement('creationTime');
         creationTime_node.setAttribute('v','2016-07-13T15:36:17.921-04:00'); %no need to alter
         route_node.appendChild(creationTime_node);
         
         if initialData{11,2} ==2
             altitudeType='WGS84';
         else
             altitudeType='AGL';
         end
         altitudeType_node = docNode.createElement('altitudeType');
         altitudeType_node.setAttribute('v',altitudeType);
         route_node.appendChild(altitudeType_node);
         
         trajectoryType_node = docNode.createElement('trajectoryType');
         trajectoryType_node.setAttribute('v','STRAIGHT');
         route_node.appendChild(trajectoryType_node);
         
         safeAltitude_node = docNode.createElement('safeAltitude');
         safeAltitude_node.setAttribute('v',num2str(initialData{9,2}));
         route_node.appendChild(safeAltitude_node);
         
         maxAltitude_node = docNode.createElement('maxAltitude');
         maxAltitude_node.setAttribute('v',num2str(initialData{8,2}));
         route_node.appendChild(maxAltitude_node);
         
         initialSpeed_node = docNode.createElement('initialSpeed');
         initialSpeed_node.setAttribute('v','0.0');
         route_node.appendChild(initialSpeed_node);         

         maxSpeed_node = docNode.createElement('maxSpeed');
         maxSpeed_node.setAttribute('v','0.0');
         route_node.appendChild(maxSpeed_node);
         
         homeLocationSource_node = docNode.createElement('homeLocationSource');
         homeLocationSource_node.setAttribute('v','EXPLICIT');
         route_node.appendChild(homeLocationSource_node);
         
         homeLatitude_node = docNode.createElement('homeLatitude');
         homeLatitude_node.setAttribute('v',num2str(initialData{3,2}*pi/180,16));
         route_node.appendChild(homeLatitude_node);     
         
         homeLongitude_node = docNode.createElement('homeLongitude');
         homeLongitude_node.setAttribute('v',num2str(initialData{4,2}*pi/180,16));
         route_node.appendChild(homeLongitude_node);
         
         if initialData{11,2} == 'AGL'
             altitude = 0;
         else
              altitude = initialData{5,2};
         end
         homeWgs84Altitude_node = docNode.createElement('homeWgs84Altitude');
         homeWgs84Altitude_node.setAttribute('v',num2str(altitude));
         route_node.appendChild(homeWgs84Altitude_node);
         
         if initialData{11,2} == 'AGL'
             altitude = initialData{5,2};
         else
              altitude = 0;
         end
         
         homeAglAltitude_node = docNode.createElement('homeAglAltitude');
         homeAglAltitude_node.setAttribute('v',num2str(altitude));
         route_node.appendChild(homeAglAltitude_node);
              
         checkAerodromeNfz_node = docNode.createElement('checkAerodromeNfz');
         checkAerodromeNfz_node.setAttribute('v',initialData{6,2} );
         route_node.appendChild(checkAerodromeNfz_node);
         
         CheckCustomNfz_node = docNode.createElement('checkCustomNfz');
         CheckCustomNfz_node.setAttribute('v',initialData{7,2} );
         route_node.appendChild(CheckCustomNfz_node);
         
         vehicleProfile_node = docNode.createElement('vehicleProfile');
         route_node.appendChild(vehicleProfile_node);
         
            platform_node = docNode.createElement('platform');
            vehicleProfile_node.appendChild(platform_node);
                if initialData{10,2} == 1
                    type = 'ArDrone';
                elseif initialData{10,2} ==2
                    type = 'DjiPhantom3';                
                elseif initialData{10,2} ==3
                    type = 'DjiPhantom4';                
                elseif initialData{10,2} ==4    
                    type = 'DjiA2';
                elseif initialData{10,2}==5
                    type = 'DjiMatrice100';
                end
                code_node = docNode.createElement('code');
                code_node.setAttribute('v',type);
                platform_node.appendChild(code_node);   
Z=docNode;                
end