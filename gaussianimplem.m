function Img = gaussianimplem(Image,sigma,windowSize)

    %Default windowSize is 4
    if ~exist('windowSize','var')
        windowSize = 4;
    elseif isempty(sigma)
        windowSize = 4;
    end

    %Default sigma is 1.7
    if ~exist('sigma','var')
        %error('Sigma was not specified')
        sigma = 1.7;
    elseif isempty(sigma)
        %error('Sigma is empty')
        sigma = 1.7;
    end

    if ~exist('Image','var')
        error('Image was not set please specify Input image')
    elseif isempty(Image)
        error('Selected Image was Empty and can not be used')
    else
        %Check if image is Rgb or Grayscale image
        if isequal(ndims(Image), 2)
            
            Img = gaussianSingleChannel(Image,sigma,windowSize);
        elseif isequal(ndims(Image), 3)
            Img = Image;
            % If image is RGB use gaussian Blur on every color channel
            for channel = 1:size(Image,3)
                Img(:,:,channel) = gaussianSingleChannel(Image(:,:,channel), sigma, windowSize);
            end
        else
            error('Image does not have 2 dimensions please use compatible image')
        end
    end
   
end

function Img = gaussianSingleChannel(Image, sigma, windowSize)

    %Prepare Meshgrid variables for Kernel Generation
    [x,y] = meshgrid(-windowSize:windowSize , -windowSize:windowSize);
    
    %Use Impulse formula to calculate Gaussian Kernel
    Kernel= kernelformula(x,y,sigma);
    
    %Convolute the image with the kernel to blur it
    Img = convolute(Image,Kernel,windowSize);
    
end

function Kern = kernelformula(x,y,sigma)
    % Gaussian 2 dimensional formula
    % Source: http://en.wikipedia.org/wiki/Gaussian_filter#cite_ref-ShapiroStockman_5-0
    Kern = (1/(2*pi*sigma^2))*exp(-(x.^2+y.^2)/(2*sigma^2));
end

function Img = convolute(Image,kernel,winSize)
    %Define window height and length
    windowLenght = winSize*2;
    %Get the image size
    [xDim,yDim] = size(Image);
    %Add zero padding to the Input Image to prevent Index exceeding Matrix
    %dimensions
    Image = padarray(Image,[winSize winSize]);
    %Allocate output image memory
    Img = zeros(xDim,yDim);
    %Iterate through every pixel of the Image
    for i = 2:xDim-1
        for j = 2:yDim-1
            %Convolute image window with the kernel and save into a new
            %matrix
            filteredWindow = Image(i:i+windowLenght,j:j+windowLenght).*kernel;
            %Sum together weihted results for the sprecified pixel
            Img(i,j)=sum(filteredWindow(:));
        end
    end
end
