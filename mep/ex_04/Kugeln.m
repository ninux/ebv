clear 'all'
close 'all';

Cmap = colormap(jet);
Cmap(1,:) = 0;

%read image
Image = imread('kugeln.png');

%plot the image
figure(1);
subplot(2,2,1);
imshow(Image);
title('Original');

%apply threshold opertion
ImageThr = Image < 147;

%plot 
subplot(2,2,2);
imshow(ImageThr, [0 1]);
title('Threshold');

%define the structure element ????
%StrucElem = ones(6,6);
StrucElem = strel('disk', 3, 0);

%do a closure ????
ImageClose = imclose(ImageThr, StrucElem);

%plot 
subplot(2,2,3);
imshow(ImageClose);
title('Closure');

StrucElem = strel('disk', 20, 0); %?????
%do erosions ??????
ImageErode = imerode(ImageClose, StrucElem);
%plot 
subplot(2,2,4);
imshow(ImageErode);
title('Erosion');

[LImage, Num] = bwlabel(ImageErode);

figure(2);
imshow(LImage, []);
title(strcat('found ', num2str(Num), ' objects.'));