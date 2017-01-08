function testPictures()
    picFolder   = 'faces/';
    logFile     = 'logOutput.txt';
    results     = struct();
    
    clearTextFile(logFile);
    [picPaths, picCount] = scanFolder4Pics(picFolder);
    
    
    for i = 1:picCount
        pic = picPaths{i};

        field = strrep(pic,'.','');
        field = strrep(field,'/','');
        field = strrep(field,'\','');
        
        value = {[0 0 0], pic};
        results = setfield(results, strcat(field), value);
    end
    
    fields = fieldnames(results);
    
    for i = 1:picCount
        disp(strcat('Image',num2str(i)))
        try
            [gender, percentage] = augenBraue(results.(fields{i}){2}, logFile);        
            if gender == 'm'
                results.(fields{i}){1}(1) = getP(results.(fields{i}){1}(1), percentage);
            elseif gender == 'w'
                results.(fields{i}){1}(2) = getP(results.(fields{i}){1}(2), percentage);
            elseif gender == 'u'
                results.(fields{i}){1}(3) = getP(results.(fields{i}){1}(3), percentage);
            end
        catch exception
           disp(getReport(exception))
           %augen braun fehler 
        end
        
        try
            [gender, percentage] = lipsdetection(results.(fields{i}){2});
            if gender == 'm'
                results.(fields{i}){1}(1) = getP(results.(fields{i}){1}(1), percentage);
            elseif gender == 'w'
                results.(fields{i}){1}(2) = getP(results.(fields{i}){1}(2), percentage);
            elseif gender == 'u'
                results.(fields{i}){1}(3) = getP(results.(fields{i}){1}(3), percentage);
            end 
        catch exception
            disp(getReport(exception))
            % fehler
        end
        [xDim,yDim,~] = size(results.(fields{i}){2});
        BinMask = zeros(xDim,yDim);
        try
            % feature bart
            [gender, BinMask] = beardRecognition(results.(fields{i}){2});
            if gender == 'm'
                results.(fields{i}){1}(1) = getP(results.(fields{i}){1}(1), percentage);
            elseif gender == 'w'
                results.(fields{i}){1}(2) = getP(results.(fields{i}){1}(2), percentage);
            elseif gender == 'u'
                results.(fields{i}){1}(3) = getP(results.(fields{i}){1}(3), percentage);
            end
        catch exception
           disp(getReport(exception))
            % fehler
        end
        
        try
            % feature kinn
        catch exception
            disp(getReport(exception))
            % fehler
        end
        
        try
            measurements = regionprops(Binmask, 'BoundingBox', 'Area');
    
            %Setup loop seaching for the biggest area of the found regions
            mainRegion = measurements(1);
            if ndims(measurements)/2 > 1
                for regionCnt = 2:ndims(measurements)/2
                    if(measurements(regionCnt*2).Area > mainRegion.Area)
                        mainRegion = measurements(regionCnt);
                    end
                end
            end
            
            [gender, percentage] = hair(results.(fields{i}){2},mainRegion.BoundingBox);
            if gender == 'm'
                results.(fields{i}){1}(1) = getP(results.(fields{i}){1}(1), percentage);
            elseif gender == 'w'
                results.(fields{i}){1}(2) = getP(results.(fields{i}){1}(2), percentage);
            elseif gender == 'u'
                results.(fields{i}){1}(3) = getP(results.(fields{i}){1}(3), percentage);
            end 
        catch exception
            disp(getReport(exception))
            % fehler
        end
        
    end
    
end

function [r] = getP(already, addition)
    if addition == 0
        r = already;
    elseif already == 0;
        r = addition;
    else
        r = already * addition;
    end;
end

function clearTextFile(textFile)
    fileID = fopen(textFile,'w');
    fclose(fileID);
end