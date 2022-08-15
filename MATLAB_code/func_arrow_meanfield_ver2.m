function [U_vector, V_vector ] = func_arrow_meanfield_ver2(inputTensor_list,  inputimage, iter, totaliter, scale_displacement, scale_velocity,ABSPATH_Flow,outextension,outpath,indx_outlier)
%UNTITLED3 この関数の概要をここに記述
%   詳細説明をここに記述

CenterOfDuplicate=zeros(length(inputTensor_list) ,2);
U_vector=zeros(length(inputTensor_list),4);
V_vector=zeros(length(inputTensor_list),4);
for posi=1:length(inputTensor_list)
    % % % Get Vectors
    [PathOfTensor, NameOfTensor, ExtOfTensor]=fileparts(inputTensor_list(posi).name);
    
    inputCorrect=strcat(ABSPATH_Flow,'\rectangle_coordinate_to_correct\', NameOfTensor,'.txt');
    
    load(strcat(ABSPATH_Flow,'\MATLAB-Results-Flow\',NameOfTensor,'.mat'));
    time=interval*(iter-1);
    sz=size(MeanDeformationVectorList);
    if iter<=sz(3)
        U_vector(posi,3:4)=MeanDeformationVectorList(1:sz(1),1:sz(2),iter); %%um
        V_vector(posi,3:4)=MeanVelosityVectorList(1:sz(1),1:sz(2),iter); %%um/s
        %%%Get center
        keep=dlmread(inputCorrect,'\t',1,0);
        Coordinatecorrect=keep(11:12);   %%pix
        clear keep
        keep=zeros(totaliter,totaliter);
        A=dlmread(strcat(ABSPATH_Flow,'\Recovery\', NameOfTensor,'.txt'),'\t',1,0);
        szA=size(A);
        keep(1:szA(1),1:szA(2))=A;
        CenterOfDuplicate(posi,1:2)=keep(iter,7:8);
        U_vector(posi,1:2)=(CenterOfDuplicate(posi,1:2)+Coordinatecorrect)./pixelsize;%%pixel
        V_vector(posi,1:2)=(CenterOfDuplicate(posi,1:2)+Coordinatecorrect)./pixelsize;%%pixel
    end
    %%%%
end

clear keep1
keep1=find( (U_vector(:,3)~=0) & (U_vector(:,4)~=0) );
szkeep=size(keep1);
if szkeep(1,1)~=0
 %%%%%make arrow

%%%%%make arrow Flow
clear keepvectors keepf
keepvectors=U_vector(keep1,1:4);
[A1 TF1]=rmoutliers(keepvectors(:,3));
[A2 TF2]=rmoutliers(keepvectors(:,4));
if find(indx_outlier==3)==1
    keepf=find(TF1==0 & TF2==0);
else
    keepf=[1:length(keepvectors)]';
end
B=keepvectors(keepf,:);
% % Flow norm field
[fig]=func_make_arrow_ver3_NormField(inputimage, iter, RAB_Frame, inputTensor_list, B,scale_displacement,pixelsize,time);
%%save
name='Vectors_Mean_ColorNorm';
[keepPath, keepName, keepExt]=fileparts(inputimage);
strframe=sprintf('%03d',iter);
myMovie1  =   getframe(fig);
SAVENAME=strcat(outpath,'\',strframe,'_',name,outextension);
exportgraphics(gcf,SAVENAME,'BackgroundColor','none','Resolution',600,'ContentType','vector');
close


% % Flow orient field
[fig]=func_make_arrow_ver3_OrientField(inputimage, iter, RAB_Frame, inputTensor_list, B,scale_displacement,pixelsize, time);

%%save
name='Vectors_Mean_ColorOrient';
[keepPath, keepName, keepExt]=fileparts(inputimage);
strframe=sprintf('%03d',iter);
myMovie2  =   getframe(fig);
SAVENAME=strcat(outpath,'\',strframe,'_',name,outextension);
exportgraphics(gcf,SAVENAME,'BackgroundColor','none','Resolution',600,'ContentType','vector');
close
end
end

