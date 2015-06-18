clear 'all'
close 'all';

%read image
Image = imread('..\ex_01\London.png');
%transform to double to once and for all
Image = double(Image);

%plot the image
figure(1);
subplot(1,3,1);
imshow(uint8(Image));
title('Original');

%choose the filters %??????
Sobel = 1;
if Sobel == 1
    DX = [-1 0 1; -2 0 2; -1 0 1];
    DY = DX';
else
    DX = [1];
    DY = [1];
end

%apply the DX and DY filter
ImageDx = imfilter(Image, DX);
ImageDy = imfilter(Image, DY);

%plot 
subplot(1,3,2);
imshow(ImageDx, []);
title('dI/dx');
subplot(1,3,3);
imshow(ImageDy, []);
title('dI/dy');

figure(2);
imshow(sqrt(ImageDx.^2 + ImageDy.^2), []);