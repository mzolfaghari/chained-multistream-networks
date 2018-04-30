function [imgs_folder]=read_imgs_inside_folder(folder_path,rii_opt)
%This function reads all images inside of specific folder
%Mohammadreza Zolfaghari, April 2018


file_list = dir([folder_path,strcat('/*.',rii_opt.format)]);
im_tmp    = imread(fullfile(folder_path,file_list(1).name));

if rii_opt.resize_flag ==1
    sH = rii_opt.rImg;
    sW = rii_opt.cImg;
    sC = 3;
    
else
    [sH,sW,sC] = size(im_tmp);
end


imgs_folder = zeros(sH,sW,sC,length(file_list));

for ii=1:length(file_list)
    img_tmp = imread(fullfile(folder_path,file_list(ii).name));
    
    if rii_opt.resize_flag ==1
        imgs_folder(:,:,:,ii) = imresize(img_tmp,[rii_opt.rImg,rii_opt.cImg]);
    else
        imgs_folder(:,:,:,ii) = img_tmp
    end
    
end

end
