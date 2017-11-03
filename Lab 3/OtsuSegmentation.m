function [ segImg ] = OtsuSegmentation( image )
%RGB2HSV
image = rgb2hsv(image);
image = image(:,:,2);

t = graythresh(image);
image_mask = im2bw(image,t);

segImg = image_mask;

%morphological operation
segImg = bwmorph(segImg,'erode');
segImg = bwmorph(segImg,'close');
segImg = bwmorph(segImg,'erode');
segImg = bwmorph(segImg,'close');
segImg1 = imfill(segImg,8,'holes');
segImg = segImg1;
end

