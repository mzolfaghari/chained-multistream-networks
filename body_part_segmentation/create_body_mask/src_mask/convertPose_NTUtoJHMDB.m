function outPose = convertPose_NTUtoJHMDB( inPose,scale_vec )
% Convert NTU_RGBD pose to JHMDB pose standard
%inPose: NTU pose labels
%outPose: JHMDB pose
% 
% We consider one standard for all our datasets based on the label of body parts. 
% This is the order of the joints in JHMDB dataset
% 1: neck - gardan
% 2: belly - shekam
% 3: face
% 4: right shoulder - shane
% 5: left  shoulder
% 6: right hip - mafsale ran
% 7: left  hip
% 8: right elbow - aranj
% 9: left elbow
% 10: right knee -zanoo
% 11: left knee
% 12: right wrist - moche dast
% 13: left wrist
% 14: right ankle - moche pa
% % 15: left ankle

% Paper: "Chained Multi-stream Networks Exploiting Pose, Motion, and
% Appearance for Action Classification and Detection"
% Mohammadreza Zolfaghari, Gabriel L. Oliveira, Nima Sedaghat, Thomas Brox,
% ICCV 2017
%==============================================



%------- Neck -------
outPose(1,1)=((inPose(3).colorX+inPose(21).colorX)/2)/scale_vec(1);
outPose(1,2)=((inPose(3).colorY+inPose(21).colorY)/2)/scale_vec(2);

%------- Belly -------
outPose(2,1)=(inPose(2).colorX)/scale_vec(1);
outPose(2,2)=(inPose(2).colorY)/scale_vec(2);

%------- Face -------
outPose(3,1)=((inPose(4).colorX+inPose(3).colorX)/2)/scale_vec(1);
outPose(3,2)=((inPose(4).colorY+inPose(3).colorY)/2)/scale_vec(2);

%------- right shoulder -------
outPose(4,1)=(inPose(5).colorX)/scale_vec(1);
outPose(4,2)=(inPose(5).colorY)/scale_vec(2);

%------- left  shoulder -------
outPose(5,1)=(inPose(9).colorX)/scale_vec(1);
outPose(5,2)=(inPose(9).colorY)/scale_vec(2);

%------- right hip -------
outPose(6,1)=(inPose(13).colorX)/scale_vec(1);
outPose(6,2)=(inPose(13).colorY)/scale_vec(2);

%------- left  hip -------
outPose(7,1)=(inPose(17).colorX)/scale_vec(1);
outPose(7,2)=(inPose(17).colorY)/scale_vec(2);

%------- right elbow -------
outPose(8,1)=(inPose(6).colorX)/scale_vec(1);
outPose(8,2)=(inPose(6).colorY)/scale_vec(2);

%------- left elbow -------
outPose(9,1)=(inPose(10).colorX)/scale_vec(1);
outPose(9,2)=(inPose(10).colorY)/scale_vec(2);

%------- right knee -------
outPose(10,1)=(inPose(14).colorX)/scale_vec(1);
outPose(10,2)=(inPose(14).colorY)/scale_vec(2);

%------- left knee -------
outPose(11,1)=(inPose(18).colorX)/scale_vec(1);
outPose(11,2)=(inPose(18).colorY)/scale_vec(2);

%------- right wrist -------
outPose(12,1)=((inPose(8).colorX+inPose(22).colorX+inPose(23).colorX)/3)/scale_vec(1);
outPose(12,2)=((inPose(8).colorY+inPose(22).colorY+inPose(23).colorY)/3)/scale_vec(2);

%------- left wrist -------
outPose(13,1)=((inPose(12).colorX+inPose(25).colorX+inPose(24).colorX)/3)/scale_vec(1);
outPose(13,2)=((inPose(12).colorY+inPose(25).colorY+inPose(24).colorY)/3)/scale_vec(2);


%------- right ankle  -------
outPose(14,1)=((inPose(16).colorX+inPose(15).colorX)/2)/scale_vec(1);
outPose(14,2)=((inPose(16).colorY+inPose(15).colorY)/2)/scale_vec(2);

%------- left ankle  -------
outPose(15,1)=((inPose(20).colorX+2*inPose(19).colorX)/3)/scale_vec(1);
outPose(15,2)=((inPose(20).colorY+2*inPose(19).colorY)/3)/scale_vec(2);

outPose=permute(outPose,[2 1]);

end

