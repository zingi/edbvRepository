%Source of get_image_point function:
%https://de.mathworks.com/matlabcentral/newsreader/view_thread/322422
%Comment by Stephan Köhnen 10 Aug, 2016 12:16:03
function [loc] = get_image_point (I)
figure('name','Doubleclick to set location');imshow(I);
[c, r] = getpts(1);
loc = int32([c r]);
if size(loc)>1
    loc = [loc(1,1) loc(1,2)];
end
close all;
end