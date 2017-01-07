function [coordFirst,coordLast] = findLips(gray_image,x,y)
% Calculate Lips Size 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% finds the next white pixels upper and lower the prewitt found one 
% gray_image = input binary image with canny filter applied
% x,y = coordinates of the supposed lip pixel found with the help of the prewitt filter 
% coordFirst, coordLast = upper and lower found white pixels
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
coordFirst = x;
coordLast = x;
counterUp=0;
counterDown=0;
    for r = x-1:-1:x-30
         if gray_image(r,y) == 1
              coordFirst = r;     
              counterUp=counterUp+1;
              if counterUp == 3
                  break
              end
         end        
    end
    
     for p = x+1:1:x+30
         if gray_image(p,y) == 1
              coordLast = p;   
              counterDown=counterDown+1;
              if counterDown == 2
                  break
              end
         end        
    end
    
end