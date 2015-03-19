% load the image
ImageRaw = imread('images\img_0000.jpg');
Image = double(ImageRaw);

% define parameters as struct
Params = struct();
Params.FilterType = 'Sobel';
Params.Sigma = 2;
Params.k = 0.04;
Params.Border = 6;
Params.nBest = 100;

% run edge detector function
result = EdgeDetector(Image, Params);

figure(1);
imshow(Image, []);

% plot the reuslts
% figure(2);
[rows, cols] = find(result);
for i = 1:length(rows)
    BBox = [cols(i)-5 rows(i)-5 10 10];
    rectangle('Position', BBox, 'Edgecolor', [1 0 0], 'Curvature',[1,1]);
end
