function coordX = findW(gray_image,height,width)
% Find First White Pixel 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% finds the first white pixel starting from the right bottom corner of the
% image
% gray_image = input binary image
% height,width = height and width parameters of the given image
% coordX = found first white pixel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
coordX=0;

    for r = height-100:-1:height/2 %actually looking for the pixel in the range of half the height to height-100 to eliminate the possibility of detecting clothes or the chin
         if gray_image(r,width) == 1          
                coordX = r;
                break;             
         end        
    end    
   
end