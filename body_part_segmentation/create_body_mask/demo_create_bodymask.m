function demo_create_bodymask

%==============================================
% Demo code for creating body part masks used in training body-part segmentation network
%Mohammadreza Zolfaghari, April 2018
% Paper: "Chained Multi-stream Networks Exploiting Pose, Motion, and
% Appearance for Action Classification and Detection"
% Mohammadreza Zolfaghari, Gabriel L. Oliveira, Nima Sedaghat, Thomas Brox,
% ICCV 2017
%==============================================

currentFolder = pwd


addpath(fullfile(currentFolder,'/src_mask/'));

path_missingSamples     = fullfile(currentFolder,'/src_mask/samples_with_missing_skeletons.txt');
list_missingSamples     = textread(path_missingSamples,'%s');
skeletons_base_path     = fullfile(currentFolder,'/demo_data/pose/');
save_bodyMask_Base_path = fullfile(currentFolder,'tmp');
rgbfilename             = fullfile(currentFolder,'/demo_data//images/S008C003P008R001A043')

%==========================================
options.flag_mat    = 1;%1: save mat file
options.rImg        = 240;%image size
options.cImg        = 320;%image size
options.flag_debug  = 1; %1: debug mode
options.format      = 'jpg'; %format of extracted images
options.resize_flag = 1;%1: if image needs to be resized
%==========================================



%========= create the name of skeleton file ====
str_file_name_tmp        = strsplit(rgbfilename,'/');
str_file_name            = str_file_name_tmp{end};
skeletonfilename         = sprintf('%s/%s.skeleton',skeletons_base_path,str_file_name);
save_bodymask_folderpath = sprintf('%s/%s/',save_bodyMask_Base_path,str_file_name);

idx = find((strcmp(list_missingSamples,str_file_name))~=0);


%================= Create body part mask and save them as mat file ====
%--------- check if the sample is not missing  ----
if isempty(idx)
    save_skeleton_for_RGB_frames(skeletonfilename,save_bodymask_folderpath,rgbfilename,options)
end



%================= show skeleton on RGB frames =================
show_skeleton_on_RGB_frames(skeletonfilename,rgbfilename);








