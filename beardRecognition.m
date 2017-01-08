function [gender, ObjectsMask] = beardRecognition(rgbImage)
rgbImage = imresize(rgbImage, [448, NaN]);

% Display the original image.
subplot(2, 4, 1);
hRGB = imshow(rgbImage);

%Convert RGB image to HSV
%input matrix represent intensity of red, blue and green
hsvImage = rgb2hsv(rgbImage);

% %Crop the face
% faceDetector = vision.CascadeObjectDetector;
% bboxes = step(faceDetector, hsvImage);
% %bboxes = [bboxes(1)+40 bboxes(2) bboxes(3)/3*2 bboxes(4)+40];
% %face = insertObjectAnnotation(hsvImage, 'rectangle', bboxes, 'Face');   
% cropped = imcrop(hsvImage, bboxes);

%Extract out the H, S, and V images individually
hImage = hsvImage(:,:,1);
sImage = hsvImage(:,:,2);
vImage = hsvImage(:,:,3);

% Display the hue image.
fontsize = 12;
subplot(2, 4, 2);
imshow(hImage);
title('Hue Image', 'FontSize', fontsize);

subplot(2, 4, 3);
imshow(sImage);
title('Saturation Image', 'FontSize', fontsize);

subplot(2, 4, 4);
imshow(vImage);
title('Value Image', 'FontSize', fontsize);

% Assign the low and high thresholds
hueThresholdLow = 0;
hueThresholdHigh = Otsu(hImage);
saturationThresholdLow = Otsu(sImage);
saturationThresholdHigh = 1.0;
valueThresholdLow = Otsu(vImage);
valueThresholdHigh = 1.0;

% Now apply each color band's particular thresholds to the color band
hueMask = (hImage >= hueThresholdLow) & (hImage <= hueThresholdHigh);
saturationMask = (sImage >= saturationThresholdLow) & (sImage <= saturationThresholdHigh);
valueMask = (vImage >= valueThresholdLow) & (vImage <= valueThresholdHigh);

% Display the thresholded binary images.
fontSize = 16;
subplot(2, 4, 6);
imshow(hueMask, []);

subplot(2, 4, 7);
imshow(saturationMask, []);
	
subplot(2, 4, 8);
imshow(valueMask, []);

% Combine the masks to find where hue Mask and value Mask are "true."
% Then we will have the mask of only the red parts of the image.
ObjectsMask = uint8(hueMask & saturationMask & valueMask);
subplot(2, 4, 5);
imshow(ObjectsMask, []);

%crop just the chin
[height, width, ~] = size(ObjectsMask);
cropBox = [width/4 height/5*4 width/4*2 height];
cropedObjectsMask = imcrop(ObjectsMask, cropBox);
imshow(cropedObjectsMask, []);

%counts black/white pixels
numberOfAllPixels = numel(cropedObjectsMask);
numBlackPixels = sum(~cropedObjectsMask(:));
%numWhitePixel = sum(cropedObjectsMask(:));


% numberOfAllPixels
% numWhitePixel
% numBlackPixels
if numBlackPixels > numberOfAllPixels/4
    gender = 'm';
else gender = 'f';
end

