% reset environment
clear 'all';
close 'all';

% image sourcefile
ImageSource = 'Image_01.png';

% load image
ImageOrig = imread(ImageSource);

% convert to ycbcr space
ImageOrigYCbCr = rgb2ycbcr(ImageOrig);

% define the color space
UseYCbCr = 1;   % use ycbcr because it's a picture with light-issues

if UseYCbCr ~= 1
    %define the colors to find
    %%% FrgCol = [200 200 80; 135 65 47];
    %the limit values, choose with imtools
    LimitVal = 40;
else
    % check colors  (Cb and Cr) with the imagetool
    imtool(ImageOrigYCbCr);
    FrgCol = [
        66  156     % disk 1 (yellow)
        103 206     % disk 2 (red)
        119 139];   % stick
    %the limit values, choose with imtools
    LimitVal = 20;
end

% convert image to double
ImageOrigYCbCr = double(ImageOrigYCbCr);

%extract color planes
Y  = ImageOrigYCbCr(:,:,1);
Cb = ImageOrigYCbCr(:,:,2);
Cr = ImageOrigYCbCr(:,:,3);

    
    