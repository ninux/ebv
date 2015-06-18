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