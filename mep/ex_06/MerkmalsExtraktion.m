clear 'all';
close 'all';

%we create a simple synthetic image
Image = uint8(zeros(13,12));

%object 1
Image(2,10:11) = 255;
Image(3,9:11) = 255;
Image(4,8:10) = 255;
Image(5,7:9) = 255;
Image(6,7:8) = 255;

%object 2
Image(7,2) = 255;
Image(7,4:5) = 255;
Image(8,2) = 255;
Image(8,4:5) = 255;
Image(9,2:5) = 255;
Image(10,2:5) = 255;

%object 3
Image(9,9:11) = 255;
Image(10,9) = 255;
Image(10,11) = 255;
Image(11,9) = 255;
Image(11,11) = 255;
Image(12,9:11) = 255;

%plot it
figure(1)
subplot(2,3,1)
imshow(Image)

%do labeling (use 8 neighbors, the default)
[LabelImage, NumberLabels] = bwlabel(Image);

%do feature extraction 
Prop = regionprops(LabelImage,...
    'Area','Centroid','ConvexHull','Orientation','BoundingBox');
%the result is the structure array Prop, with NumLabels x 1 entries 

%plot the result
subplot(2,3,2)
imshow(LabelImage, []);

for Ind=1:size(Prop,1) 
    Cent=Prop(Ind).Centroid;
    Area=Prop(Ind).Area;
    X=Cent(1);Y=Cent(2);
    text(X-1,Y+2, sprintf('area = %d', Area), 'BackgroundColor',[.8 .8 .8]);        
end
title('area');

subplot(2,3,3);
imshow(LabelImage, []);
%plot center of mass using a cross (line) or a rectangle ??????????????
for Ind=1:size(Prop,1) 
    Cent=Prop(Ind).Centroid;
    Area=Prop(Ind).Area;
    X=Cent(1);Y=Cent(2);
    line([X-1 X+1], [Y-1 Y+1], 'LineWidth', 2, 'Color',[1 0 0]);
    line([X+1 X-1], [Y-1 Y+1], 'LineWidth', 2, 'Color',[1 0 0]);  
    text(X-1,Y+2, sprintf('cm = [%.1f %.1f]', X, Y), 'BackgroundColor',[.8 .8 .8]); 
end
title('center of mass');

subplot(2,3,4)
imshow(LabelImage, []);
%plot convex hull using line ???????????????
for Ind=1:size(Prop,1) 
    ConvH = Prop(Ind).ConvexHull;
    line(ConvH(:,1), ConvH(:,2), 'LineWidth', 2, 'Color', [1 0 0]);       
end
title('convex hull');

subplot(2,3,5)
imshow(LabelImage, []);
%draw a line through the centroid with given orientation ?????????????
for Ind=1:size(Prop,1) 
    Ang = Prop(Ind).Orientation;
    Cent=Prop(Ind).Centroid;
    X = Cent(1);
    Y = Cent(2);
    z0 = (X + i*Y) - 3*exp(-i*Ang*pi/180);
    z1 = (X + i*Y) + 3*exp(-i*Ang*pi/180);
    line([real(z0) real(z1)], [imag(z0) imag(z1)], 'LineWidth', 2, 'Color', [1 0 0]);       
end
title('orientation');

subplot(2,3,6)
imshow(LabelImage, []);
%construct the bounding box using line or rectangle ?????????????????
for Ind=1:size(Prop,1) 
    BBox = Prop(Ind).BoundingBox;
    Cent=Prop(Ind).Centroid;
    X = Cent(1);
    Y = Cent(2);
    rectangle('Position', BBox, 'LineWidth', 2, 'EdgeColor',[1 0 0]);
end
title('bounding box');
