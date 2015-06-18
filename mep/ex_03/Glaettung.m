clear 'all';
close 'all';

%read image
Image = imread('..\ex_01\London.png');

%plot the image
figure(1);
subplot(2,2,1);
imshow(Image);
title('Original');

%apply a filter of size 2x2
h1 = fspecial('average', [2 2]);
Image1 = imfilter(Image, h1, 'symmetric');
%plot 
subplot(2,2,2);
imshow(Image1);
title('2 x 2 Filter');

%apply a filter of size 4x4
h2 = fspecial('average', [4 4]);
Image2 = imfilter(Image, h2, 'symmetric');
%plot
subplot(2,2,3);
imshow(Image2);
title('4 x 4 Filter');

%apply a filter of size 8x8
h3 = fspecial('average', [8 8]);
Image3 = imfilter(Image, h3, 'symmetric');
%plot
subplot(2,2,4);
imshow(Image3);
title('8 x 8 Filter');

figure(2);hold on
plot(Image(200,:), 'bo-');
xlabel('x-Wert (Zeile 200)');
ylabel('Grauwert');
plot(Image1(200,:), 'r-');
plot(Image2(200,:), 'g-');
plot(Image3(200,:), 'c-');
legend('Original', '2 x 2 Filter', '4 x 4 Filter', '8 x 8 Filter');