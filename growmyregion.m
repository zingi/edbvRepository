function Binmask = growmyregion(Image,seedPoint,maxThreshold,seedSpread)

if ~exist('Image','var')
   error('Image was not set please specify Input image')
elseif isempty(Image)
    error('Selected Image was Empty and can not be used')
elseif ~isequal(ndims(Image), 2)
    error('The selected image has the wrong dimensions, only 2D grayscale Images are allowed')
end

[xDim, yDim] = size(Image);

if ~exist('seedSpread','var')
    seedSpread = 5;
elseif isempty(Image)
    seedSpread = 5;
elseif seedSpread*2 > xDim || seedSpread*2 > yDim
    error('The speedPoint spread definetely exeeds the image bounds')
end

if ~exist('seedPoint','var') || isempty(maxThreshold)
    error('seedPoint does not exist, please specify seed Point')
elseif ~boundcheck(seedPoint(1),seedPoint(2),xDim,yDim)
    error('seedPoint was out of the Image bounds, try again')
end

thresPercent = 0.05;

if ~exist('maxThreshold','var')
    maxThreshold = double(max(Image(:) - min(Image(:)))) * thresPercent;
end

%Setup Binary Image
Binmask = false(xDim,yDim);

%seedValue = double(Image(seedPoint(1),seedPoint(2)));

seedPositionsList = [seedPoint(1),seedPoint(2)];

%More seeds
Binmask(seedPoint(1),seedPoint(2)) = true;
seedPositionsList(end+1,:) = [seedPoint(1)+seedSpread,seedPoint(2)];
Binmask(seedPoint(1)+seedSpread,seedPoint(2)) = true;
seedPositionsList(end+1,:) = [seedPoint(1)-seedSpread,seedPoint(2)];
Binmask(seedPoint(1)-seedSpread,seedPoint(2)) = true;
seedPositionsList(end+1,:) = [seedPoint(1),seedPoint(2)+seedSpread];
Binmask(seedPoint(1),seedPoint(2)+seedSpread) = true;
seedPositionsList(end+1,:) = [seedPoint(1),seedPoint(2)-seedSpread];
Binmask(seedPoint(1),seedPoint(2)-seedSpread) = true;
%Update seedValue to mean of all
seedValue = mean(mean(Image(Binmask > 0)));

% Neighborhood kernel
neighborsMod=[-1 0; 1 0; 0 -1;0 1];
neighborsCount = size(neighborsMod,1);

    while size(seedPositionsList)

        xSeedPos = seedPositionsList(1,1);
        ySeedPos = seedPositionsList(1,2);
        
        seedPositionsList(1,:) = [];

        for neighCnt = 1:neighborsCount
            xNeighbor = xSeedPos +neighborsMod(neighCnt,1);
            yNeighbor = ySeedPos +neighborsMod(neighCnt,2);

            if boundcheck(xNeighbor,yNeighbor,xDim,yDim) &&...
                ~Binmask(xNeighbor,yNeighbor) &&...
                Image(xNeighbor,yNeighbor) < (seedValue + maxThreshold) &&...
                Image(xNeighbor,yNeighbor) > (seedValue - maxThreshold)

                Binmask(xNeighbor,yNeighbor) = true;
                seedPositionsList(end+1,:) = [xNeighbor,yNeighbor];
            end

        end

    end
    
end
