clear 'all'
close 'all';

%read image
Image = imread('..\ex_01\London.png');
%transform to double to once and for all
Image = double(Image);

%plot the image
figure(1);
subplot(1,2,1);
imshow(uint8(Image));
title('Original');

%choose the filters
Sobel = 1;
if Sobel == 1
	DX = [1 2 1]'*[-1 0 1];
    DY = DX';
	%there exists also inbuild Matlab function for filter kernels
    %DX = fspecial('sobel')';
else
    DX = [1 1 1]'*[-1 0 1];
    DY = DX';
	%there exists also inbuild Matlab function for filter kernels
    %DX = fspecial('prewitt')';
end

%apply the DX and DY filter
ImageDx = imfilter(Image, DX);
ImageDy = imfilter(Image, DY);

%calculate the norm of the derviative ??????????
ImageDr = sqrt(ImageDx.^2 + ImageDy.^2);
%plot it
subplot(1,2,2);
imshow(ImageDr, []);
title('dI/dr');

%determine the angle (atan2 gives back the whole interval ]-pi , pi[ )
Angle = pi+atan2(ImageDy, ImageDx);
%use only those values that are above a given threshold
%Angle(????????) = 0;
%plot it
check = ImageDr > 70;
Angle = check.*Angle;
figure(2)
imshow(Angle, []);
map=colormap(jet);
map(1,:) = 0;
colormap(map)
title('angle, [0, 2\pi]');
colorbar;