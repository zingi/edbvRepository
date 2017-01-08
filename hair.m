function [gender,percentage] = hair(Image,faceBounds)
    
    if ~exist('faceBounds','var')
        %error('faceBounds was not specified')
    FDetect = vision.CascadeObjectDetector;
    
    %Returns Bounding Box values based on number of objects
    BoundBoxes = step(FDetect,Image);

    faceBounds = BoundBoxes(1,:);
    if size(BoundBoxes,1) > 1
        for regionCnt = 1:size(BoundBoxes,1)
            if(BoundBoxes(regionCnt,3)*BoundBoxes(regionCnt,4) > faceBounds(3) * faceBounds(4))
                faceBounds = BoundBoxes(regionCnt,:);
            end
        end
    end
        
    elseif ~isequal(ndims(faceBounds),4)
        error('faceBounds needs to be a rectangle of 4 parameters')
    end
    
    %Middle Top of bounding Rect
    foreHeadTop(2) = faceBounds(1) + faceBounds(3)/2;
    foreHeadTop(1) = faceBounds(2);
    foreHeadTop = uint8(foreHeadTop);

    tic
    [result, ~, Longhair ,~, failed] = growHair(Image,foreHeadTop);
    toc
    
    imshow(result)
    
    gender = 'm';
    if Longhair
        gender = 'w';
    end
    
    percentage = 1;
    if failed
        gender = 'u';
    end
end