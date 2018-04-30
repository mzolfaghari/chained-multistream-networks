function [idx_correctFinal] = remove_noisy_skeletons(bodysVideo,save_bodymask_fileName)
% Find index of noisy skeletons in"NTU RGB+D 3D Action Recognition Dataset".
% Manual noise-removal by Mohammadreza Zolfaghari, April 2018

%Parameters for finding noisy cases
dist_threshold=4100;
mov_threshold=550;
general_threshold=11000;

%================ variance of bodyjoint locations ===============
% try
    bodyJointsTmp=bodysVideo(1).bodies;
% catch err1
%     disp(err1);
%     save_bodymask_fileName
% end

stat_joints=zeros(numel(bodyJointsTmp),25,numel(bodysVideo),2);
for i_frame=1:numel(bodysVideo)
    bodyJoints=bodysVideo(i_frame).bodies;
    for i_body=1:numel(bodyJoints)
        for i_joint=1:25
            
            joint = bodyJoints(i_body).joints(i_joint);
%             try
            if isnan(joint.colorX)
                stat_joints(i_body,i_joint,i_frame,1)=mean(stat_joints(i_body,i_joint,:,1));
            else
                stat_joints(i_body,i_joint,i_frame,1)=joint.colorX;
            end

            if isnan(joint.colorY)
                stat_joints(i_body,i_joint,i_frame,2)=mean(stat_joints(i_body,i_joint,:,2));
                
            else
                stat_joints(i_body,i_joint,i_frame,2)=joint.colorY;
            end
            
        end
        bodyAvgDistJointsPerFrame(i_body,i_frame)=mean(mean(var(stat_joints(i_body,:,i_frame,:))));
        
    end
end

%================== movement of body joints throught the video
for i_body=1:size(stat_joints,1)
    for i_joint=1:25
        bodyAvgMovPerVideo(i_body,i_joint)=mean(mean(var(stat_joints(i_body,i_joint,:,:))));
    end
    
end


%---------------------------------------------------------------
for i_body=1:size(stat_joints,1)
    
    meanDistJoints(i_body)=mean(bodyAvgDistJointsPerFrame(i_body,:));
    meanMovJoints(i_body)=mean(bodyAvgMovPerVideo(i_body,:));
    
end


%=======================================================

if length(meanDistJoints)==1
    idx_correctFinal=1;
else
    idx_correctFinal=find((meanDistJoints)>dist_threshold);
end

end


