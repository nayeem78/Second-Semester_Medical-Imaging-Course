clear all; close all;

% Path to the original images
path_org1 = 'images/gt/expert_1/';
path_org2 = 'images/gt/expert_2/';
path_org3 = 'images/gt/expert_3/';
% Get the content of the original folder
content_list1 = dir(path_org1);
content_list2 = dir(path_org2);
content_list3 = dir(path_org3);

% Create the directory to save the output image
path_fusion = 'images/gt/fusion1/';
if ~exist(path_fusion, 'dir')
    mkdir(path_fusion);
end

% Annotate each file
for file = 1 : length( content_list1 )
    % Exclude the directories
    if ( content_list1( file ).isdir ~= 1 )
        % Check the if it is a jpg file
        info = imfinfo( fullfile( path_org1, content_list1( file ).name ) );
        if ( strcmp(info.Format, 'png') )
            % Open the image
            disp( [ 'Generation of Ground truth ', content_list1( file ).name ] );
            im1 = imread( fullfile( path_org1, content_list1( file ).name ) ) ;
            im2 = imread( fullfile( path_org2, content_list2( file ).name ) ) ;
            im3 = imread( fullfile( path_org3, content_list3( file ).name ) ) ;
            [pathstr,name,ext] = fileparts( fullfile( path_org1, content_list1( file ).name ) );
            
            [height width] = size(im1);
            im = zeros(height,width);
            
            for i = 1: height
                for j = 1:width
                    if im1(i,j) == 255 && im2(i,j) == 255 && im3(i,j) == 255
                        im(i,j) = 255;
                    end
                end
            end
            
            %gtimage = im2bw(gtImage);
            % Save the image
            imwrite( im, [ path_fusion, name, '.png' ], 'png' );
            close all;
        end
    end
end

