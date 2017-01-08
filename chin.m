function [gender, persentage] = chin (input)
%gets the trained cascade object
detector = vision.CascadeObjectDetector('chinDetector5.xml');

I = input;


bbox = step(detector, I);

detectedImg = insertObjectAnnotation(I,'rectangle',bbox,'chin');

measurements = bbox(3);
%width of the bounding box(chin), which will be used to determine gender, would
%compare it to face width
measurements

%figure; imshow(detectedImg);

if measurements>=122
    gender = 'm';
elseif measurements<122&&measurements>110 
    gender = 'u';
else
    gender = 'w';
end
persentage = 1;


end
