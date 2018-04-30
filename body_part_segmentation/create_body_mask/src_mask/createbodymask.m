
function createbodymask(ImageDBPath,PoseDBPath,action)

ImagesDB=ReadImageDB(ImageDBPath,action);
PoseDB=ReadPoseDB(PoseDBPath,action);
 timePause=0.01;
activityN=1;
%get all pose information of videos
DBposeActivity=PoseDB(activityN).Data;

 MovFramesAll=ImagesDB.Data;
 Nclips=length(MovFramesAll);
 for iiVideo=1:Nclips
     MovFrames=MovFramesAll(iiVideo).Videoimg;
     DBposeSubActions=DBposeActivity(iiVideo).VideoPose;
     pose_img=DBposeSubActions.pos_img;
     viewPoint=DBposeSubActions.viewpoint;
     [rImg,cImg,~]=size(MovFrames(1).imgs);
     for iiFrame=1:size(pose_img,3)
     
         imSize.rImg=rImg;
         imSize.cImg=cImg;
        maskImg=makemask(imSize,pose_img(:,:,iiFrame),viewPoint);
%        imshow(maskImg)
        imgTemp=zeros(280,280,3);
        maskTemp=zeros(280,280);
        LenRemovPix=20;

        imgT=MovFrames(iiFrame).imgs;
        imgTemp(21:260,:,:)=imgT(:,LenRemovPix+1:end-LenRemovPix,:);
        maskTemp(21:260,:)= maskImg(:,LenRemovPix+1:end-LenRemovPix);
        imgTemp(21:260,:,1)=imgT(:,LenRemovPix+1:end-LenRemovPix,1).*maskImg(:,LenRemovPix+1:end-LenRemovPix);

        a=subplot(1,2,1), subimage(imgTemp)
         axis tight
         axis off
        b=subplot(1,2,2), imagesc(maskTemp)
        colormap(colorcube)
        axis tight
        axis off
        hold on
        titlStr=strcat('{\color{blue}Activity}: ',action,'-','#{\color{magenta}Video}: ',num2str(iiVideo),'-','#{\color{cyan}Frame}: ',num2str(iiFrame));
        suptitle(titlStr)
        title(a,'Image')
        title(b,'Mask')
        
         pause(timePause);
     end
 end
 
end