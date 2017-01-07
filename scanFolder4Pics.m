function [picPaths, picCount] = scanFolder4Pics(folder)
    fileNames   = {};
    picPaths    = {};
    picCount    = 0;
    files       = dir(folder);
    fileCount   = size(files,1);
    validExt    = {'.jpg','.jpeg','.png'};
    
    for f=1:fileCount
        file        = files(f);
        fileNames   = [fileNames file.name];
    end
    
    extCount    = size(validExt,2);

    for f=1:fileCount
        for ext=1:extCount
            if checkExt(fileNames{f}, validExt{ext})
                picPaths = [picPaths strcat(folder,fileNames{f})];
                picCount = picCount+1;
                break;
            end
        end 
    end
    
end

function [result] = checkExt(file, ext)
    fLength = size(file,2);
    eLength = size(ext,2);
    result  = true;
     
    if fLength >= eLength
        for c = eLength:-1:1
            if( file(fLength) ~= ext(c) )
                result = false;
                break;
            end
            fLength = fLength-1;
        end
    else
        result = false;
    end
end


