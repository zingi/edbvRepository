function[gender] = lipsdetection(image_path)
% Lips Size Detection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculates the distance between upper and lower edge of the lips and
% guesses the person's assumed gender according to the obtained number
% imgage_path  : rgb input image   
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

image_original = image_path;
% Resize the input image for the height = 448 
rgbImage = imresize(image_original,[448 NaN]);

% Get sizes of the image
[rows, columns, numberOfColorChannels] = size(rgbImage);

% Get only the left half of the pictute for the horisontal prewitt filter
middleColumn = int32(columns/2);
leftHalf = rgbImage(:, 1:middleColumn, :);

% Apply prewitt filter on obtained left half
image_gray = (0.2989 * double(leftHalf(:,:,1)) + 0.5870 * double(leftHalf(:,:,2)) + 0.1140 * double(leftHalf(:,:,3)))/255;
h = [ 1  1  1
    0  0  0
    -1 -1 -1 ];
image_edge = imfilter(image_gray, h,'same');
% find the max range of the prewitt image and set all the pixels that are
% bigger than this number to 1 and these that are smaller to 0
maxnum = max(image_edge(:));
interval = maxnum-2.5;

image_edge(image_edge>interval)= 1;
image_edge(image_edge<interval)= 0;

% make sure that the input picture is BW with white pixels == 1 and black == 0
compl = complement(image_edge);
[height, width] = size(image_edge);

% Next algo is using the next logic:
%     1) in 90% of cases with the rightly lighted pictures, the lips line will be shown after the max interval
%        elimination, so we using this knowledge to do the next step
%     2) search for the first white pixel on the right edge of the left half
%        picture, it should be the pixel of the mouth.
%     3) with the obtained coordinates of the found pixel, search for the next white lines on the Canny Image 
%     4) calculate the distance between the found upper and lower lip pixel 

coordX = findW(compl,height,width);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if the first white pixel is not in the first right column
ifNotFirstRow = 1;
coordY=width-1;
while coordX == 0
    coordX=findW(compl,height,coordY);    
    coordY=coordY-1;
    ifNotFirstRow=ifNotFirstRow+1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


coordY=coordY+ifNotFirstRow;

image_gray2 = (0.2989 * double(rgbImage(:,:,1)) + 0.5870 * double(rgbImage(:,:,2)) + 0.1140 * double(rgbImage(:,:,3)))/255;
N=canny(image_gray2, 1, 3.0, 1.5);

[x,y]= findLips(N,coordX,coordY);
gender = guessGenderForLips(x,y);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for the testing
% Uncomment for seeing the detected lips size
%
figure, imshow(N)
hold on% 
a = [x,y];
b =[coordY,coordY]; 
plot(b,a,'r')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



end