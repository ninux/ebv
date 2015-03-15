function [ edges ] = EdgeDetector( Image, Params )
%EDGEDETECTOR Function to locate edges in image
%   defined in attestation requirements

% convert image to double type
Image = double(Image);

% choose filter
if Sobel
    % DX = fspecial('sobel')';
    DX = [1 2 1]'*[-1 0 1];
    DY = DX';
    % 
else % prewitt
    % DX = fspecial('prewitt')';
    DX = [1 1 1]'*[-1 0 1];
    DY = DX';

% apply filter
ImageDx = imfilter(Image, DX);
ImageDy = imfilter(Image, DY);

edges = 

end