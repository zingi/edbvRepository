function [gender,percentage] = hair(Image,faceBounds)
    
    if ~exist('faceBounds','var')
        %error('faceBounds was not specified')
%         faceDetector = vision.CascadeObjectDetector();
%         faceBounds = step(faceDetector, Image);
%         insertObjectAnnotation(Image,'rectangle',faceBounds,'Face');
%         imshow(Image)
        
    elseif ~isequal(ndims(faceBounds),4)
        error('faceBounds needs to be a rectangle of 4 parameters')
    end
    
    %Middle Top of bounding Rect
    %foreHeadTop(1) = faceBounds(1) + faceBounds(3)/2;
    %foreHeadTop(2) = faceBounds(2);

    tic
    [result, ~, Longhair ,~, failed] = growHair(Image);
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