function result = EdgeDetector(Image, Params)
%EDGEDETECTOR Function to locate edges in image
%   defined in attestation requirements

% choose filter
if Params.FilterType == 'Sobel'
    % DX = fspecial('sobel')';
    % DX = [1 2 1]'*[-1 0 1];
    % DY = DX';
    DX = imfilter([-1 0 1],[1 2 1]','full');
    DY = imfilter([1 2 1],[-1 0 1]','full');
elseif Params.FilterType == 'Prewitt'
    % DX = fspecial('prewitt')';
    % DX = [1 1 1]'*[-1 0 1];
    % DY = DX';
    DX = imfilter([-1 0 1],ones(3,1),'full');
    DY = imfilter([-1 0 1]',ones(1,3),'full');
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
ImageDxDy = ImageDx.*ImageDy;

% filter the results with a guassian filter
h1 = fspecial('gaussian', 6*Params.Sigma, 6*Params.Sigma);
ImageDx2Filt = imfilter(ImageDx2, h1, 'symmetric');
ImageDy2Filt = imfilter(ImageDy2, h1, 'symmetric');
ImageDxDyFilt = imfilter(ImageDxDy, h1, 'symmetric');

% calculate the EdgeFactor for each pixel
Mc = (ImageDx2Filt.*ImageDy2Filt) - (ImageDxDyFilt.^2) ...
    - (Params.k).*(ImageDx2Filt + ImageDy2Filt).^2;

% set border pixels to zero
Mc(:,end-Params.Border+1:end) = 0;
Mc(:,1:Params.Border) = 0;
Mc(end-Params.Border+1:end,:) = 0;
Mc(1:Params.Border,:) = 0;

% apply maximum region filtering
%MFmax = ordfilt2(Mc, median(((Params.Border).^2)), ones(Params.Border));
MFmax = ordfilt2( ...
    Mc, ...
    numel(ones((2*Params.Border+1))), ...
    ones(2*Params.Border+1, 2*Params.Border+1));

% locate the local maxima 
LOCmax = Mc.*(Mc == MFmax);

% extract only a given number of occurances
x = unique(LOCmax)';
sorted = sort(x, 'descend');
LOCmax = (LOCmax >= sorted(Params.nBest));

% declare the result
result = LOCmax;

end