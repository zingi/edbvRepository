function [result] = aaronSobel(bild)
    
    sobel_kernel_x = [   1, 0,-1;
                         2, 0,-2;
                         1, 0,-1    ];
                         
    sobel_kernel_y = [   1, 2, 1;
                         0, 0, 0;
                        -1,-2,-1    ];
                    
    sobel_kernel_x = sobel_kernel_x / 8;
    sobel_kernel_y = sobel_kernel_y / 8;
                        
    directionX = 1; % kx
    directionY = 1; % ky
    skalierung = 4;
    
    %result = sobelAnwenden(bild, sobel_kernel3x3);
    
    %matrix = conv2(sobel_kernel_x_3x3, sobel_kernel_y_3x3);
    
    gradientX = imfilter(bild, sobel_kernel_x, 'replicate');
    gradientY = imfilter(bild, sobel_kernel_y, 'replicate');
    
    magnitude = (gradientX .* gradientX) + (gradientY .* gradientY);
    
    abschneiden = sum(magnitude(:),'double') / numel(magnitude); %Durchschnitt
    abschneiden = abschneiden * skalierung;
    schwellwert = sqrt(abschneiden);
    
    result = magnitude > abschneiden; 
    
    % thinning:
    % result = computeedge(magnitude,gradientX,gradientY,1,1, int8([0 0 0 0]), 100*eps, abschneiden);
end
