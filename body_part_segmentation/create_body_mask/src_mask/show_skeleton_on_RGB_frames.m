function []=show_skeleton_on_RGB_frames(...
    skeletonfilename,rgbfilename)
% Draws the skeleton data on RGB frames.
%
% Argrument:
%   skeletonfilename: full adress and filename of the .skeleton file.
%   rgbfilename: corresponding RGB video file
%   outputvideofilename (optional): the filename for output video file.
%
% For further information please refer to:
%   NTU RGB+D dataset's webpage:
%       http://rose1.ntu.edu.sg/Datasets/actionRecognition.asp
%   NTU RGB+D dataset's github page:
%        https://github.com/shahroudy/NTURGB-D
%   CVPR 2016 paper:
%       Amir Shahroudy, Jun Liu, Tian-Tsong Ng, and Gang Wang,
%       "NTU RGB+D: A Large Scale Dataset for 3D Human Activity Analysis",
%       in IEEE Conference on Computer Vision and Pattern Recognition (CVPR), 2016

%==============================================
% Modified by Mohammadreza Zolfaghari, April 2018
% "Chained Multi-stream Networks Exploiting Pose, Motion, and Appearance
% for Action Classification and Detection"
% Mohammadreza Zolfaghari, Gabriel L. Oliveira, Nima Sedaghat, Thomas Brox,
% ICCV 2017
%==============================================

bodyinfo = read_skeleton_file(skeletonfilename);

rii_opt.format = 'jpg'
rii_opt.resize_flag=1;
rii_opt.rImg = 240;
rii_opt.cImg = 320;
[rgbvid]=read_imgs_inside_folder(rgbfilename,rii_opt);


% in the skeleton structure, each joint is connected to some other joint:
connecting_joint = ...
    [2 1 21 3 21 5 6 7 21 9 10 11 1 13 14 15 1 17 18 19 2 8 8 12 12];
wX=6;
wY=4.5;
scale_vec=[wX,wY];

% reapeat this for every frame
[idx_correct] = remove_noisy_skeletons(bodyinfo);

for f=1:numel(bodyinfo)
    f
    %     try
    imrgb = rgbvid(:,:,:,f);
    iiMask=1;
    % for all the detected skeletons in the current frame:
    for b=idx_correct
        % for all the 25 joints within each skeleton:
        
        body_joints=bodyinfo(f).bodies(b).joints;
        for j=1:25
            try
                % use red color for drawing joint connections
                rv=255;
                gv=0;
                bv=0;
                
                k = connecting_joint(j);
                
                joint = bodyinfo(f).bodies(b).joints(j);
                body_joints=bodyinfo(f).bodies(b).joints;
                dx = joint.colorX/wX;
                dy = joint.colorY/wY;
                
                
                joint2 = bodyinfo(f).bodies(b).joints(k);
                dx2 = joint2.colorX/wX;
                dy2 = joint2.colorY/wY;
                
                xdist=abs(dx-dx2);
                ydist=abs(dy-dy2);
                
                
                
                % locate the pixels of the connecting line between the
                % two joints
                if xdist>ydist
                    xrange = [dx:sign(dx2-dx):dx2];
                    yrange = [dy:sign(dy2-dy)*abs((dy2-dy)/(dx2-dx)):dy2];
                else
                    yrange = [dy:sign(dy2-dy):dy2];
                    xrange = [dx:sign(dx2-dx)*abs((dx2-dx)/(dy2-dy)):dx2];
                end
                % draw the line!
                for i=1:numel(xrange)
                    dx = int32(round(xrange(i)));
                    dy = int32(round(yrange(i)));
                    imrgb(dy-wPix:dy+wPix,dx-wPix:dx+wPix,1)=rv;
                    imrgb(dy-wPix:dy+wPix,dx-wPix:dx+wPix,2)=gv;
                    imrgb(dy-wPix:dy+wPix,dx-wPix:dx+wPix,3)=bv;
                end
                
                joint = bodyinfo(f).bodies(b).joints(j);
                dx = int32(round(joint.colorX/wX));
                dy = int32(round(joint.colorY/wY));
                
                % use green color to draw joints
                rv=0;
                gv=255;
                bv=0;
                imrgb(dy-2*wPix:dy+2*wPix,dx-2*wPix:dx+2*wPix,1)=rv;
                imrgb(dy-2*wPix:dy+2*wPix,dx-2*wPix:dx+2*wPix,2)=gv;
                imrgb(dy-2*wPix:dy+2*wPix,dx-2*wPix:dx+2*wPix,3)=bv;
            catch err1
                disp(err1);
            end
            
            
        end

        imSize.rImg=240;
        imSize.cImg=320;
        outPose = convertPose_NTUtoJHMDB( body_joints,scale_vec);
        
        allMask(iiMask).maskImg=makemask(imSize,outPose,'N');
        iiMask=iiMask+1;
        
    end
    
    
    imrgb = imrgb(1:240,1:320,:);
    for iim=1:length(allMask)
        maskTemp=allMask(iim).maskImg;
        [inxR,inxC]=find(maskTemp~=0);
        imrgb(inxR,inxC,iim)=imrgb(inxR,inxC,iim).*maskTemp(inxR,inxC);
    end
    imshow(uint8(imrgb));
    %         writeVideo(writerObj,uint8(imrgb));
    %         pause(0.0001);
    %     catch err2
    %         disp(err2);
    %     end
end
% close(writerObj);
end
