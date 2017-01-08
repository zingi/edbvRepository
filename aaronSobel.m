% Babic, Z., & Mandic, D. (2003). An efficient noise removal and edge preserving convolution filter. 
% Telecommunications in Modern Satellite, Cable and Broadcasting Service, 2003. TELSIKS 2003. 
% 6th International Conference on, 2, 538-541.
% 
% E-Book der TU-UB:
% http://catalogplus.tuwien.ac.at/primo_library/libweb/action/display.do?frbrVersion=2&tabs=detailsTab&ct=display&fn=search&doc=TN_ieee10.1109%2fTELSKS.2003.1246284


function [result] = aaronSobel(bild)
    
    sobel_kernel_x = [   1, 0,-1;
                         2, 0,-2;
                         1, 0,-1    ]; % horizontale Ableitungs-Filter
                         
    sobel_kernel_y = [   1, 2, 1;
                         0, 0, 0;
                        -1,-2,-1    ]; % vertikale Ableitungs-Filter
                    
    sobel_kernel_x = sobel_kernel_x / 8;
    sobel_kernel_y = sobel_kernel_y / 8;
                        
    skalierung = 4;
    
    gradientX = imfilter(bild, sobel_kernel_x, 'replicate');
    gradientY = imfilter(bild, sobel_kernel_y, 'replicate');
    
    magnitude = (gradientX .* gradientX) + (gradientY .* gradientY); % in x und y Richtung
    
    abschneiden = sum(magnitude(:),'double') / numel(magnitude); %Durchschnitt
    abschneiden = abschneiden * skalierung;
    schwellwert = sqrt(abschneiden);
    
    result = magnitude > abschneiden;
end
