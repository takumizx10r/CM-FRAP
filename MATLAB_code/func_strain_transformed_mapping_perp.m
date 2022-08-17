function [myMovie,PI_Strain, K_all] = func_strain_transformed_mapping_perp(inputTensor_list,  inputimage, Iter, frame,ABSPATH_Tensor,outextension,outpath,indx_outlier)
%FUNC_STRAIN_MAPPING この関数の概要をここに記述
%   詳細説明をここに記述

PI_Strain=zeros(length(inputTensor_list),9);
K_all=zeros(length(inputTensor_list),9);
myMovie=struct('cdata',NaN);
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
   
    sz=size(strain_vertical);
    if Iter<=sz(1)
        
        PI_Strain(posi,1)=strain_vertical(Iter,1);
        PositionList_keep(1:4,1:2)=PositionList(1:4,1:2,Iter)+Coordinatecorrect;
        K_all(posi,1)=k;
        K_all(posi,2:5)=PositionList_keep(1:4,1).';%%pixel
        K_all(posi,6:9)=PositionList_keep(1:4,2).';%%pixel
        PI_Strain(posi,2:5)=PositionList_keep(1:4,1).';%%pixel
        PI_Strain(posi,6:9)=PositionList_keep(1:4,2).';%%pixel
               
    end
end

clear keep1   keepf
keep1=find( (PI_Strain(:,1)~=0) & isnan(PI_Strain(:,1))==0);
szkeep=size(keep1);
if szkeep(1,1)~=0
    keepstrain=PI_Strain(keep1,:);
    [B TF]=rmoutliers(keepstrain(:,1));
    if find(indx_outlier==2)==1
        keepf=find(TF==0);
    else
        keepf=[1:length(keepstrain)]';
    end

    
    [MAX , MIN,fig]=func_make_rectangle_strainTransformed_field_perp(inputimage, Iter, RAB_Frame,  keepstrain(keepf,:),pixelsize, time);
    name='TrStrain_perp';
    [keepPath, keepName, keepExt]=fileparts(inputimage);
    myMovie  =   getframe(fig);
    strframe=sprintf('%03d',Iter);
    SAVENAME=strcat(outpath,'\',strframe,'_',name,outextension);
    exportgraphics(fig,SAVENAME,'BackgroundColor','none','Resolution',600,'ContentType','vector');
    close    
else
    return
end


end

