function [gray_imageComp] = complement(gray_image)
[height, width] = size(gray_image);
null = 0;
ones = 0;
    for r = height:-1:height-4
         if gray_image(r,width) == 0
               null=null+1;         
         else
               ones=ones+1;    
         end        
    end
    
    if null<ones
        gray_imageComp = imcomplement(gray_image);
    else
        gray_imageComp = gray_image;
    end
end