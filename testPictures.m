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
        
        try
            [sex, percentage] = augenBraue(results.(fields{i}){2}, logFile);        
            if sex == 'm'
                results.(fields{i}){1}(1) = getP(results.(fields{i}){1}(1), percentage);
            elseif sex == 'w'
                results.(fields{i}){1}(2) = getP(results.(fields{i}){1}(2), percentage);
            elseif sex == 'u'
                results.(fields{i}){1}(3) = getP(results.(fields{i}){1}(3), percentage);
            end
        catch
           %augen braun fehler 
        end
        
        % andere features testen
        
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