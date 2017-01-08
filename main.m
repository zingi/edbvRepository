
%Source: http://stackoverflow.com/questions/761564/problem-with-matlab-imread
% by Azim, answered Apr 17 '09 at 19:26
[fn,pn]=uigetfile({'*.jpg','Image files'}, 'Select an image');
I = imread(fullfile(pn,fn));

%I = im2double(imread('C:\Users\Markus\Documents\edbvRepository\faces\kim1.jpg'));

while 0==0
    
    tic
    [resultWithText, Volume, Longhair ,boundingVector, failed] = growHair(I)
    toc
    
    rgender = 'm';
    if Longhair
        rgender = 'w';
    end
    
    rpercentage = 1;
    if failed
        rpercentage = 0;
    end
    
    
    
    figure, imshow(resultWithText);
    
    rectangle('Position', boundingVector, 'EdgeColor', 'blue');
    
end


