function [canny_img] = canny(image_gray, threshL, threshH, sig)
% Canny Edge Detector 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Applies the canny edge detection to the input image
% img_gray  : binary input image   
% Double threshold :
% threshL : for low threshold: low * average of norm gradient
% threshH: for high threshold: high * threshL
% sig  : sigma for derivative
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Gaussian filter

derivGauss=dgauss(sig);
Gx = conv2(image_gray, derivGauss','same'); % (transpose derivative) horizontal direction
Gy = conv2(image_gray, derivGauss ,'same'); % vertical derection

% Finding the intensity gradient of the image

% norm of gradient (hypot function)
G = sqrt(Gx.^2 + Gy.^2);

% adaptive low and high threshold
lowTthreshL  = threshL * mean(G(:));
threshH = threshH * lowTthreshL;

% edge direction angle
theta = atan2(Gy, Gx);

Gx(Gx==0) = realmin('single'); % for divide by zero
slope = abs(Gy ./ Gx);
y = theta < 0;
theta = theta + 180*y; % x and x-180 are the same

% The edge direction angle is rounded to one of four angles representing vertical, 
% horizontal and the two diagonals (0°, 45°, 90° and 135° for example).

[bincounts, angles] = histc(theta,[0 45 90 135 180]);

% set the boundary pixels to 0 (do not count)
angles(1,:)=0;
angles(:,1)=0;
angles(end,:)=0;
angles(:,end)=0;

[rows,columns] = size(angles);
final_img = zeros(rows,columns);
canny_img = zeros(rows,columns);

% Non-maximum suppression
% Non-maximum suppression can help to suppress all the gradient values to 0 
% except the local maximal, which indicates location with the sharpest change of intensity value. 
% The algorithm for each pixel in the gradient image is:
%       1) Compare the edge strength of the current pixel with the edge strength 
%          of the pixel in the positive and negative gradient directions.
%       2) If the edge strength of the current pixel is the largest compared
%          to the other pixels in the mask with the same direction (i.e., the pixel that is pointing
%          in the y direction, it will be compared to the pixel above and below it in the vertical axis), 
%          the value will be preserved. Otherwise, the value will be suppressed.


% a good description of the algorithm below:
% https://en.wikipedia.org/wiki/Canny_edge_detector (Non-maximum suppression)
%
% -1,1----0,1-----1,1
%   |      |        |
% -1,0----0,0-----1,0
%   |      |        |
% -1,-1---0,-1---1,-1

% the start point is 0,0



% gradient direction: 0-45
index = find(angles == 1);
slpe = slope(index);

% interpolate between (1,1) and (1,0)
nullToFortyFiveGrad = slpe.*(G(index)-G(index+rows+1))+(1-slpe).*(G(index)-G(index+1));
% interpolate between (-1,-1) and (-1,0)
nullToFortyFiveGrad2 = slpe.*(G(index)-G(index-rows-1))+(1-slpe).*(G(index)-G(index-1));

blackPixels = index(nullToFortyFiveGrad>=0 & nullToFortyFiveGrad2>=0);
final_img(blackPixels) = 1;


%gradient direction: 45-90
index = find(angles == 2);
inverseSlpe = 1./slope(index);

% interpolate between (1,1) and (0,1)
fortyFiveToNinetyGrad = inverseSlpe.*(G(index)-G(index+rows+1))+(1-inverseSlpe).*(G(index)-G(index+rows));
% interpolate between (-1,-1) and (0,-1)
fortyFiveToNinetyGrad2 = inverseSlpe.*(G(index)-G(index-rows-1))+(1-inverseSlpe).*(G(index)-G(index-rows));

blackPixels = index(fortyFiveToNinetyGrad>=0 & fortyFiveToNinetyGrad2>=0);
final_img(blackPixels) = 1;


%gradient direction: 90-135
index = find(angles == 3);
inverseSlpe = 1./slope(index);

% interpolate between (-1,1) and (0,1)
ninetyToHundredThirtyFiveGrad = inverseSlpe.*(G(index)-G(index+rows-1))+(1-inverseSlpe).*(G(index)-G(index+rows));
% interpolate between (1,-1) and (0,-1)
ninetyToHundredThirtyFiveGrad2 = inverseSlpe.*(G(index)-G(index-rows+1))+(1-inverseSlpe).*(G(index)-G(index-rows));

blackPixels = index(ninetyToHundredThirtyFiveGrad>=0 & ninetyToHundredThirtyFiveGrad2>=0);
final_img(blackPixels) = 1;

%gradient direction: 135-180
index = find(angles == 4);
slpe = slope(index);

% interpolate between (-1,1) and (-1,0)
nullToFortyGrad = slpe.*(G(index)-G(index+rows-1))+(1-slpe).*(G(index)-G(index-1));
% interpolate between (1,-1) and (1,0)
nullToFortyGrad2 = slpe.*(G(index)-G(index-rows+1))+(1-slpe).*(G(index)-G(index+1));

blackPixels = index(nullToFortyGrad>=0 & nullToFortyGrad2>=0);
final_img(blackPixels) = 1;

% Linking and thresholding (hysteresis)
% If the edge pixel’s gradient value is higher than the high
% threshold value, they are marked as strong edge pixels (pixel == 1). If the edge pixel’s 
% gradient value is smaller than the high threshold value and larger than the 
% low threshold value, they are marked as weak edge pixels (pixel == 0.7).
% If the pixel value is smaller than the low threshold value, they will be
% suppressed (pixel == 0)

final_img = final_img*0.7; 
newX = final_img > 0 & G < lowTthreshL;
final_img(newX) = 0;
newX = final_img > 0 & G  > threshH;
final_img(newX) = 1;

% To achieve an accurate result, the weak edges caused by the latter 
% reasons should be removed. Usually a weak edge pixel caused from true 
% edges will be connected to a strong edge pixel while noise responses 
% are unconnected. To track the edge connection, blob analysis is applied by 
% looking at a weak edge pixel and its 8-connected neighborhood pixels. 
% As long as there is one strong edge pixel that is involved in the blob, 
% that weak edge point can be identified as one that should be preserved.
%
% more info about blob extraction: https://en.wikipedia.org/wiki/Connected-component_labeling

oldX = [];
newX = find(final_img==1);
while (size(oldX,1) ~= size(newX,1))
  oldX = newX;
  neighbours = [newX+rows+1, newX+rows, newX+rows-1, newX-1, newX-rows-1, newX-rows, newX-rows+1, newX+1];  
  final_img(neighbours) = 0.3 + final_img(neighbours);
  
  y = final_img==0.3;
  final_img(y) = 0;
  
  y = final_img>=1;
  final_img(y)=1;
  
  newX = find(final_img==1);
end
		   
newX = final_img==1;

canny_img(newX)=1;


