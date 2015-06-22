% MEP EBV Supersaxo Marioclear 'all'
close 'all';
figureIndex = 1;
%path were pictures are stored
Path = 'Image_';
%this is the delta of the step
Delta = 1;
   
fileID = fopen('cubes.txt','w');
fprintf(fileID,'Index\tgreen\tyellow\tred\tblue\n');

%loop over required range, with step size Delta
for Index = Delta:Delta:10
    %read next image
    FileName = strcat(Path, sprintf('%02d', Index), '.png');
    Image = imread(FileName);

    %transform to YCbCr space
    ImageYCbCr = rgb2ycbcr(Image);
    %extract color planes
    Y = ImageYCbCr(:,:,1);
    Cb = ImageYCbCr(:,:,2);
    Cr = ImageYCbCr(:,:,3);

    %from the figure 1 we found a transparency color 
    TrColG = [115 120];
    TrColY = [80 150];
    TrColR = [115 190];
    TrColB = [150 120];
    
    %the limit values, choose with imtools
    LimitValG = 10;
    LimitValY = 25;
    LimitValR = 35;
    LimitValB = 15;

    %find the 2D indices of all pixel with distance larger than LimitVal
    IndexImgG = (double(Cb)-TrColG(1)).^2+(double(Cr)-TrColG(2)).^2 < LimitValG.^2;
    IndexImgY = (double(Cb)-TrColY(1)).^2+(double(Cr)-TrColY(2)).^2 < LimitValY.^2;
    IndexImgR = (double(Cb)-TrColR(1)).^2+(double(Cr)-TrColR(2)).^2 < LimitValR.^2;
    IndexImgB = (double(Cb)-TrColB(1)).^2+(double(Cr)-TrColB(2)).^2 < LimitValB.^2;
    
    %define the structure element
    StrucElemG = strel('disk', 14);
    StrucElemY = strel('disk', 10);
    StrucElemR = strel('disk', 10);
    StrucElemB = strel('disk', 12);

    ImageG = imclose(IndexImgG, StrucElemG);
    ImageY = imclose(IndexImgY, StrucElemY);
    ImageR = imclose(IndexImgR, StrucElemR);
    ImageB = imclose(IndexImgB, StrucElemB);
    ImageAll = ImageG+ImageY+ImageR+ImageB;
    
    %ImageG = imopen(ImageG, StrucElemG);
    %ImageY = imopen(ImageY, StrucElemY);
    %ImageR = imopen(ImageR, StrucElemR);
    %ImageB = imopen(ImageB, StrucElemB);
    
    %IndexImg4 = imerode(IndexImg3,StrucElem3); // für schliessung erst
    %dilation dann erotation
    %IndexImg5 = imdilate(IndexImg4,StrucElem4);

    figure(Index);
    
    subplot(2,3,1);
    imshow(Image);
    
    [LabelImage, NumberLabels] = bwlabel(ImageG);
    %do feature extraction 
    Prop = regionprops(LabelImage,'Centroid');
    
    for Ind=1:size(Prop,1) 
        Cent=Prop(Ind).Centroid;
        X=Cent(1);Y=Cent(2);
        line([X-10 X+10],[Y Y]);
        line([X X],[Y-10 Y+10]);
        text(X,Y-40,sprintf('green')); 
    end
    green = NumberLabels;
    
    [LabelImage, NumberLabels] = bwlabel(ImageY);
    %do feature extraction 
    Prop = regionprops(LabelImage,'Centroid');
    
    for Ind=1:size(Prop,1) 
        Cent=Prop(Ind).Centroid;
        X=Cent(1);Y=Cent(2);
        line([X-10 X+10],[Y Y]);
        line([X X],[Y-10 Y+10]);
        text(X,Y-40,sprintf('yellow')); 
    end
    yellow = NumberLabels;
    
    [LabelImage, NumberLabels] = bwlabel(ImageR);
    %do feature extraction 
    Prop = regionprops(LabelImage,'Centroid');
    
    for Ind=1:size(Prop,1) 
        Cent=Prop(Ind).Centroid;
        X=Cent(1);Y=Cent(2);
        line([X-10 X+10],[Y Y]);
        line([X X],[Y-10 Y+10]);
        text(X,Y-40,sprintf('red')); 
    end
    red = NumberLabels;
    
        [LabelImage, NumberLabels] = bwlabel(ImageB);
    %do feature extraction 
    Prop = regionprops(LabelImage,'Centroid');
    
    for Ind=1:size(Prop,1)
        Cent=Prop(Ind).Centroid;
        X=Cent(1);Y=Cent(2);
        line([X-10 X+10],[Y Y]);
        line([X X],[Y-10 Y+10]);
        text(X,Y-40,sprintf('blue')); 
    end
    blue = NumberLabels;

    title('original');
    
    subplot(2,3,2);
    imshow(ImageAll);
    title('all');
    
    subplot(2,3,3);
    imshow(ImageG);
    title('green');
    
    subplot(2,3,4);
    imshow(ImageY);
    title('yellow');
    
    subplot(2,3,5);
    imshow(ImageR);
    title('red');
    
    subplot(2,3,6);
    imshow(ImageB);
    title('blue');
    
    fprintf(fileID,'%d\t%d\t%d\t%d\t%d\n',Index,green,yellow,red,blue);

end
fclose(fileID);