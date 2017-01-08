function [Img, Volume,Longhair, Bounds, Failed] = growHair(Image,foreHeadTop)

    if ~exist('Image','var')
        error('Image was not set please specify Input image')
    elseif isempty(Image)
        error('Selected Image was Empty and can not be used')
    elseif ndims(Image) > 3 || isequal(ndims(Image),1)
        error('The selected image has the wrong dimensions, only 2D grayscale Images and RGB Images are allowed')
    else
       Image = im2double(Image); 
    end
    
    %Setup reference and fixxed parameters
    
    %The image should be scaled to have 100000 pixels
    pixRefSize = 100000;
    %The seedPoints should be set 20 pixels above the foreHead Top
    foreHeadOffset = 14;
    %Set the offset of the other 4 seedPoints that will be set in
    %regiongrowing
    seedSpread = 5;
    %Factor when it is detected that the algorythm failed
    failedFactor = 1/2;
    %Threshold of the Bounding rectangle when the hair is considered as
    %long
    longThreshold = 0.9;
    
    %Setup image Dimensions
    [xDim, yDim, ~] = size(Image);
    
    %Calculate the factor of how much the image would need to be scaled
    %to match the pixelVolume of pixRefSize
    scaleFactor = pixRefSize / (xDim * yDim);
    
    %Filter the image with a gaussian Filter to smoothen image regions
    gauss = gaussianimplem(Image,3);
    
    % Regiongrowing often works better if the image is
    % downscaled and the algorythm is way faster
    gauss = imresize(gauss,scaleFactor);
    
    if exist('foreHeadTop','var')
        foreHeadTop(1) = foreHeadTop(1) * scaleFactor;
        foreHeadTop(2) = foreHeadTop(2) * scaleFactor;
    end
    
    %Setup Scaled image dimensions
    [scaledXDim, scaledYDim, ~] = size(gauss);
    
    
    if ~exist('foreHeadTop','var') || isempty(foreHeadTop)
        [loc] = get_image_point(gauss);
        foreHeadTop(1) = loc(1,2);
        foreHeadTop(2) = loc(1,1);
        %error('foreHeadTop does not exist, please specify foreHeadTop Point')
    elseif ~isequal(ndims(foreHeadTop),2)
        error('error Position needs to have 2 Values')  
    elseif ~boundcheck(foreHeadTop(1),foreHeadTop(2),scaledXDim,scaledYDim)
        error('foreHeadTop was out of the Image bounds, try again')
    end

    %Setup seedPosition above the foreheadPosition
    %to try and catch the Hair
    seedPos(1) = foreHeadTop(1)- foreHeadOffset - seedSpread ;
    seedPos(2) = foreHeadTop(2);%+ foreHeadOffset + seedSpread;
    
    %Check if seedPos is inside the image Bounds
    if ~boundcheck(seedPos(1),seedPos(2),scaledXDim,scaledYDim)
        error('seedPos exceeds the Image bounds, try again')
    end
    
    %Check if image already is grayscale otherwise convert
    if isequal(ndims(Image),3)
        grayImg = rgb2gray(gauss);
    else
        grayImg = gauss;
    end
    
    %Do Regiongrowing on the image to get binary mask
    tic
        Binmask = growmyregion(grayImg,seedPos,0.1,seedSpread);
    toc
    
    %Measure Regions in Binary Mask
    measurements = regionprops(Binmask, 'BoundingBox', 'Area');
    
    %Setup loop seching for the biggest area of the found regions
    mainRegion = measurements(1);
    if ndims(measurements)/2 > 1
        for regionCnt = 2:ndims(measurements)/2
            if(measurements(regionCnt*2).Area > mainRegion.Area)
                mainRegion = measurements(regionCnt);
            end
        end
    end
    
    %Calculate height/width ratio of the region
    lenghtratio = mainRegion.BoundingBox(4)/mainRegion.BoundingBox(3);
    
    %Calculate volume of the hair
    Volume = sum(sum(sum(Binmask)));
    
    %Set if hair is long or not
    Longhair = false;
    if lenghtratio > longThreshold
        Longhair = true;
    end
    
    %Check if the algorythm failed, that happens if too much of the
    %image was found as region -> can not be hair
    Failed = false;
    if Volume > (scaledXDim * scaledYDim)*failedFactor
       Failed = true; 
    end
    
    
%     resultString = ['Volume:' num2str(Volume) ' LenghtRatio:' num2str(lenghtratio) ' Isfemale:' num2str(Longhair) '::Bounds:' num2str(boundingVector)];
%     
%     imageSize = size(Image);
%     fontsize = cast((imageSize(1)/30),'int32');
%     if fontsize < 5
%        fontsize = 5; 
%     end
%     
%     resultWithText = insertText(gauss,[4,4], resultString,'FontSize',fontsize);
    
    %Add the binary mask on the red channel of the scaled and filtered
    %input image
    gauss(:,:,1) = gauss(:,:,1)+ Binmask;
     
    %Output the Hair Region Bounds
    Bounds = mainRegion.BoundingBox;
    
    % Insert Bounding Rectangle into image
    gauss = insertShape(gauss,'Rectangle', Bounds,'Color','blue','LineWidth',3);
    
    %Set result image as output
    Img = gauss;
    
end
