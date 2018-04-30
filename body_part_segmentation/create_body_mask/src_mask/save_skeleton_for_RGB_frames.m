function save_skeleton_for_RGB_frames(skeletonfilename,save_bodymask_folderpath,rgbfilename,options)
% Save the skeleton data for RGB frames.
%
% Argrument:
%   skeletonfilename: full adress and filename of the .skeleton file.
%   rgbfilename: corresponding RGB video file

% Modified by Mohammadreza Zolfaghari, April 2018
% Paper: "Chained Multi-stream Networks Exploiting Pose, Motion, and
% Appearance for Action Classification and Detection"
% Mohammadreza Zolfaghari, Gabriel L. Oliveira, Nima Sedaghat, Thomas Brox,
% ICCV 2017
%==============================================

flag_save_mat = options.flag_mat;
flag_debug    = options.flag_debug;
imSize.rImg   = options.rImg;
imSize.cImg   = options.cImg;


bodyinfo = read_skeleton_file(skeletonfilename);

if flag_debug==1
    [rgbvid] = read_imgs_inside_folder(rgbfilename,options);
    figure('rend','painters','pos',[200 200 1270 390])

end

%-------- parameters to scale joint positions ---
% wX=1080/240, wY=1920/320
wX        = 6;
wY        = 4.5;
scale_vec = [wX,wY];


% reapeat this for every frame
save_bodymask_fileNameTemp = sprintf('%s/bodymask_%04d.mat',save_bodymask_folderpath,1);
[idx_correct]              = remove_noisy_skeletons(bodyinfo,save_bodymask_fileNameTemp);
  previous_mask            = zeros(imSize.rImg,imSize.cImg);
  
for f=1:numel(bodyinfo)
    %             f
    clear allMask
    allMask(1).maskImg = zeros(imSize.rImg,imSize.cImg);
    
    if ~exist(save_bodymask_folderpath,'dir')
        mkdir(save_bodymask_folderpath);
    end
    
    save_bodymask_fileName = sprintf('%s/bodymask_%04d.mat',save_bodymask_folderpath,f);
    if flag_debug==1
        imrgb = rgbvid(:,:,:,f);
    end
    iiMask=1;
    
    % for all the detected skeletons in the current frame:
    minBodies = length(bodyinfo(f).bodies);
    
    try        
        for b=idx_correct(1:min(length(idx_correct),minBodies))
            
            body_joints             = bodyinfo(f).bodies(b).joints;
            outPose                 = convertPose_NTUtoJHMDB( body_joints,scale_vec);
            allMask(iiMask).maskImg = makemask(imSize,outPose,'N');
            iiMask = iiMask+1;
            
        end
        
    catch err1
        disp(err1);
        save_bodymask_fileName
    end
    
    %------ merge multiple bodymasks in the scene to single bodymask ----
    %     try
    maskFrm = zeros(imSize.rImg,imSize.cImg);
    for iim=1:length(allMask)
        maskTemp                = allMask(iim).maskImg;
        inxAllnonZeros          = find(maskTemp~=0);
        maskFrm(inxAllnonZeros) = maskTemp(inxAllnonZeros);
    end
    

    %==== to remove noisy masks we use previous pose for current frame==
   
    if length(find(maskFrm>0))<10
        maskFrm = previous_mask;
    end
    
    masK_all(:,:,f) = maskFrm;
    %------------- save bodymask as mat file for each frame ----
    if flag_save_mat==1
        save(save_bodymask_fileName,'maskFrm');
    end
    
    %============================================
    %---------- show body mask on image ---------
    if flag_debug==1
        subplot(1,2,1);
        imagesc(maskFrm);

        axis off
        hold on
        
        imrgb = imrgb(1:imSize.rImg,1:imSize.cImg,:);
        for iim=1:length(allMask)
            maskTemp       = allMask(iim).maskImg;
            imrgb(:,:,iim) = imrgb(:,:,iim).*maskTemp;
            
        end
        subplot(1,2,2);
        imshow(uint8(imrgb));
        pause(0.01)
    end
    previous_mask=maskFrm;
    clear allMask
    
    
end



end


