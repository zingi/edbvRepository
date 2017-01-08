
%Source: http://stackoverflow.com/questions/761564/problem-with-matlab-imread
% by Azim, answered Apr 17 '09 at 19:26
[fn,pn]=uigetfile({'*.jpg','Image files'}, 'Select an image');
I = imread(fullfile(pn,fn));

%I = im2double(imread('C:\Users\Markus\Documents\edbvRepository\faces\kim1.jpg'));

while 0==0
    
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
    
    figure, imshow(result);
    
end


