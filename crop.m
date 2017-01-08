function [cropped] = crop(I, rgbImage)

%Crop the face
faceDetector = vision.CascadeObjectDetector;
bboxes = step(faceDetector, rgbImage);
bboxes = [bboxes(1)+40 bboxes(2) bboxes(3)/3*2 bboxes(4)+40];  
cropped = imcrop(I, bboxes);

