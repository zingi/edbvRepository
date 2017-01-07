image_original = imread('zombie-orizinal.jpg');
lips_gender = lipsdetection(image_original);
image_original = imresize(image_original,[448 NaN]);

[height, width, dim] = size(image_original);

figure, imshow(image_original)
hold on
positionX=50;
positionY=50;
rectangle('Position', [positionX, positionY, width-positionY*2, height-positionX*2], 'EdgeColor','r', 'LineWidth', 3)
text(width-positionY*2-40, positionY-14, lips_gender,'Color','r','FontSize', 25);

