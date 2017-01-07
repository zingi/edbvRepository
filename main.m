I = im2double(imread('C:\Users\Markus\Documents\MatlabProject\shortx2.jpg'));

while 0==0
    
    tic
    [resultWithText, Volume, Longhair ,boundingVector, failed] = growHair(I);
    toc
    
    figure, imshow(resultWithText);
    
    rectangle('Position', boundingVector, 'EdgeColor', 'blue');
    
end


