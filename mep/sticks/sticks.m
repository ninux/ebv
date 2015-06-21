clear all; close all; imtool close all;

image = imread('ImageSticks.png');

figure(1);
imshow(image);
title('original Image');
lvl = graythresh(image);
imbw = im2bw(image,lvl);
figure(2);imshow(imbw);
ImageMedian = ordfilt2(imbw, 5, ones(4,4));


imgauss = imfilter(ImageMedian,fspecial('gaussian',[15 15],0.5));

figure(2);imshow(imgauss);


elem = ones(30,1);
elem2 = ones(120,10);
count = 0;
figure(10);imshow(image);hold on;
for ind1 = 1:18
    imgopen = imopen(ImageMedian,imrotate(elem,ind1 * 10));
    imgclose = imclose(imgopen,imrotate(elem2,ind1 * 10));
    props = regionprops(imgclose,'Area','Centroid','Orientation');
    for Ind = 1:length(props)
        if props(Ind).Area > 120
            Ang = props(Ind).Orientation;
            Cent=props(Ind).Centroid;
            X = Cent(1);
            Y = Cent(2);
            z0 = (X + i*Y) - 20*exp(-i*Ang*pi/180);
            z1 = (X + i*Y) + 20*exp(-i*Ang*pi/180);
            line([real(z0) real(z1)], [imag(z0) imag(z1)], 'LineWidth', 4, 'Color', [0 1 0]);
        count = count+1;
        end
    end
  %  figure(4);subplot(6,4,ind1);imshow(imgclose);
end
count
% Detect the edges, the result is a binary image
% EdgeCanny = edge(imgauss, 'canny', [0 0.1], 1);
% %plot it
% figure(3)
% imshow(EdgeCanny, []);
% title('Canny edge detection');
%
% [Hough, Alpha, Rho] = hough(imgauss,'RhoResolution', 2,'Theta',-90:2:89.5);
% figure(2)
% imshow(mat2gray(Hough));
% colormap('hot');
% xlabel('Alpha');
% ylabel('Rho')
% title('Hough Accumulator');
%
% % Find at most 5 peaks with threshold 15 and minimim distance of 15, 15
% % pixel
% NumPeaks = 1000;
% HoughPeaks = houghpeaks(Hough, NumPeaks,'Threshold',20,'NHoodSize',[41,41]);
%
% % Find the lines that correspond to the peaks; fill gabs of 15 pixel and
% % suppress all (merged lines) that have a length less than 30 pixel
% Lines = houghlines(EdgeCanny, Alpha, Rho, HoughPeaks, 'FillGap', 15, 'MinLength', 50);
% figure(4)
% imshow(image);
% title('original image with hough lines');
% hold on;
%
% for k = 1:length(Lines)
%     XY = [Lines(k).point1; Lines(k).point2];
%     line(XY(:,1),XY(:,2),'LineWidth',2,'Color','blue');
%     XY = (Lines(k).point1+Lines(k).point2)/2;
%     TheText = sprintf('rho = %d, alpha = %d', Lines(k).rho, Lines(k).theta);
%    % text(XY(1), XY(2), TheText, 'BackgroundColor',[.7 .7 .7]);
% end