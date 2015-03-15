function result = EdgeDetector(Image, Params)
%EDGEDETECTOR Function to locate edges in image
%   defined in attestation requirements

% choose filter
if Params.FilterType == 'Sobel'
    DX = fspecial('sobel')';
    % DX = [1 2 1]'*[-1 0 1];
    DY = DX';
elseif Params.FilterType == 'Prewitt'
    DX = fspecial('prewitt')';
    % DX = [1 1 1]'*[-1 0 1];
    DY = DX';
else
    DX = [1];
    DY = [1];
end

% apply filter
ImageDx = imfilter(Image, DX);
ImageDy = imfilter(Image, DY);

% calculate the quadratic values & the product of the partial devivatives
ImageDx2 = ImageDx.^2;
ImageDy2 = ImageDy.^2;
ImageDxDy = ImageDx.^ImageDy;

% filter the results with a guassian filter
h1 = fspecial('gaussian', 6*Params.Sigma, 6*Params.Sigma);
ImageDx2Filt = imfilter(ImageDx2, h1, 'symmetric');
ImageDy2Filt = imfilter(ImageDy2, h1, 'symmetric');
ImageDxDyFilt = imfilter(ImageDxDy, h1, 'symmetric');

% calculate the EdgeFactor for each pixel
Mc = (ImageDx2Filt.*ImageDy2Filt) - (ImageDxDyFilt.^2) ...
    - (Params.k).*(ImageDx2Filt + ImageDy2Filt).^2;

% set border pixels to zero
% ??? -> see attestation requirement 6

% apply maximum region filtering
%MFmax = ordfilt2(Mc, median(((Params.Border).^2)), ones(Params.Border));
MFmax = ordfilt2( ...
    Mc, ...
    median((Params.Border).^2), ...
    ones(2*Params.Border+1, 2*Params.Border+1));

% locate the local maxima 
LOCmax = (Mc == MFmax);

% extract only a given number of occurances
% ??? -> see attestation requirement 8

% declare the result
result = LOCmax;

end