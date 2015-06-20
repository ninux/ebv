clear 'all';
close 'all';

figure(1);
hold on;

%should we use ycbcr
UseYCbCr = 0;

ImageCounter = 0;

if UseYCbCr ~= 1
    %define the colors to find
    %%% FrgCol = [200 200 80; 135 65 47];
    FrgCol = [255 0 0; 2 71 254];
    %the limit values, choose with imtools
    LimitVal = 40;
else
    FrgCol = [70 140; 100 160];
    %the limit values, choose with imtools
    LimitVal = 20;
end

%minimum required area
MinArea = 10;

% while 1 
    
    try
        %first we trigger the cgi script in order to have the leanXcam save
        %a new image
        %%% Image=imread('http://192.168.1.10/cgi-bin/cgi');
        %the return value will not be an image, so the call fails (-> catch)!!
    catch
        
    end
    %nevertheless the image is available (url works :-)
    % Image=imread('http://192.168.1.10/image.bmp');
    Image = imread('dots.png');
    % add noise
    Image = imnoise(Image, 'salt & pepper', 0.05);
    
    %Image =  ordfilt2(Image, 5, ones(3));
    
    imshow(Image);
    ImageCounter = ImageCounter+1;
    title(strcat('image index: ', num2str(ImageCounter)));
    
    if UseYCbCr ~= 1
        %convert to double for calculation
        Image = double(Image);

        %extract color planes
        Red = Image(:,:,1);
        Green = Image(:,:,2);
        Blue = Image(:,:,3);
        
        % filter small noise with median filter
        Red_filt =  ordfilt2(Red, 5, ones(3));
        Green_filt =  ordfilt2(Green, 5, ones(3));
        Blue_filt =  ordfilt2(Blue, 5, ones(3));
        
        % add noise
        %Red = imnoise(Red, 'salt & pepper', 0.05);
        %Green = imnoise(Green, 'salt & pepper', 0.05);
        %Blue = imnoise(Blue, 'salt & pepper', 0.05);

        IndexImg = zeros(size(Red));
        %loop over all colors
        for Ind1 = 1:size(FrgCol,1)
            %find the 2D indices of all pixel with distance smaller than LimitVal
            IndexImg = IndexImg | ( (Red-FrgCol(Ind1, 1)).^2+(Green-FrgCol(Ind1, 2)).^2+(Blue-FrgCol(Ind1, 3)).^2 < LimitVal.^2 );
            IndexImg_red = ( (Red-FrgCol(1, 1)).^2+(Green-FrgCol(1, 2)).^2+(Blue-FrgCol(1, 3)).^2 < LimitVal.^2 );
            IndexImg_blue = ( (Red-FrgCol(2, 1)).^2+(Green-FrgCol(2, 2)).^2+(Blue-FrgCol(2, 3)).^2 < LimitVal.^2 );
            %do some morphology
        end
    else
        Image = rgb2ycbcr(Image);
        %convert to double for calculation
        Image = double(Image);

        %extract color planes
        Y = Image(:,:,1);
        Cb = Image(:,:,2);
        Cr = Image(:,:,3);

        IndexImg = zeros(size(Y));
        %loop over all colors
        for Ind1 = 1:size(FrgCol,1)
            %find the 2D indices of all pixel with distance smaller than LimitVal
            IndexImg = IndexImg | ( (Cb-FrgCol(Ind1, 1)).^2+(Cr-FrgCol(Ind1, 2)).^2 < LimitVal.^2 );
            %do some morphology
        end
    end
    %do some morphology    
    ImageOpen = imopen(IndexImg, ones(3));
    ImageClose = imclose(ImageOpen, ones(6));
    %do region labeling
    Prop = regionprops(ImageClose,'Area','Centroid', 'BoundingBox');

    for Ind2 = 1:size(Prop,1) 
        %apply a minimum area condition
        if Prop(Ind2).Area > MinArea
            Cent=Prop(Ind2).Centroid; 
            BBox = Prop(Ind2).BoundingBox;
            X=Cent(1);Y=Cent(2);
            %construct the bounding box using line or rectangle
            rectangle('Position', BBox, 'EdgeColor',[0 1 0]);
            line([X-5 X+5], [Y-5 Y+5], 'LineWidth', 2, 'Color',[130 255 47]/255);
            line([X+5 X-5], [Y-5 Y+5], 'LineWidth', 2, 'Color',[27  255 137]/255);
        end  
    end
    title(strcat(num2str(numel(Prop)), ' Elements found'));
    
    % pause(0.2);
% end