clear all
clc

%gets the trained cascade object
detector = vision.CascadeObjectDetector('chinDetector5.xml');

I = imread('lisa2.jpg');


bbox = step(detector, I);

detectedImg = insertObjectAnnotation(I,'rectangle',bbox,'chin');

measurements = bbox(3);
%width of the bounding box(chin), which will be used to determine gender, would
%compare it to face width
measurements

figure; imshow(detectedImg);
