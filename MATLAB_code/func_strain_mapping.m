function [myMovie,PI_Strain] = func_strain_mapping(inputTensor_list,  inputimage, iter, frame,ABSPATH_Tensor,outextension,outpath,indx_outlier)
%FUNC_STRAIN_MAPPING この関数の概要をここに記述
%   詳細説明をここに記述

PI_Strain=zeros(length(inputTensor_list),9);
myMovie=struct('cdata',NaN);
for posi=1:length(inputTensor_list)

    [PathOfTensor, NameOfTensor, ExtOfTensor]=fileparts(inputTensor_list(posi).name);
    
    inputCorrect=strcat(ABSPATH_Tensor,'\rectangle_coordinate_to_correct\', NameOfTensor,'.txt');
    load(strcat(ABSPATH_Tensor,'\MATLAB-Results-Tensor\',NameOfTensor,'.mat'));
    load(strcat(ABSPATH_Tensor,'\MATLAB-Results-Flow\',NameOfTensor,'.mat'));
    
    time=interval*(iter-1);
    sz=size(StrainTensor);
    if iter<=sz(3)
        
        [~,Ds]=eig(StrainTensor(:,:,iter));
        a1=Ds(1,1);
        a2=Ds(2,2);
        PI_Strain(posi,1)=a1+a2;
        
%%%Get Rectangle Coorinates
        clear keep
        keep=dlmread(inputCorrect,'\t',1,0);
        Coordinatecorrect=keep(11:12)./pixelsize;
        
        PositionList_keep(1:4,1:2)=PositionList(1:4,1:2,iter)+Coordinatecorrect;
        
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
    if find(indx_outlier==1)==1
        keepf=find(TF==0);
    else
        keepf=[1:size(keepstrain,1)]';
    end
    [MAX , MIN,fig]=func_make_rectangle_strain_field_ver2(inputimage, iter, RAB_Frame,  keepstrain(keepf,:),pixelsize, time);
%     [MAX , MIN,fig]=func_make_rectangle_strainTransformed_field_ver2(inputimage, Iter, RAB_Frame,  keepstrain(keepf,:),pixelsize, time);

    name='VolStrain';
    [keepPath, keepName, keepExt]=fileparts(inputimage);
    myMovie  =   getframe(fig);
    strframe=sprintf('%03d',iter);
    SAVENAME=strcat(outpath,'\',strframe,'_',name,outextension);
    exportgraphics(fig,SAVENAME,'BackgroundColor','none','Resolution',600,'ContentType','vector');
    close    

else
    return
end



end

