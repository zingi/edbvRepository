function testPictures()
    picFolder   = 'faces/';
    logFile     = 'logOutput.txt';
    resultFile  = 'resultOutput.txt';
    results     = struct();
    
    clearTextFile(logFile);
    clearTextFile(resultFile);
    writeResults = fopen(resultFile,'a');
    
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
        fprintf(writeResults,'\n bild: %s', results.(fields{i}){2});
        
        disp(strcat('Image',num2str(i)))
        currentImage = imread(results.(fields{i}){2});
        try
            disp('Exebrow detection')
            tic
            [gender, percentage] = augenBraue(results.(fields{i}){2}, logFile);        
            if gender == 'm'
                results.(fields{i}){1}(1) = getP(results.(fields{i}){1}(1), percentage);
            elseif gender == 'w'
                results.(fields{i}){1}(2) = getP(results.(fields{i}){1}(2), percentage);
            elseif gender == 'u'
                results.(fields{i}){1}(3) = getP(results.(fields{i}){1}(3), percentage);
            end
            toc
            
            fprintf(writeResults,'\n eyebrow: \t%s, \t%.2f', gender, percentage);
        catch exception
           disp(getReport(exception))
           %augen braun fehler 
        end
        
        try
            disp('Lip detection')
            tic
            [gender, percentage] = lipsdetection(currentImage);
            if gender == 'm'
                results.(fields{i}){1}(1) = getP(results.(fields{i}){1}(1), percentage);
            elseif gender == 'w'
                results.(fields{i}){1}(2) = getP(results.(fields{i}){1}(2), percentage);
            elseif gender == 'u'
                results.(fields{i}){1}(3) = getP(results.(fields{i}){1}(3), percentage);
            end 
            toc
            
            fprintf(writeResults,'\n lip: \t\t%s, \t%.2f', gender, percentage);
        catch exception
            disp(getReport(exception))
            % fehler
        end

        try
            %feature bart
            disp('beardRecognition')
            tic
            [gender] = beardRecognition(currentImage);
            if gender == 'm'
                results.(fields{i}){1}(1) = getP(results.(fields{i}){1}(1), percentage);
            elseif gender == 'w'
                results.(fields{i}){1}(2) = getP(results.(fields{i}){1}(2), percentage);
            elseif gender == 'u'
                results.(fields{i}){1}(3) = getP(results.(fields{i}){1}(3), percentage);
            end
            toc
            
            fprintf(writeResults,'\n beard: \t%s, \t%.2f', gender, percentage);
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
            disp('region Growing')
            tic
%             measurements = regionprops(Binmask, 'BoundingBox', 'Area');
%     
%             %Setup loop seaching for the biggest area of the found regions
%             mainRegion = measurements(1);
%             if ndims(measurements)/2 > 1
%                 for regionCnt = 2:ndims(measurements)/2
%                     if(measurements(regionCnt*2).Area > mainRegion.Area)
%                         mainRegion = measurements(regionCnt);
%                     end
%                 end
%             end
            %[gender, percentage] = hairDetection(results.(fields{i}){2});
            [gender, percentage] = hair(currentImage);
            if gender == 'm'
                results.(fields{i}){1}(1) = getP(results.(fields{i}){1}(1), percentage);
            elseif gender == 'w'
                results.(fields{i}){1}(2) = getP(results.(fields{i}){1}(2), percentage);
            elseif gender == 'u'
                results.(fields{i}){1}(3) = getP(results.(fields{i}){1}(3), percentage);
            end 
            toc
            
            fprintf(writeResults,'\n hair: \t\t%s, \t%.2f', gender, percentage);
        catch exception
            disp(getReport(exception))
            % fehler
        end
        
        
        fprintf(writeResults,'\n man: %.1f \t woman: %1.f \t undefined: %1.f \n\n', ...
            results.(fields{i}){1}(1), results.(fields{i}){1}(2), results.(fields{i}){1}(3) );
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