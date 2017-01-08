function Binmask = growmyregion(Image,seedPoint,maxThreshold,seedSpread)

    if ~exist('Image','var')
       error('Image was not set please specify Input image')
    elseif isempty(Image)
        error('Selected Image was Empty and can not be used')
    elseif ~isequal(ndims(Image), 2)
        error('The selected image has the wrong dimensions, only 2D grayscale Images are allowed')
    end

    %Setup Image dimensions
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
    %If maxThreshold is not set calculate threshold based on max range in
    %image
    if ~exist('maxThreshold','var')
        maxThreshold = double(max(Image(:) - min(Image(:)))) * thresPercent;
    end

    %Setup Neighborhood kernel
    neighborsMod=[-1 0; 1 0; 0 -1;0 1];
    %Calculate Number of Neighborhood kernel elements
    neighborsCount = size(neighborsMod,1);

    %Setup Binary Image
    Binmask = false(xDim,yDim);

    %seedValue = double(Image(seedPoint(1),seedPoint(2)));

    %setup seedPositionList and put the seedPoint Position into it
    seedPositionsList = [seedPoint(1),seedPoint(2)];
    %Add seedPoint to Binary Mask
    Binmask(seedPoint(1),seedPoint(2)) = true;

    %Add additional seed Points to seedPositionsList and Binmask
    %which represent a four region with a distance seedSpread to center
    seedPositionsList(end+1,:) = [seedPoint(1)+seedSpread,seedPoint(2)];
    Binmask(seedPoint(1)+seedSpread,seedPoint(2)) = true;
    seedPositionsList(end+1,:) = [seedPoint(1)-seedSpread,seedPoint(2)];
    Binmask(seedPoint(1)-seedSpread,seedPoint(2)) = true;
    seedPositionsList(end+1,:) = [seedPoint(1),seedPoint(2)+seedSpread];
    Binmask(seedPoint(1),seedPoint(2)+seedSpread) = true;
    seedPositionsList(end+1,:) = [seedPoint(1),seedPoint(2)-seedSpread];
    Binmask(seedPoint(1),seedPoint(2)-seedSpread) = true;
    %Update seedValue to mean of all seedPoints
    seedValue = mean(mean(Image(Binmask > 0)));

    %Start Recursive region filling
    %Repeat while seedPositionsList is not an empty list
    % Concept Source: http://en.wikipedia.org/wiki/Region_growing
    % Concept Source: S65 - S68 Robert Sablatnig, Computer Vision Lab, EVC-23: Image Segmentation
    %Chapter Region Growing/ Unterlagen: 186822_2016S
    while size(seedPositionsList)

        %Get Positon of first element in seedPositionsList
        xSeedPos = seedPositionsList(1,1);
        ySeedPos = seedPositionsList(1,2);
        
        %Remove the first seedPoint in the List
        seedPositionsList(1,:) = [];

        %Iterate through every neighborHood kernel element
        for neighCnt = 1:neighborsCount
            
            %Calculate neighbor posiotion with neighbor kernel
            xNeighbor = xSeedPos +neighborsMod(neighCnt,1);
            yNeighbor = ySeedPos +neighborsMod(neighCnt,2);

            if boundcheck(xNeighbor,yNeighbor,xDim,yDim) &&... Check if neighbor point is inside Image
                ~Binmask(xNeighbor,yNeighbor) &&... Check if neighbor point was already added to Binmask
                Image(xNeighbor,yNeighbor) < (seedValue + maxThreshold) &&... Check if neighbor point is inside the 
                Image(xNeighbor,yNeighbor) > (seedValue - maxThreshold)% Threshold range from the seedValue
                
                %If all conditions are true add the neighbor point to the
                %Binary Mask
                Binmask(xNeighbor,yNeighbor) = true;
                %And add the point to the end of seedPositionsList
                %For small images (which we should have because of scaling) 
                %list copying is still a fast option
                seedPositionsList(end+1,:) = [xNeighbor,yNeighbor];
            end

        end

    end
    
end
