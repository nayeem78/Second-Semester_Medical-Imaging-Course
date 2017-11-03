clc;
clear all;
close all; 
dir_us = 'Labs/3D Ultrasound/04534601.dcm';
us = dicomread(dir_us);
us_info = dicominfo(dir_us);

IML = us(:,:,1,70);
figure,imshow(IML);
im = IML';

sector=110;   % [degrees]
%im_depth=50; % [cm] (depth + ROC)

ROC=1;
im_depth=11 + ROC ;

col_size=size(im,2);
zeros_row = zeros(200, col_size);
im=[zeros_row; im];
scan_lines = im;

[nY, nX] = size(im);

min_ang=(sector/nX)*pi/180;% [rad.]
theta = -nX/2*min_ang:min_ang:nX/2*min_ang; % total angle/num. lines [radians]

theta = theta(2:end);

steering_angles=theta; % angles [radians]

num_samples=im_depth/nY;
rr = (0:(nY-1))*num_samples; % im. depth/num. samples
r = rr; 


image_size = [26,16+ROC]; %[cm]


x_resolution = 256; % image resolution [pix]
y_resolution = 256;

% assign the inputs
x = image_size(2);
y = image_size(1);

disp_rr=max(rr)/(im_depth-ROC);

%plot input image
figure; imagesc(theta*(180/pi), rr/disp_rr, fliplr(IML')); title('polar geometry'); colormap(gray)
xlabel('theta [deg]')
ylabel('r [cm]'); hold on;

% number of scan lines
Nt = length(scan_lines(1, :));

% create regular Cartesian grid to remap to
pos_vec_y_new = (0:1/(y_resolution-1):1).*y - y/2;
pos_vec_y_new = pos_vec_y_new';
pos_vec_x_new = (0:1/(x_resolution-1):1).*x;
[pos_mat_x_new, pos_mat_y_new] = ndgrid(pos_vec_x_new, pos_vec_y_new);

% convert new points to polar coordinates
[th_cart, r_cart] = cart2pol(pos_mat_x_new, pos_mat_y_new);

% interpolate using linear interpolation
op = interp2(steering_angles,r, double(scan_lines), th_cart, r_cart, 'linear').';

% set any values outside of the interpolation range to be 0
% op(isnan(op)) = max(b_mode(:));
op(isnan(op)) = 0;

%plot output image
figure, 
imagesc(pos_vec_x_new - ROC, pos_vec_y_new, op); title('Cartesian geometry'); colormap(gray); 
xlabel('lat [cm]')
ylabel('ax [cm]');
caxis([7.2,max(max(op))])