function demo_brox
%This function computes flow images from RGB images using [1].
%%Mohammadreza Zolfaghari, May 2018
% Paper: "Chained Multi-stream Networks Exploiting Pose, Motion, and
% Appearance for Action Classification and Detection"
% Mohammadreza Zolfaghari, Gabriel L. Oliveira, Nima Sedaghat, Thomas Brox,
% ICCV 2017
%[1] Brox, Thomas, et al. "High accuracy optical flow estimation based on a theory for warping." Computer Vision-ECCV 2004. Springer Berlin Heidelberg, 2004. 25-36.

%=================================================================

im1 = imread('.../image1.jpg');
im2 = imread('.../image2.jpg');

img_save_path='flow1.jpg';

%----- compute flow based on brox method --------
flow_org = mex_OF(double(im1),double(im2));

scale = 16;
mag = sqrt(flow_org(:,:,1).^2+flow_org(:,:,2).^2)*scale+128;
mag = min(mag, 255);
flow = flow_org*scale+128;
flow = min(flow,255);
flow = max(flow,0);

%--------- make a 3channel image ----------
[x,y,z] = size(flow);
flow_image = zeros(x,y,3);
flow_image(:,:,1:2) = flow;
flow_image(:,:,3) = mag;
flow_image = uint8(flow_image);
imwrite(flow_image,img_save_path)

