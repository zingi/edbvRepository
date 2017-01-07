
function [sex, percentage] = augenBraue(dateiPfad, logOutput)
    %datei               = 'faces/iroy1.jpg';
    datei               = dateiPfad;
    
    bild                = imread(datei);
    [pathstr,name,ext]  = fileparts(datei);

    eyeDetector = vision.CascadeObjectDetector('EyePairSmall');
    bboxes      = step(eyeDetector, bild);

    firstRect   = bboxes(1,:);
    bboxesCount = size(bboxes,1);
    
    augenX      = firstRect(1);
    augenY      = firstRect(2);
    augenWidth  = firstRect(3);
    augenHeight = firstRect(4);
    
    if bboxesCount > 1  % falls f?lschlicherweise mehrere Augenboxen erkannt werden
       for b = 1:bboxesCount
           bbox = bboxes(b,:);
           if bbox(3) > augenWidth % box mit der gr??ten Breite = Augen (Annahme)
                augenX      = bbox(1);
                augenY      = bbox(2);
                augenWidth  = bbox(3);
                augenHeight = bbox(4);
           end 
       end
    end    

    viertlWidth = augenWidth / 4;

    k           = int16(augenX + viertlWidth);
    augeLinksX  = [k-50, k-40, k-30, k-20, k-10, k, k+10, k+20];
    augeOben    = augenY - (augenHeight);
    
    % bildEyes = insertObjectAnnotation(bild, 'rectangle', bboxes, 'a');  % d
    % figure, imshow(bildEyes);                                           % d

    edge_img = getEdgeImg(bild);
    RGB = bild;
    
    log = true;
    fileID = fopen(logOutput,'a');
    
    if log
        fprintf(fileID,'\n name: %s\n', name);
    end
    
    % for testing: which black-distance works best
    
%     for bd = 20:-1:5
%         [lineArray, yStartArray, yEndArray] = getLineArray(edge_img, RGB, bd, augeLinksX, augeOben, augenY, augenHeight);
%         
%         laAvgDeviation  = getLineArrayAverageDeviation(lineArray);
%         median          = getMedian(lineArray);
%         
%         ysaAvgDev       = getLineArrayAverageDeviation(yStartArray);
%         yeaAvgDev       = getLineArrayAverageDeviation(yEndArray);
%         
%         if log
%             fprintf(fileID,'bd: %f, \t avgAD: %f,\t ysaAD: %f,\t yeaAD: %f\n', bd, laAvgDeviation, ysaAvgDev, yeaAvgDev);
%         end
%     end
    
    bd = 6; % empirisch
    
    [lineArray, yStartArray, yEndArray] = getLineArray(edge_img, RGB, bd, augeLinksX, augeOben, augenY, augenHeight);
        
    laAvgDeviation  = getLineArrayAverageDeviation(lineArray);
    median          = getMedian(lineArray);

    ysaAvgDev       = getLineArrayAverageDeviation(yStartArray);
    yeaAvgDev       = getLineArrayAverageDeviation(yEndArray);

    % - - - 
    
    if yeaAvgDev <= 2
        percentage = 0.9;
        sex = 'm';
    elseif yeaAvgDev > 2 && yeaAvgDev < 3
        percentage = 0.6;
        sex = 'm';
    elseif yeaAvgDev >= 3 && yeaAvgDev < 5
        percentage = 0.5;
        sex = 'u';
    elseif yeaAvgDev >= 5 && yeaAvgDev < 7
        percentage = 0.75;
        sex = 'w';
    elseif yeaAvgDev > 7
        percentage = 0.9;
        sex = 'w';
    end
    
    % - - - 
    
    if log
        fprintf(fileID,'bd: %.1f, \t avgAD: %.1f,\t ysaAD: %.1f,\t yeaAD: %.1f, \t %s, \t %.2f\n', bd, laAvgDeviation, ysaAvgDev, yeaAvgDev, sex, percentage);
    end
        
    fclose(fileID);  
end

function [median] = getMedian(array)
    median  = -1;
    array   = sort(array);
    length  = size(array,2);
    
    if mod(length,2) == 0
        median = (array(length/2) + array((length/2)+1) ) / 2;
    else
        median = array((length+1) / 2);
    end
end

function [laAvgDeviaton] = getLineArrayAverageDeviation(lineArray)
    laAvg           = getLineArrayAverage(lineArray);
    laSize          = size(lineArray,2);
    laAvgDeviaton   = 0;
    
    for li = 1:laSize
        laAvgDeviaton = laAvgDeviaton + abs(lineArray(li)-laAvg);
    end
    laAvgDeviaton = laAvgDeviaton/laSize;
end

function [laAvg] = getLineArrayAverage(lineArray)
    laSize  = size(lineArray,2);
    laAvg   = 0;
    
    for li = 1:laSize
        laAvg = laAvg + lineArray(li);
    end 
    laAvg = laAvg/laSize;
end

function [lineArray, yStartArray, yEndArray] = getLineArray(kantenBild, farbBild, blackDistance, augeLinksX, augeOben, augenY, augenHeight)
    
    lineArray   = [];
    yStartArray = [];
    yEndArray   = [];
    
    for i = 1:size(augeLinksX,2)
        lineStart       = -1;
        lineEnd         = -1;
        foundStart      = false;
        %blackDistance   = 13; % zum automatisieren
        
        for y = augeOben:(augenY + augenHeight)
            
            if foundStart == true
                theEnd = true;
                for isBlack = y:y+blackDistance
                    if kantenBild(isBlack, augeLinksX(1, i)) == 1
                        theEnd = false;                        
                        break;
                    end 
                end
                
                if theEnd == true
                    lineEnd     = y;
                    yEndArray   = [yEndArray y];
                    
                    farbBild    = insertText(farbBild, [augeLinksX(1, i), lineStart-25], ...
                    (lineEnd - lineStart), 'FontSize',10); 
                
                    lineArray   = [lineArray (lineEnd - lineStart)];
                    
                    break;
                end
            end
            
            if lineStart ~= -1 && lineEnd == -1
                kantenBild(y, augeLinksX(1, i)) = 1;  % im Edge-Bild Sample-Line markieren
                
                farbBild(y, augeLinksX(1, i),:) = 255;   % im Farbbild Sample-Line markieren
                
            elseif (kantenBild(y, augeLinksX(1, i)) == 1 ) && not(foundStart)
                lineStart   = y;
                yStartArray = [yStartArray y];
                foundStart  = true;
            end
        end
    end
    
     % figure, imshow(kantenBild);      
     % figure, imshow(farbBild);      
end



function [result] = getEdgeImg(bild)
    %se = strel('disk',3);
    structuringElement = [  1,1,1,1,1;
                            1,1,1,1,1;
                            1,1,1,1,1;
                            1,1,1,1,1;
                            1,1,1,1,1 ];
    
    %bild = imclose(bild, structuringElement);                  %built-in function
    
    bild        = myImageClosing(bild, structuringElement);     %own function

    %bild = rgb2gray(bild);                                     %built-in funciton
    bild        = myColor2GrayImage(bild);                      %own function
    
    %figure, imshow(bild); % zeige grau-bild
    
    %edge_img = edge(bild,'Sobel');                             %built-in function
    
    edge_img    = aaronSobel(bild);                              %own function
    
    result      = edge_img;
end

function [result] = myImageClosing(bild, structuringElement)

    % Dilation, an jedem Bildpunkt von Bild das komplette
    % structuringElement einf?gen; 
    % den Bildpunkt auf das strukturierende Element ausdehnen (dilatieren)
    result = imdilate(bild,structuringElement,'notpacked',size(bild,1));
    
    % Erosion, passt das strukturierende Element vollst?ndig in die Menge?
    result = imerode(result,structuringElement,'notpacked',size(bild,1));

end

function [grayImage] = myColor2GrayImage(colorImage)

    [zeilen, spalten, anzahlFarbKanaele] = size(colorImage);
    
    if anzahlFarbKanaele == 3
        rot         = double(colorImage(:, :, 1));
        gruen       = double(colorImage(:, :, 2));
        blau        = double(colorImage(:, :, 3));
        
        % Recommendation ITU-R BT.601-7 (International Telecommunication Union)
        % https://www.itu.int/dms_pubrec/itu-r/rec/bt/R-REC-BT.601-7-201103-I!!PDF-E.pdf
        % <- Kapitel 2.5.1
        
        grayImage   = 0.299*double(rot) + 0.587*double(gruen) + 0.144*(blau);
        grayImage   = uint8(grayImage);
    else
        % besitzt das Bild nicht drei Farbkan?le, 
        % so ist es kein rgb-Bild
        grayImage = colorImage;
    end
    
end
