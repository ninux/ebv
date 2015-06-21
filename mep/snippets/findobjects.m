clear 'all';
close 'all';

% load image
ImageOrig = imread('ImageSticks.png');
% ImageOrig = imnoise(ImageOrig, 'salt & pepper', 0.05);

% rgb to grayscale
ImageGS = rgb2gray(ImageOrig);

% median filter
ImageFilt = ordfilt2(ImageGS, 5, ones(3));

% binary
Threshold = 255*graythresh(ImageFilt);
ImageBin = ImageFilt > Threshold;

% canny filter
ImageCanny = edge(ImageBin, 'canny', [0 0.1], 1);

% hough transform
[Hough, Theta, Rho] = hough(ImageBin);

nop = 100;
HoughPeaks = houghpeaks(Hough, nop, 'Threshold', 6, 'NHoodSize', [39 39]);
HoughLines = houghlines(ImageBin, Theta, Rho, HoughPeaks);

% bw
ImageOpen = imopen(ImageBin, ones(3));
ImageClose = imclose(ImageOpen, ones(4));

[ImageBW noe] = bwlabel(ImageBin);

Props = regionprops(ImageOpen, 'Area', 'Centroid');

% show pic
figure(1);
subplot(2,2,1);
imshow(ImageOrig, []);
title('original');

subplot(2,2,2);
imshow(ImageFilt, []);
title('median filtered grayscale');

subplot(2,2,3);
imshow(ImageBin, []);
title('threshold & binary')

subplot(2,2,4);
imshow(ImageBW);
title(strcat(num2str(floor(size(HoughLines,2)/2)), ' Elements found by bwlabel'));