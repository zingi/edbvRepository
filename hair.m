function [gender,percentage] = hair(Image,foreHeadTop)
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