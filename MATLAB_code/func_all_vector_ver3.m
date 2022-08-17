function [U_vector,V_vector ,myMovie1,myMovie2] = func_all_vector_ver3(inputTensor_list,  inputimage, iter, frame, scale_displacement, scale_velocity,ABSPATH_Flow,outextension,outpath,indx_outlier)
%UNTITLED3 この関数の概要をここに記述
%   詳細説明をここに記述
myMovie1=struct('cdata',NaN);
myMovie2=struct('cdata',NaN);
% CenterOfDuplicate=zeros(length(inputTensor_list) ,2);
U_vector=zeros(length(inputTensor_list)*4,4);
V_vector=zeros(length(inputTensor_list)*4,4);
for posi=1:length(inputTensor_list)
% % % Get Vectors
[PathOfTensor, NameOfTensor, ExtOfTensor]=fileparts(inputTensor_list(posi).name);

inputCorrect=strcat(ABSPATH_Flow,'\rectangle_coordinate_to_correct\', NameOfTensor,'.txt');

load(strcat(ABSPATH_Flow,'\MATLAB-Results-Flow\',NameOfTensor,'.mat'));
time=interval*(iter-1);
sz=size(DeformationVectorList);
if iter<=sz(3)
    U_vector(posi*4-3:posi*4,3:4)=DeformationVectorList(1:sz(1),1:sz(2),iter); %%um
	V_vector(posi*4-3:posi*4,3:4)=VelosityVectorList(1:sz(1),1:sz(2),iter); %%um/s


%%%Get center
clear keep
keep=dlmread(inputCorrect,'\t',1,0);
Coordinatecorrect=keep(11:12)./pixelsize;

% PositionList_together(posi+(posi-1)*4:posi*4,1:2)=keep(frame,7:8);
U_vector(posi*4-3:posi*4,1:2)=PositionList(1:4,1:2,iter)+Coordinatecorrect;%%pixel
V_vector(posi*4-3:posi*4,1:2)=PositionList(1:4,1:2,iter)+Coordinatecorrect;%%pixel
end

%%%%
end

% % % Arrow U_vector
clear keep1
keep1=find( (U_vector(:,3)~=0) & (U_vector(:,4)~=0) );
szkeep=size(keep1);
if szkeep(1,1)~=0


%%%%%make arrow Flow
clear keepvectors keepf
keepvectors=U_vector(keep1,1:4);
% keepvectors=V_vector(keep1,1:4);
[A1 TF1]=rmoutliers(keepvectors(:,3));
[A2 TF2]=rmoutliers(keepvectors(:,4));
if find(indx_outlier==3)==1
    keepf=find(TF1==0 & TF2==0);
else
    keepf=[1:size(keepvectors,1)];
end
% B=keepvectors(:,:);
B=keepvectors(keepf,:);
% % % Flow norm field
[fig]=func_make_arrow_ver3_NormField(inputimage, iter, RAB_Frame, inputTensor_list, B,scale_displacement,pixelsize,time);
% %%Save
name='Vectors_AllPoints_ColorNorm';
[keepPath, keepName, keepExt]=fileparts(inputimage);
strframe=sprintf('%03d',iter);
myMovie1  =   getframe(fig);
SAVENAME=strcat(outpath,'\',strframe,'_',name,outextension);
exportgraphics(gcf,SAVENAME,'BackgroundColor','none','Resolution',600,'ContentType','vector');
close 

        
% % % % Flow orient field 
[fig]=func_make_arrow_ver3_OrientField(inputimage, iter, RAB_Frame, inputTensor_list, B,scale_displacement,pixelsize, time);
% %     %%Save
name='Vectors_AllPoints_ColorOrient';
[keepPath, keepName, keepExt]=fileparts(inputimage);
strframe=sprintf('%03d',iter);
myMovie2  =   getframe(fig);
SAVENAME=strcat(outpath,'\',strframe,'_',name,outextension);
exportgraphics(gcf,SAVENAME,'BackgroundColor','none','Resolution',600,'ContentType','vector');
close 
else
    return
end
end

