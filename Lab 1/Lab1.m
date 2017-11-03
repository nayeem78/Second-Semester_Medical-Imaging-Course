close all;
clear all;
clc;


%% Load the image
dir_us = 'Labs/3D Ultrasound/04534601.dcm';
us = dicomread(dir_us);
us_info = dicominfo(dir_us);



mri_dir = '/Labs/MRI/';
mri = [];

for i = 1:22
    if i < 10
        Name = sprintf('MRI0%d.dcm',i);
    else
        Name = sprintf('MRI%d.dcm',i);
    end
    

    im_dir = strcat(mri_dir,Name);
    mri(:,:,i) = dicomread(im_dir);
    %figure,imshow(Name,'DisplayRange',[])
end
mri_info = dicominfo(strcat(mri_dir,'MRI01.dcm'));
%% 

%% 
%dimension of each modality

%Ultrasound
disp(['The dimensionality of ultrasound : ',num2str(us_info.Height), '*',num2str(us_info.Width)]);
disp(['The number of ultrasound : ', num2str(double(us_info.Height) * double(us_info.Width))]);

% There is no pixel size information for ultrasound image

% MRI
[height, width, depth] = size(mri);
mri_pixel_size = mri_info.PixelSpacing;
sbs = mri_info.SpacingBetweenSlices;
disp(['The dimensionality of MRI: ',num2str(mri_info.Height),'*',num2str(mri_info.Width),'*',num2str(depth)]);
disp(['The pixel number of MRI: ', num2str(height*width*depth)]);
disp(['The pixel size of MRI images: x direction ', num2str(mri_pixel_size(1)),', y direction ',num2str(mri_pixel_size(2)), ', z direction ', num2str(sbs)]);
%% 

%% 
% Files Anonymized verification
% Patient name is not shown in DICOM.
disp(['The patient name of ultrasound image is: ',us_info.PatientName.FamilyName]);
disp(['The patient name of MRI image is: ',mri_info.PatientName.FamilyName]);
%% 

%% 
%Histogram of the two volumes

%Ultrasound histogram 
figure,imhist(us(:));
title('Histogram for Ultrasound');

%MRI histogram
figure,disp_mri = histogram(mri);
title('Histogram for MRI');

%Ultrasound Histogram
%imshow(X(:,:,1,100));
%imhist(X(:));

%% 

%% 
%Slices Visualization
%Ultrasound

figure, imshow(us(:,:,1,100));
figure, imshow(us(:,:,1,105));



figure, imshow(us(10,:,100));


figure, imshow(us(:,10,1,100));
figure,
subplot(2,2,1), imshow(us(:,:,1,100)),title('Front view'); 
hold on;
subplot(2,2,3), imshow(us(10,:,100)),title('Bottom view'); 
subplot(2,2,2), imshow(us(:,10,1,100)),title('side view'),hold off


%MRI 

figure, imshow(mri(:,:,11));
figure, imshow(mri(:,:,20));





