function [ outputdata_MF_K] = func_turnover_sumData(inputTensor_list,  inputimage, Iter, frame,ABSPATH_Tensor,outextension,outpath,indx_outlier)
%FUNC_STRAIN_MAPPING この関数の概要をここに記述
%   詳細説明をここに記述

MF_K_all=zeros(length(inputTensor_list),10);
for posi=1:length(inputTensor_list)

    [PathOfTensor, NameOfTensor, ExtOfTensor]=fileparts(inputTensor_list(posi).name);
    
    inputCorrect=strcat(ABSPATH_Tensor,'\rectangle_coordinate_to_correct\', NameOfTensor,'.txt');
    load(strcat(ABSPATH_Tensor,'\MATLAB-Results-Flow\',NameOfTensor,'.mat'));
    load(strcat(ABSPATH_Tensor,'\MATLAB-Results-Tensor_transformed\',NameOfTensor,'.mat'));
    time=interval*(Iter-1);
    %%%Get Rectangle Coorinates
    clear keep
    keep=dlmread(inputCorrect,'\t',1,0);
    Coordinatecorrect=keep(11:12)./pixelsize;
    %%%Get turnover rate
   
    sz=size(strain_parallel);
    if Iter<=sz(1)
        PositionList_keep(1:4,1:2)=PositionList(1:4,1:2,Iter)+Coordinatecorrect;
        MF_K_all(posi,1)=MF;
        MF_K_all(posi,2)=k;
        MF_K_all(posi,3:6)=PositionList_keep(1:4,1).';%%pixel
        MF_K_all(posi,7:10)=PositionList_keep(1:4,2).';%%pixel
    end
end

clear keep1   keepf
keep1=find( (MF_K_all(:,1)~=0) & isnan(MF_K_all(:,1))==0);
szkeep=size(keep1);
if szkeep(1,1)~=0
    keepdata=MF_K_all(keep1,:);
    [B TF]=rmoutliers(keepdata(:,1));
    if find(indx_outlier==4)==1
        keepf=find(TF==0);
    else
        keepf=[1:length(keepdata)]';
    end
    
    outputdata_MF_K= keepdata(keepf,:);
else
    return
end


end

