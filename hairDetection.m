function [gender, percentage] = hairDetection(file_path)
    
    bild = imread(file_path);
    I = im2double(bild);
    
    %%%Copy from here
    tic
    [result, Volume, Longhair ,boundingVector, failed] = growHair(I);
    toc
    
    gender = 'm';
    if Longhair
        gender = 'w';
    end
    
    percentage = 1;
    if failed
        gender = 'u';
    end
    %%%To here
end


