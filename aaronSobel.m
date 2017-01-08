function [result] = aaronSobel(bild)
    
    sobel_kernel_x = [   1, 0,-1;
                         2, 0,-2;
                         1, 0,-1    ];
                         
    sobel_kernel_y = [   1, 2, 1;
                         0, 0, 0;
                        -1,-2,-1    ];
                    
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
