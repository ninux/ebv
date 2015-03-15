clear 'all';
close 'all';

%read image
Image = imread('London.png');

%plot the image
figure(1);
subplot(2,2,1);
imshow(Image);
title('London.png');

%get histogram values
[Count, Value] = imhist(Image);
%plot them
subplot(2,2,2);
plot(Value, Count, 'bo-');
xlabel('gray value');
ylabel('absolute frequency')

%relative and cumulative frequency
subplot(2,2,3);
rel_count = Count/numel(Image);
plot(rel_count, 'bo-');
xlabel('gray value');
ylabel('relative frequency');

subplot(2,2,4);
cum_count = cumsum(rel_count);
plot(cum_count, 'bo-');
xlabel('gray value');
ylabel('cumulative frequency');
