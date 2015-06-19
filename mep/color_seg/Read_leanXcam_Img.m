clear 'all';
close 'all';

figure(1);hold on;

ImageCounter = 0;


while 1 
    
    try
        %first we trigger the cgi script in order to have the leanXcam save
        %a new image
        Image=imread('http://192.168.1.10/cgi-bin/cgi');
        %the return value will not be an image, so the call fails (-> catch)!!
    catch
        
    end
    %nevertheless the image is available (url works :-)
    Image=imread('http://192.168.1.10/image.bmp');
    imshow(Image);
    ImageCounter = ImageCounter+1;
    title(strcat('image index: ', num2str(ImageCounter)));
    
    pause(0.2);
end