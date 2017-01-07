function Img = gaussianimplem(Image,sigma,windowSize)

    if ~exist('windowSize','var')
        windowSize = 4;
    elseif isempty(sigma)
        windowSize = 4;
    end

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
        if isequal(ndims(Image), 2)
           Img = gaussianSingleChannel(Image,sigma,windowSize);
        elseif isequal(ndims(Image), 3)
            Img = Image;
            for channel = 1:size(Image,3)
                Img(:,:,channel) = gaussianSingleChannel(Image(:,:,channel), sigma, windowSize);
            end
        else
            error('Image does not have 2 dimensions please use compatible image')
        end
    end
   
end

function Img = gaussianSingleChannel(Image, sigma, windowSize)

    [x,y] = meshgrid(-windowSize:windowSize , -windowSize:windowSize);
    
    Kernel= kernelformula(x,y,sigma);
    
    Img = convolute(Image,Kernel,windowSize);
    
end

function Kern = kernelformula(x,y,sigma)
    Kern = (1/(2*pi*sigma^2))*exp(-(x.^2+y.^2)/(2*sigma^2));
end

function Img = convolute(Image,kernel,winSize)
    windowLenght = winSize*2;
    imSize = size(Image);
    Image = padarray(Image,[winSize winSize]);
    Img = zeros(imSize);
    for i = 2:imSize(1)-1
        for j = 2:imSize(2)-1
            Temp = Image(i:i+windowLenght,j:j+windowLenght).*kernel;
            Img(i,j)=sum(Temp(:));
        end
    end
end
