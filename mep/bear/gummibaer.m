clear all; close all; imtool close all;

image = imread('gummibaer.jpg');

imycbcr = rgb2ycbcr(image);
imcb = double(imycbcr(:,:,2));
imcr = double(imycbcr(:,:,3));

ThreshBkg = [132 124];
ThreshWhite = [120 128];
ThreshYellow = [40 140];
ThreshOrange1 = [45 165];
ThreshOrange2 = [70 205];
ThreshRed = [110 185];
ThreshGreen = [90 120];
radius = 8;

imBkg = (imcb-ThreshBkg(1)).^2+(imcr-ThreshBkg(2)).^2 < radius.^2;

imbkgcopen = imopen(~imBkg,strel('disk',5));
imbkgclose = imclose(imbkgcopen,strel('disk',8));

figure(1);
subplot(3,3,1);
imshow(imbkgclose);
title('Baers without Background');

props = regionprops(imbkgclose,'Centroid','BoundingBox','Area');
subplot(3,3,4:9);
imshow(image);
hold on;
title('Masspoint and Boundingbox');

for ind2 = 1:length(props)
    if props(ind2).Area > 200
        center = props(ind2).Centroid;
        line([center(1)-7 center(1)+7], [center(2) center(2)],'LineWidth',1,'Color',[0 0 0]);
        line([center(1) center(1)], [center(2)-7 center(2)+7],'LineWidth',1,'Color',[0 0 0]);
        rectangle('position',props(ind2).BoundingBox, 'EdgeColor', 'green');
    end
end

% Foreground
Red = image(:,:,1);
Green = image(:,:,2);
Blue=image(:,:,3);

Red(imbkgclose==0)   = 1;
Green(imbkgclose==0) = 1;
Blue(imbkgclose==0)  = 1;

Foreground(:,:,1) = double(Red);
Foreground(:,:,2) = double(Green);
Foreground(:,:,3) = double(Blue);

Foreground = uint8(Foreground);

Foreycbcr = rgb2ycbcr(Foreground);
Forecb = double(Foreycbcr(:,:,2));
Forecr = double(Foreycbcr(:,:,3));

imWhite = (imcb-ThreshWhite(1)).^2+(imcr-ThreshWhite(2)).^2 < (radius).^2;
imWhite = imopen(imWhite,strel('disk',10));
imWhite = imclose(imWhite,strel('disk',5));

imYellow = (imcb-ThreshYellow(1)).^2+(imcr-ThreshYellow(2)).^2 < (radius).^2;
imYellow = imclose(imYellow,strel('disk',10));

imOrange1 = (imcb-ThreshOrange1(1)).^2+(imcr-ThreshOrange1(2)).^2 < (radius+7).^2;
imOrange1 = imopen(imOrange1,strel('disk',5));
imOrange1 = imclose(imOrange1,strel('disk',50));

imOrange2 = (imcb-ThreshOrange2(1)).^2+(imcr-ThreshOrange2(2)).^2 < (radius).^2;
imOrange2 = imclose(imOrange2,strel('disk',70));

imRed = (imcb-ThreshRed(1)).^2+(imcr-ThreshRed(2)).^2 < (radius+2).^2;
imRed = imclose(imopen((imRed&~imOrange2),strel('disk',5)),strel('disk',100));

imGreen = (imcb-ThreshGreen(1)).^2+(imcr-ThreshGreen(2)).^2 < (radius).^2;
imGreen = imclose(imGreen,strel('disk',20));

propsWhite   = regionprops(imWhite,'Centroid','Area','BoundingBox');
propsYellow  = regionprops(imYellow,'Centroid','Area','BoundingBox');
probsOrange1 = regionprops(imOrange1,'Centroid','Area','BoundingBox');
probsOrange2 = regionprops(imOrange2,'Centroid','Area','BoundingBox');
propsRed     = regionprops(imRed,'Centroid','Area','BoundingBox');
propsGreen   = regionprops(imGreen,'Centroid','Area','BoundingBox');

countWhite = 0;
countYellow = 0;
countOrange1 = 0;
countOrange2 = 0;
countRed = 0;
countGreen = 0;

for indW = 1:length(propsWhite)
    if propsWhite(indW).Area > 800
        center = propsWhite(indW).Centroid;
        text(center(1)+10,center(2)+20, 'White', 'BackgroundColor',[.8 .8 .8]);
        countWhite = countWhite +1;
    end
end
for indY = 1:length(propsYellow)
    if propsYellow(indY).Area > 800
        center = propsYellow(indY).Centroid;
        text(center(1)+10,center(2)+20, 'Yellow', 'BackgroundColor',[.8 .8 .8]);
        countYellow = countYellow +1;
    end
end
for indO1 = 1:length(probsOrange1)
    if probsOrange1(indO1).Area > 800
        center = probsOrange1(indO1).Centroid;
        text(center(1)+10,center(2)+20, 'Orange1', 'BackgroundColor',[.8 .8 .8]);
        countOrange1 = countOrange1 +1;
    end
end
for indO2 = 1:length(probsOrange2)
    if probsOrange2(indO2).Area > 800
        center = probsOrange2(indO2).Centroid;
        text(center(1)+10,center(2)+20, 'Orange2', 'BackgroundColor',[.8 .8 .8]);
        countOrange2 = countOrange2 +1;
    end
end
for indR = 1:length(propsRed)
    if propsRed(indR).Area > 800
        center = propsRed(indR).Centroid;
        text(center(1)+10,center(2)+20, 'Red', 'BackgroundColor',[.8 .8 .8]);
        countRed = countRed +1;
    end
end
for indG = 1:length(propsGreen)
    if propsGreen(indG).Area > 800
        center = propsGreen(indG).Centroid;
        text(center(1)+10,center(2)+20, 'Green', 'BackgroundColor',[.8 .8 .8]);
        countGreen = countGreen +1;
    end
end
