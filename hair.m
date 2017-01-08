function [gender,percentage] = hair(Image,faceBounds)
    
    if ~exist('faceBounds','var')
        error('faceBounds was not specified')
    elseif ~isequal(ndims(faceBounds),4)
        error('faceBounds needs to be a rectangle of 4 parameters')
    end
    
    %Middle Top of bounding Rect
    foreHeadTop(1) = faceBounds(1) + faceBounds(3)/2;
    foreHeadTop(2) = faceBounds(2);

    tic
    [~, ~, Longhair ,~, failed] = growHair(Image,foreHeadTop);
    toc
    
    gender = 'm';
    if Longhair
        gender = 'w';
    end
    
    percentage = 1;
    if failed
        gender = 'u';
    end
end