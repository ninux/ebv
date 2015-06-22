% reset environment
clear 'all';
close 'all';

% reset environment
clear 'all';
close 'all';

% define a minimal area for objects
MinArea = 10;

Path = './Image_';

%read first image to index 0
Index = 1;
    
for Index = Index:10   
    
    % image sourcefile
    ImageSource = strcat(Path, sprintf('%02d', Index), '.png');
    
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
        % imtool(ImageOrigYCbCr);
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

    % define image size by a given plane
    IndexImg = zeros(size(Y));

    %loop over all colors
    for Ind1 = 1:size(FrgCol,1)
        %find the 2D indices of all pixel with distance smaller than LimitVal
        IndexImg = IndexImg | ( (Cb-FrgCol(Ind1, 1)).^2+(Cr-FrgCol(Ind1, 2)).^2 < LimitVal.^2 );
        % only for disk 1 (yellow)
        IndexImgDisk1 = ( (Cb-FrgCol(1, 1)).^2+(Cr-FrgCol(1, 2)).^2 < LimitVal.^2 );
        % only for disk 2 (red)
        IndexImgDisk2 = ( (Cb-FrgCol(2, 1)).^2+(Cr-FrgCol(2, 2)).^2 < LimitVal.^2 );
        % only for sticks 
        IndexImgStick = ( (Cb-FrgCol(3, 1)).^2+(Cr-FrgCol(3, 2)).^2 < LimitVal.^2 );
        %do some morphology
    end

    % define structutre element sizes for opening/closing
    StrElmOpen = 3;
    StrElmClose = 6;
    
    % specific structure elements
    seDiskOpen  = strel('disk',10);     % disk, radius 10

    % apply generic morphology 
    ImageOpen = imopen(IndexImg, ones(StrElmOpen));
    ImageOpenDisk1 = imopen(IndexImgDisk1, ones(StrElmOpen));
    ImageOpenDisk2 = imopen(IndexImgDisk2, ones(StrElmOpen));
    ImageOpenStick = imopen(IndexImgStick, ones(StrElmOpen));

    ImageClose = imclose(ImageOpen, ones(StrElmClose));
    ImageCloseDisk1 = imclose(ImageOpenDisk1, ones(StrElmClose));
    ImageCloseDisk2 = imclose(ImageOpenDisk2, ones(StrElmClose));
    ImageCloseStick = imclose(ImageOpenStick, ones(StrElmClose));

    % we could use disk and line structure elements for the morphology
    % but a test shows pretty good results with the generic structure 
    % elements as well so we try it with these first

    % try to split disks with same color
    IndexImgDisk1 = imerode(IndexImgDisk1, ones(3));
    IndexImgDisk2 = imerode(IndexImgDisk2, ones(3));
    
    % apply specific morphology (no closing needed here)
    ImageOpenDisk1 = imopen(IndexImgDisk1, seDiskOpen);
    ImageOpenDisk2 = imopen(IndexImgDisk2, seDiskOpen);
    
    % do region labeling
    PropDisk1 = regionprops(ImageOpenDisk1, ... % use ImageCloseDisk1 for generic morphology
        'Area', ...
        'Centroid', ...
        'BoundingBox');

    PropDisk2 = regionprops(ImageOpenDisk2, ... % use ImageCloseDisk2 for generic morphology
        'Area', ...
        'Centroid', ...
        'BoundingBox');

    PropStick = regionprops(ImageCloseStick, ...
        'Area', ...
        'Centroid', ...
        'BoundingBox');

    Prop = [PropDisk1; PropDisk2; PropStick];
    PropDisk = [PropDisk1; PropDisk2];
    PropStick = [PropStick];

    % define different colors for makrs
    MarkCol = [1 0 0; 0 1 0; 0 0 1];

    figure(Index);
    imshow(ImageOrig);
    title(strcat('Center of Mass: Image ', num2str(Index)));

    % since I don't have any time left and I already separated the color
    % spaces I implemented an easy solution to mark the disks colors
    % sorry for being lazy ... any points pls? ^^
    
    % mark yellow disks
    for Ind2 = 1:size(PropDisk1,1) 
            %apply a minimum area condition
            if PropDisk1(Ind2).Area > MinArea
                Cent=PropDisk1(Ind2).Centroid; 
                BBox = PropDisk1(Ind2).BoundingBox;
                X=Cent(1);Y=Cent(2);
                %construct the bounding box using line or rectangle
                % rectangle('Position', BBox, 'EdgeColor',[0 1 0]);
                line([X-5 X+5], [Y-5 Y+5], 'LineWidth', 2, 'Color', [0 1 0]);
                line([X+5 X-5], [Y-5 Y+5], 'LineWidth', 2, 'Color', [0 1 0]);
                text(X+5,Y+5, sprintf('yellow', X, Y), 'BackgroundColor',[.8 .8 .8]);
            end  
    end

        for Ind2 = 1:size(PropDisk2,1) 
            %apply a minimum area condition
            if PropDisk2(Ind2).Area > MinArea
                Cent=PropDisk2(Ind2).Centroid; 
                BBox = PropDisk2(Ind2).BoundingBox;
                X=Cent(1);Y=Cent(2);
                %construct the bounding box using line or rectangle
                % rectangle('Position', BBox, 'EdgeColor',[0 1 0]);
                line([X-5 X+5], [Y-5 Y+5], 'LineWidth', 2, 'Color', [0 1 0]);
                line([X+5 X-5], [Y-5 Y+5], 'LineWidth', 2, 'Color', [0 1 0]);
                text(X+5,Y+5, sprintf('red', X, Y), 'BackgroundColor',[.8 .8 .8]);
            end  
    end

    % mark all sticks
    for Ind2 = 1:size(PropStick,1) 
            %apply a minimum area condition
            if PropStick(Ind2).Area > MinArea
                Cent=PropStick(Ind2).Centroid; 
                BBox = PropStick(Ind2).BoundingBox;
                X=Cent(1);Y=Cent(2);
                %construct the bounding box using line or rectangle
                % rectangle('Position', BBox, 'EdgeColor',[1 0 0]);
                line([X-5 X+5], [Y-5 Y+5], 'LineWidth', 2, 'Color', [1 0 0]);
                line([X+5 X-5], [Y-5 Y+5], 'LineWidth', 2, 'Color', [1 0 0]);
            end  
    end
    
end


% sorry had no time left for the angle stuff but here is what I prepared

%%%%% structure element


%%%%% angle calculations
% Ang = props(Ind).Orientation;
% Cent=props(Ind).Centroid;
% X = Cent(1);
% Y = Cent(2);
% z0 = (X + i*Y) - 20*exp(-i*Ang*pi/180);
% z1 = (X + i*Y) + 20*exp(-i*Ang*pi/180);
% line([real(z0) real(z1)], [imag(z0) imag(z1)], 'LineWidth', 4, 'Color', [0 1 0]);