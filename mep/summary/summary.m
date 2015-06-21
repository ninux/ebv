% clear the complete environment
clear 'all';
close 'all';

%%%%%%%%%%

% read image
Image = imread('image.png');

% convert image to double values
Image = double(Image);

% plot image
imshow(Image);

% plot image with scaled range ( [] = 0-255 )
imshow(ImageGauss, []);

% get size of image
[Sy,Sx] = size(Image);

% draw a line on image (zero is at upper left corner for x and y)
line([x_left x_right], [y_left y_right]);
line([x_l x_r], [y_l y_r], 'LineWidth',1,'Color',[1 0 0]);

% round down to integer value
int_value = floor(float_value);

% reduce resolution for gray values
% to reduce 2 bit chose n = m^2 = 2^2 = 4
% to reduce 3 bit chose n = m^2 = 2^3 = 8
% to reduce 4 bit chose n = m^2 = 2^4 = 16
% ...
reduced_image = floor(Image/n)*n;

% reduce rasterization (pixel resolution)
??? (Seite 13/102)

%%%%%%%%%%

% get histogram values
[Count, Value] = imhist(Image);

% plot absolute histogramm
plot(Value, Count, 'bo-');

% plot relative histogramm
Relative_Count = Count/numel(Image);   % numel(x) = number of elements in x
plot(Relative_Cont, 'bo-');

% plot cumulative histogramm
Cumulative_Count = cumsum(Relative_Count);
plot(Cumulative_Count, 'bo-');

%%%%%%%%%%

% look up table

% define inverse LUT
LUT_Inv = uint8([255:-1:0]);

% define bright LUT
LUT_Bright = uint8([0:255].*2);

% apply LUT
ImageInvert = intlut(Image,LUT_Inv);
ImageBright = intlut(Image,LUT_Bright);

%%%%%%%%%%

% define a filter
f = fspecial('average', [4 4]);
% apply the filter
Image_f = imfilter(Image, f, 'symmetric');

% create a separated sobel filter
DX = [-1 0 1; -2 0 2; -1 0 1];
DY = DX';
% alternative: MySobelFilter = fspecial('sobel');
% apply the sobel X and Y filter separately
ImageDx = imfilter(Image, DX);
ImageDy = imfilter(Image, DY);

% calculate the norm of the derviative
ImageDr = sqrt(ImageDx.^2 + ImageDy.^2);
%determine the angle (atan2 gives back the whole interval ]-pi , pi[ )
Angle = pi+atan2(ImageDy, ImageDx);

%%%%%%%%%%

% apply a median filter; 3x3 is enough because noise is only one pixel wide
ImageMedian =  ordfilt2(ImageNoise, 13, ones(5));

% apply a low pass gaussian filter
GaussM = [1 2 1; 2 4 2; 1 2 1]/16;
ImageGauss = imfilter(ImageNoise, GaussM);

%%%%%%%%%%

% allpy structure element for dilation
Image_Dilation = imdilate(Image, StructureElement);

% do a dilation 
ImageDil = imdilate(Image, StrucElem);
ImageDil = 255*ImageDil;
ImageDil(Image ~= 0) = 128;

% do an erosion 
StrucElem = flipud(flipud(StrucElem'));
ImageErode = imerode(Image, StrucElem);
Help = 255*ImageErode;
Help(Image ~= ImageErode) = 128;

% do a closure
ImageClose = imclose(ImageThr, StrucElem);

% create structure element
se1 = strel('square',11);   % 11-by-11 square
se2 = strel('line',10,45);  % line, length 10, angle 45 degrees
se3 = strel('disk',15);     % disk, radius 15
se4 = strel('ball',15,5);   % ball, radius 15, height 5

%%%%%%%%%

%do labeling (bwlabel uses 8 neighbors by default, bwlabel(ImageClose, 4) for 4 neighbors)
[LabelImage, NumberLabels] = bwlabel(ImageClose);

%do region labeling
% see: http://ch.mathworks.com/help/images/ref/regionprops.html
    Prop = regionprops(LabelImage,  'Area', ... % Area
                                    'Centroid', ... % Center of mass
                                    'ConvexHull', ... % Convex Hull
                                    'Orientation', ... % angle
                                    'Perimeter', ... % Perimeter
                                    'BoundingBox'); % Bounding Box

    
%%%%%%%%%%

% draw angle orientation through object of interest
Ang = Prop(Ind).Orientation;
Cent=Prop(Ind).Centroid;
X = Cent(1);
Y = Cent(2);
z0 = (X + i*Y) - 3*exp(-i*Ang*pi/180);
z1 = (X + i*Y) + 3*exp(-i*Ang*pi/180);
line([real(z0) real(z1)], [imag(z0) imag(z1)], 'LineWidth', 2, 'Color', [1 0 0]);       

% draw convex hull
ConvH = Prop(Ind).ConvexHull;
line(ConvH(:,1), ConvH(:,2), 'LineWidth', 2, 'Color', [1 0 0]);

% draw bounding box
BBox = Prop(Ind).BoundingBox;
Cent=Prop(Ind).Centroid;
X = Cent(1);
Y = Cent(2);
rectangle('Position', BBox, 'LineWidth', 2, 'EdgeColor',[1 0 0]);

% draw center of mass
Cent=Prop(Ind).Centroid;
Area=Prop(Ind).Area;
X=Cent(1);Y=Cent(2);
line([X-1 X+1], [Y-1 Y+1], 'LineWidth', 2, 'Color',[1 0 0]);
line([X+1 X-1], [Y-1 Y+1], 'LineWidth', 2, 'Color',[1 0 0]);
text(X-1,Y+2, sprintf('cm = [%.1f %.1f]', X, Y), 'BackgroundColor',[.8 .8 .8]);


%%%%%%%%%%

% write variable in plot title
title(strcat(num2str(numel(Prop)), ' Elements found'));


%%%%%%%%%%

% Hough transformation, calculate the accumulator Hough
[Hough, Alpha, Rho] = hough(EdgeCanny);
figure(2)
imshow(mat2gray(Hough));
colormap('hot');
xlabel('Alpha');
ylabel('Rho')
title('Hough Accumulator');

% Find at most 5 peaks with threshold 15 and minimim distance of 15, 15
% pixel
NumPeaks = 5;
HoughPeaks = houghpeaks(Hough, NumPeaks, 'Threshold', 15, 'NHoodSize', [15 15]);

% Find the lines that correspond to the peaks; fill gabs of 15 pixel and
% suppress all (merged lines) that have a length less than 30 pixel
Lines = houghlines(EdgeCanny, Alpha, Rho, HoughPeaks, 'FillGap', 15, 'MinLength', 30);
