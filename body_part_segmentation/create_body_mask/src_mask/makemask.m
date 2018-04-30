
function maskImg=makemask(imSize,poseInx,viewPoint)

%This function converts joint locations to body part mask.
% Input:
%       imSize : size of image
%       poseInx: body joint locations
% Output: maskImg: mask
%

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

%  [rImg,cImg,~]=size(img);
rImg=imSize.rImg;
cImg=imSize.cImg;
maskImg=zeros(imSize.rImg,imSize.cImg);

%------- function for creating ellipse mask-----
% % mask = maskEllipse( mRows, nCols, cRow ,cCol,ra,rb,phi);
% %  mRows   - number of rows in mask
% %  nCols   - number of columns in mask
% %  cRow    - the row location of the center of the ellipse
% %  cCol    - the column location of the center of the ellipse
% %  ra      - semi-major axis length (in pixels) of the ellipse
% %  rb      - semi-minor axis length (in pixels) of the ellipse
% %  phi     - rotation angle (in radians) of semimajor axis to x-axis
% % mask = maskEllipse(  cImg, rImg, 40, 100,  20, 15, pi/4 );


%=================================================================


[iRnan,iCnan]=find(isnan(poseInx));
if ~isempty(iRnan)
    iCnan1=find(isnan(poseInx(1,:)));
    iCnan2=find(isnan(poseInx(2,:)));
    display('isnan happened!')
    poseInx(1,iCnan1)=0;
    poseInx(2,iCnan2)=0;
    
end
%===================== max size of body ================
len_tmp(1)=(abs(poseInx(1,4)-poseInx(1,5))+abs(poseInx(1,6)-poseInx(1,7)))/2;
len_tmp(2)=(abs(poseInx(2,4)-poseInx(2,6))+abs(poseInx(2,5)-poseInx(2,7)))/2;
maxBS=max(len_tmp);

%=======================================================

[rr cc] = meshgrid(1:cImg,1:rImg);

%---------------Neck---------------------------
cRow  = ((poseInx(1,4)+poseInx(1,5))/2+poseInx(1,3))/2;
nCols = ((poseInx(2,4)+poseInx(2,5))/2+poseInx(2,3))/2;
len_dist=sqrt((abs((poseInx(1,4)+poseInx(1,5))/2-poseInx(1,3)))^2+(abs((poseInx(2,4)+poseInx(2,5))/2-poseInx(2,3)))^2);
ra=len_dist;
rb=0.1*len_dist;
angle=atan2((poseInx(2,4)+poseInx(2,5))/2-poseInx(2,3),(poseInx(1,4)+poseInx(1,5))/2-poseInx(1,3));
if (len_dist>cImg/3)||(len_dist>rImg/3)
    mask(1).C=0;
else
    maskTmp = maskEllipse(rImg,cImg, nCols,cRow ,  0.4*ra(1), 0.8*(rb(1)), angle);
    mask(1).C=logical(maskTmp);
end


% %---------------- Right shoulder-elbow --------------------------
cRow  = (poseInx(1,4)+poseInx(1,8))/2;
nCols = (poseInx(2,4)+poseInx(2,8))/2;
len_dist=sqrt((abs(poseInx(1,4)-poseInx(1,8)))^2+(abs(poseInx(2,4)-poseInx(2,8)))^2);
ra=0.6*len_dist;
rb=0.22*ra;
if (len_dist>cImg/3)||(len_dist>rImg/3)
    mask(4).C=0;
else
    angle=atan2(poseInx(2,8)-poseInx(2,4),poseInx(1,8)-poseInx(1,4));
    maskTmp = maskEllipse(rImg,cImg, nCols,cRow ,  ra(1), (rb(1)), angle);
    mask(4).C=logical(maskTmp);
end

% %---------------- Left shoulder-elbow --------------------------
cRow  = (poseInx(1,5)+poseInx(1,9))/2;
nCols = (poseInx(2,5)+poseInx(2,9))/2;
len_dist=sqrt((abs(poseInx(1,5)-poseInx(1,9)))^2+(abs(poseInx(2,5)-poseInx(2,9)))^2);
ra=0.6*len_dist;
rb=0.22*ra;
if (len_dist>cImg/3)||(len_dist>rImg/3)
    mask(5).C=0;
else
    angle=atan2(poseInx(2,5)-poseInx(2,9),poseInx(1,5)-poseInx(1,9));
    maskTmp = maskEllipse(rImg,cImg, nCols,cRow ,  ra(1), (rb(1)), angle);
    mask(5).C=logical(maskTmp);
end
%

% %---------------- Right elbow-wrist --------------------------
cRow  = (poseInx(1,8)+poseInx(1,12))/2;
nCols = (poseInx(2,8)+poseInx(2,12))/2;
len_dist=sqrt((abs(poseInx(1,8)-poseInx(1,12)))^2+(abs(poseInx(2,8)-poseInx(2,12)))^2);
ra=0.7*len_dist;
rb=0.15*len_dist;
if (len_dist>cImg/3)||(len_dist>rImg/3)
    mask(8).C=0;
else
    angle=atan2(poseInx(2,8)-poseInx(2,12),poseInx(1,8)-poseInx(1,12));
    maskTmp = maskEllipse(rImg,cImg, nCols,cRow ,  ra(1), (rb(1)), angle);
    mask(8).C=logical(maskTmp);
end
%

% %---------------- Left elbow-wrist --------------------------
cRow  = (poseInx(1,9)+poseInx(1,13))/2;
nCols = (poseInx(2,9)+poseInx(2,13))/2;
len_dist=sqrt((abs(poseInx(1,9)-poseInx(1,13)))^2+(abs(poseInx(2,9)-poseInx(2,13)))^2);
ra=0.7*len_dist;
rb=0.15*len_dist;
if (len_dist>cImg/3)||(len_dist>rImg/3)
    mask(9).C=0;
else
    angle=atan2(poseInx(2,9)-poseInx(2,13),poseInx(1,9)-poseInx(1,13));
    maskTmp = maskEllipse(rImg,cImg, nCols,cRow ,  ra(1), (rb(1)), angle);
    mask(9).C=logical(maskTmp);
end
%


% %----------------Right hip-knee----------------------

temp_dx=abs(poseInx(1,6)-(poseInx(1,7)+poseInx(1,6))/2)/4+3;
temp_dy=abs(poseInx(2,6)-(poseInx(2,7)+poseInx(2,6))/2)/4+3;
vec_X=[poseInx(1,6),(poseInx(1,7)+poseInx(1,6))/2,poseInx(1,10)+temp_dx,poseInx(1,10)-temp_dx];
vec_Y=[poseInx(2,6),(poseInx(2,7)+poseInx(2,6))/2,poseInx(2,10)+temp_dy,poseInx(2,10)-temp_dy];
order_vec=[1,2,4,3];
if vec_X(1)>vec_X(2)
    if vec_X(3)>vec_X(4)
        order_vec=[1,2,4,3];
    else
        order_vec=[1:4];
    end
else
    if vec_X(3)>vec_X(4)
        order_vec=[1:4];
    else
        order_vec=[1,2,4,3];
    end
end
Hip_KneeRight_BW = poly2mask(vec_X(order_vec), vec_Y(order_vec), rImg, cImg);
mask(6).C=logical(Hip_KneeRight_BW);

% %----------------Left hip-knee----------------------


temp_dx=abs(poseInx(1,7)-(poseInx(1,7)+poseInx(1,6))/2)/4+3;
temp_dy=abs(poseInx(2,7)-(poseInx(2,7)+poseInx(2,6))/2)/4+3;
vec_X=[poseInx(1,7),(poseInx(1,7)+poseInx(1,6))/2,poseInx(1,11)-temp_dx,poseInx(1,11)+temp_dx];
vec_Y=[poseInx(2,7),(poseInx(2,7)+poseInx(2,6))/2,poseInx(2,11)-temp_dy,poseInx(2,11)+temp_dy];
order_vec=[1,2,4,3];
if vec_X(1)>vec_X(2)
    if vec_X(3)>vec_X(4)
        order_vec=[1,2,4,3];
    else
        order_vec=[1:4];
    end
else
    if vec_X(3)>vec_X(4)
        order_vec=[1:4];
    else
        order_vec=[1,2,4,3];
    end
end
Hip_KneeLeft_BW = poly2mask(vec_X(order_vec), vec_Y(order_vec), rImg, cImg);
mask(7).C=logical(Hip_KneeLeft_BW);

%------------------Right knee-ankle---------------------------

temp_dx=abs(poseInx(1,7)-(poseInx(1,7)+poseInx(1,6))/2)/4+3;
temp_dy=abs(poseInx(2,7)-(poseInx(2,7)+poseInx(2,6))/2)/4+3;
vec_X=[poseInx(1,10)+temp_dx,poseInx(1,10)-temp_dx,poseInx(1,14)-temp_dx/1.5,poseInx(1,14)+temp_dx/1.5];
vec_Y=[poseInx(2,10)+temp_dy,poseInx(2,10)-temp_dy,poseInx(2,14)-temp_dy/1.5,poseInx(2,14)+temp_dy/1.5];
Knee_AnkleRight_BW = poly2mask(vec_X, vec_Y, rImg, cImg);
mask(10).C=logical(Knee_AnkleRight_BW);

%-------------------Left knee-ankle--------------------------

temp_dx=abs(poseInx(1,7)-(poseInx(1,7)+poseInx(1,6))/2)/4+3;
temp_dy=abs(poseInx(2,7)-(poseInx(2,7)+poseInx(2,6))/2)/4+3;
vec_X=[poseInx(1,11)+temp_dx,poseInx(1,11)-temp_dx,poseInx(1,15)-temp_dx/1.5,poseInx(1,15)+temp_dx/1.5];
vec_Y=[poseInx(2,11)+temp_dy,poseInx(2,11)-temp_dy,poseInx(2,15)-temp_dy/1.5,poseInx(2,15)+temp_dy/1.5];
Knee_AnkleLeft_BW = poly2mask(vec_X, vec_Y, rImg, cImg);
mask(11).C=logical(Knee_AnkleLeft_BW);

%----------- Belly (shekam) ---------------

len_tmp(1)=(abs(poseInx(1,4)-poseInx(1,5))+abs(poseInx(1,6)-poseInx(1,7)))/2;
len_tmp(2)=(abs(poseInx(2,4)-poseInx(2,6))+abs(poseInx(2,5)-poseInx(2,7)))/2;
ra=max(len_tmp);

if (ra>cImg/3)||(ra>rImg/3)
    mask(2).C=0;
else
    
    vec_X=[poseInx(1,4),poseInx(1,5)+1,poseInx(1,7)+1,poseInx(1,6)];
    vec_Y=[poseInx(2,4)-ra*0.03,poseInx(2,5)-ra*0.03,poseInx(2,7),poseInx(2,6)];
    order_vec=[1,2,4,3];
    if vec_X(1)>vec_X(2)
        if vec_X(3)>vec_X(4)
            order_vec=[1,2,4,3];
        else
            order_vec=[1:4];
        end
    else
        if vec_X(3)>vec_X(4)
            order_vec=[1:4];
        else
            order_vec=[1,2,4,3];
        end
    end
    
    Belly_BW = poly2mask(vec_X(order_vec), vec_Y(order_vec), rImg, cImg);
    mask(2).C=logical(Belly_BW);
end


%------ Face-------------------
base_size=ra*0.15;
mask(3).C = sqrt((rr-poseInx(1,3)).^2+(cc-poseInx(2,3)).^2)<=base_size*1.3;

%---------- Right wrist (moche dast) -------------------
mask(12).C = sqrt((rr-poseInx(1,12)).^2+(cc-poseInx(2,12)).^2)<=base_size*0.8;
%---------- Left wrist (moche dast) -------------------
mask(13).C = sqrt((rr-poseInx(1,13)).^2+(cc-poseInx(2,13)).^2)<=base_size*0.8;
%-----------Right ankle (moche pa)------------------------
mask(14).C = sqrt((rr-poseInx(1,14)).^2+(cc-poseInx(2,14)).^2)<=base_size*1.1;
%-----------Left ankle (moche pa)------------------------
mask(15).C = sqrt((rr-poseInx(1,15)).^2+(cc-poseInx(2,15)).^2)<=base_size*1.1;



if findstr(viewPoint,'NW')
    mask_order=[1,2,3,5,9,13,7,11,15,4,8,12,6,10,14];
    for ii=mask_order
        maskImg(mask(ii).C)=ii;
    end
    
elseif findstr(viewPoint,'NE')
    mask_order=[1,2,3,4,8,12,5,9,13,6,10,14,7,11,15];
    for ii=mask_order
        maskImg(mask(ii).C)=ii;
    end
    
    
elseif findstr(viewPoint,'SW')
    mask_order=[1,3,4,8,12,5,9,13,6,10,14,7,11,15,2];
    for ii=mask_order
        maskImg(mask(ii).C)=ii;
    end
    
elseif findstr(viewPoint,'SE')
    mask_order=[1,3,5,9,13,7,11,15,4,8,12,6,10,14,2];
    for ii=mask_order
        maskImg(mask(ii).C)=ii;
    end
    
else
    mask_order=[1:length(mask)];
    for ii=mask_order
        maskImg(mask(ii).C)=ii;
    end
    
end


end
%  hold off;


