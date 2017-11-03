%function [ Iregistered, M] = affineReg2D( Imoving, Ifixed )
%Example of 2D affine registration
%   Robert Martí  (robert.marti@udg.edu)
%   Based on the files from  D.Kroon University of Twente

% clean
clear all; close all; clc;

% Read two imges
 Imoving=im2double(rgb2gray(imread('brain3.png')));
 Ifixed=im2double(rgb2gray(imread('brain1.png')));
 %Imoving=im2double(imread('lena/lenag2.png'));
 %Ifixed=im2double(imread('lena/lenag1.png'));


% Smooth both images for faster registration
ISmoving=imfilter(Imoving,fspecial('gaussian'));
ISfixed=imfilter(Ifixed,fspecial('gaussian'));

mtype = 'sd'; % metric type: s: ssd m: mutual information e: entropy
ttype = 'a'; % rigid registration, options: r: rigid, a: affine
multi_res = 3; %multi resoltuion, options: 1,2,3
switch ttype
    case 'a'
        % Parameter scaling of the Translation and Rotation
        scale= [1.0 1.0 100.0 1.0 1.0 100.0];
        % Set initial affine parameters
        x = [1 0 0 0 1 0]; % For affine tranformation
        %x = [1 0 0 0 1 1];
    case 'r'
        % Parameter scaling of the Translation and Rotation
        scale=[1.0 10.0 10.0];
        % Set initial affine parameters
        x = [0 1 0]; % For affine tranformation
    otherwise
        error('Type does not match');
        
end;

% x=x./scale;
% tic
% [x]=fminunc(@(x)affine_function(x,scale,ISmoving,ISfixed,mtype,ttype),x,optimset('Display','iter','MaxIter',1000, 'TolFun', 1.000000e-06,'TolX',1.000000e-06, 'MaxFunEvals', 1000*length(x), 'PlotFcns',@optimplotfval));
% toc
% % Scale the translation, resize and rotation parameters to the real values
% x=x.*scale;

%multi resoltuion
if multi_res==1
    %optimizer
    tic
    [x]=fminunc(@(x)affine_function(x,scale,ISmoving,ISfixed,mtype,ttype),x,optimset('Display','iter','MaxIter',1000, 'TolFun', 1.000000e-06,'TolX',1.000000e-06, 'MaxFunEvals', 1000*length(x), 'PlotFcns',@optimplotfval));
    toc
elseif multi_res==2
    %resizing
    Ima=imresize(ISmoving,0.5);
    Ifa=imresize(ISfixed,0.5);
    %optimizer
    tic
    [x]=fminunc(@(x)affine_function(x,scale,Ima,Ifa,mtype,ttype),x,optimset('Display','iter','MaxIter',1000, 'TolFun', 1.000000e-06,'TolX',1.000000e-06, 'MaxFunEvals', 1000*length(x), 'PlotFcns',@optimplotfval));
    %scaling the translation parameters
    if ttype=='r'
        x(1)=x(1)*2;
        x(2)=x(2)*2;
    else
        x(3)=x(3)*2;
        x(6)=x(6)*2;
    end
    pause;
    %optimizer
    [x]=fminunc(@(x)affine_function(x,scale,ISmoving,ISfixed,mtype,ttype),x,optimset('Display','iter','MaxIter',1000, 'TolFun', 1.000000e-06,'TolX',1.000000e-06, 'MaxFunEvals', 1000*length(x), 'PlotFcns',@optimplotfval));
    toc
elseif multi_res==3
    %resizing
    Ima=imresize(ISmoving,0.5);
    figure, imshow(Ima);
    pause;
    
    Ifa=imresize(ISfixed,0.5);
    Imb=imresize(ISmoving,0.25);
    figure, imshow(Imb);
    pause;
    Ifb=imresize(ISfixed,0.25);
   
    tic
    [x]=fminunc(@(x)affine_function(x,scale,Imb,Ifb,mtype,ttype),x,optimset('Display','iter','MaxIter',1000, 'TolFun', 1.000000e-06,'TolX',1.000000e-06, 'MaxFunEvals', 1000*length(x), 'PlotFcns',@optimplotfval));
    
    pause;
    if ttype=='r'
        x(1)=x(1)*2;
        x(2)=x(2)*2;
    else
        x(3)=x(3)*2;
        x(6)=x(6)*2;
    end
    %optimizer
    [x]=fminunc(@(x)affine_function(x,scale,Ima,Ifa,mtype,ttype),x,optimset('Display','iter','MaxIter',1000, 'TolFun', 1.000000e-06,'TolX',1.000000e-06, 'MaxFunEvals', 1000*length(x), 'PlotFcns',@optimplotfval));
    %scaling the translation parameters
    pause;
    if ttype=='r'
        x(1)=x(1)*2;
        x(2)=x(2)*2;
    else
        x(3)=x(3)*2;
        x(6)=x(6)*2;
    end
    pause;
    %optimizer
    [x]=fminunc(@(x)affine_function(x,scale,ISmoving,ISfixed,mtype,ttype),x,optimset('Display','iter','MaxIter',1000, 'TolFun', 1.000000e-06,'TolX',1.000000e-06, 'MaxFunEvals', 1000*length(x), 'PlotFcns',@optimplotfval));
    toc

end


x=x.*scale;

switch ttype
    case 'r' %squared differences
        M=[ cos(x(3)) sin(x(3)) x(1);
            -sin(x(3)) cos(x(3)) x(2);
            0 0 1];
    case 'a'
        M = [x(1) x(2) x(3);
            x(4) x(5) x(6);
            0 0 1];
    otherwise
        error('Type does not match');
end;
% Transform the image
Icor=affine_transform_2d_double(double(Imoving),double(M),2); % 3 stands for cubic interpolation

% Show the registration results
figure,
subplot(2,2,1), imshow(Ifixed);title('Fixed Image');
subplot(2,2,2), imshow(Imoving); title('Moving Image');
subplot(2,2,3), imshow(Icor); title('Registration Result')
subplot(2,2,4), imshow(abs(Ifixed-Icor)); title('Difference Image')

%end

