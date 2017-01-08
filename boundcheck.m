%Check if imagepoint is inside specified dimensions
function Out = boundcheck(pointX,pointY,dimX,dimY)
    if pointX < 1 || pointY < 1 || pointX > dimX || pointY > dimY
        Out = false;
    else
        Out = true;
    end
end