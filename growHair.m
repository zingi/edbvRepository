function [Img, Volume,Longhair, Bounds, Failed] = growHair(Image,foreHeadTop)
    
    if ~exist('Image','var')
        error('Image was not set please specify Input image')
    elseif isempty(Image)
        error('Selected Image was Empty and can not be used')
    elseif ndims(Image) > 3 || isequal(ndims(Image),1)
        error('The selected image has the wrong dimensions, only 2D grayscale Images and RGB Images are allowed')
    end
    
    [xDim, yDim] = size(Image);
    
    foreHeadOffset = 20;
    
    gauss = gaussianimplem(Image,3);
 
    %The image should be scaled to have 100000 pixels
    pixRefSize = 100000;
    
    [xDim, yDim, ~] = size(gauss);
    scaleFactor = pixRefSize / (xDim * yDim);
    
    % Regiongrowing works in some instances better if the image is
    % downscaled and the algorythm is way faster
    gauss = imresize(gauss,scaleFactor);
    
    if ~exist('foreHeadTop','var') || isempty(foreHeadTop)
        [loc] = get_image_point(gauss);
        foreHeadTop(1) = loc(1,2);
        foreHeadTop(2) = loc(1,1);
        %error('foreHeadTop does not exist, please specify foreHeadTop Point')
    elseif ~isequal(ndims(foreHeadTop),2)
        error('error Position needs to have 2 Values')  
    elseif ~boundcheck(foreHeadTop(1),foreHeadTop(2),xDim,yDim)
        error('foreHeadTop was out of the Image bounds, try again')
    end

    

    seedPos(1) = foreHeadTop(1)- foreHeadOffset - 5 ;
    seedPos(2) = foreHeadTop(2);%+ foreHeadOffset + 5;
    
    if ~boundcheck(seedPos(1),seedPos(2),xDim,yDim)
        error('seedPos exceeds the Image bounds, try again')
    end
    
    
    if isequal(ndims(Image),3)
        grayImg = rgb2gray(gauss);
    else
        grayImg = gauss;
    end
    
    tic
        Binmask = growmyregion(grayImg,seedPos,0.1);
    toc
    
    measurements = regionprops(Binmask, 'BoundingBox', 'Area');
    
    mainRegion = measurements(1);
    if ndims(measurements)/2 > 1
        for regionCnt = 2:ndims(measurements)/2
            if(measurements(regionCnt*2).Area > mainRegion.Area)
                mainRegion = measurements(regionCnt);
            end
        end
    end

    boundingVector = mainRegion.BoundingBox;
    
    lenghtratio = boundingVector(4)/boundingVector(3);
    
    Longhair = false;
    if lenghtratio > 0.9
        Longhair = true;
    end
    
    Volume = sum(sum(sum(Binmask)));
    
    [scaledXDim, scaledYDim, ~] = size(gauss);
    Failed = false;
    if Volume > (scaledXDim * scaledYDim)/2
       Failed = true; 
    end
    
    resultString = ['Volume:' num2str(Volume) ' LenghtRatio:' num2str(lenghtratio) ' Isfemale:' num2str(Longhair) '::Bounds:' num2str(boundingVector)];
    
    imageSize = size(Image);
    fontsize = cast((imageSize(1)/30),'int32');
    if fontsize < 1
       fontsize = 1; 
    end
    
    resultWithText = insertText(gauss,[4,4], resultString,'FontSize',fontsize);
    
    resultWithText(:,:,1) = resultWithText(:,:,1)+ Binmask;
    
    Bounds = boundingVector;
    
    Img = resultWithText;
    
end
