clear 'all';
close 'all';

%read image
Image = imread('..\ex_01\London.png');
 
%plot the image 
figure(1);
subplot(1,2,1);
imshow(Image);
title('original image');

%plot histogram
subplot(1,2,2);
imhist(Image);
title('histogram');

%LUT for inverse image
LUT_Inv = uint8([255:-1:0]);%????????????????

%apply LUT
ImageInv = intlut(Image, LUT_Inv);

%plot the image 
figure(2);subplot(1,2,1);
imshow(ImageInv);
title('inverse image');

%plot histogram
subplot(1,2,2);
imhist(ImageInv);
title('histogram');

%create a LUT which enhances dark parts in image and show results
LUT_bright = uint8([0:255].*2);

ImageBright = intlut(Image, LUT_bright);

figure(3);
subplot(1,2,1);
imshow(ImageBright);
title('Image - bright');

subplot(1,2,2);
imhist(ImageBright);
title('histogram');
