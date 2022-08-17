clear
close all

waitfor(msgbox(['Select TIFF file of whole cell image that was converted' ...
    ' from original LSM image. File sould be under tifimage-chX folder.']));

[inputimage, ABSPATH_transform]=uigetfile(strcat(pwd,'\.tif'));

tiff_info = imfinfo(inputimage);
[im_filepath, im_filename, im_extension]=fileparts(inputimage);
imageindex=im_filename;
resolution=tiff_info(1).XResolution; %um
addpath (ABSPATH_transform);
TiffimageIndex=imageindex;

inputdire=strcat(ABSPATH_transform,'\MATLAB-Results-Tensor');
input_SF_orient=dir(strcat(ABSPATH_transform,'\DominantDirection_SFs\',TiffimageIndex,'*.txt'));
list_input_transform=dir(strcat(inputdire,'\',TiffimageIndex,'*.mat'));
savefile_trans=strcat(ABSPATH_transform,'\MATLAB-Results-Tensor_transformed');
mkdir(savefile_trans);

for j_transform=1:length(list_input_transform)
    load(strcat(list_input_transform(j_transform).folder,'\',list_input_transform(j_transform).name),'Pre_frame')
    filename=strcat(input_SF_orient(j_transform).folder,'\', input_SF_orient(j_transform).name);
    data=dlmread(filename,'\t',1,0);            %%%data(time,2)=degree of SF at time
    theta_SF= mean( data(1:Pre_frame,2) ) ;
    % transform matrix
    L=[ cosd(abs(theta_SF)),	cosd(90-theta_SF);...
          cosd(90+theta_SF),	  cosd(abs(theta_SF))];
 
    load(strcat(list_input_transform(j_transform).folder,'\',list_input_transform(j_transform).name))
    Def_vec_tf=zeros(SizeOfMatrix-1,2);                                    %%%displacement vector
    V_vec_tf=zeros(SizeOfMatrix-1,2);                                    %%%displacement rate vector
    GreenStrainTensor_tf=zeros(2,2,SizeOfMatrix-1);
    AlmansiStrainTensor_tf=zeros(2,2,SizeOfMatrix-1);
    StrainTensor_tf=zeros(2,2,SizeOfMatrix-1);
    SpinTensor_tf=zeros(2,2,SizeOfMatrix-1);
    strain_parallel=zeros(SizeOfMatrix-1,1);
    strain_vertical=zeros(SizeOfMatrix-1,1);
    strainrate_parallel=zeros(SizeOfMatrix-1,1);
    strainrate_vertical=zeros(SizeOfMatrix-1,1);
    
    Green_para=zeros(SizeOfMatrix-1,1);
    Green_ver=zeros(SizeOfMatrix-1,1);
    Green_12=zeros(SizeOfMatrix-1,1);
    Green_21=zeros(SizeOfMatrix-1,1);
    Almandi_para=zeros(SizeOfMatrix-1,1);
    Almandi_ver=zeros(SizeOfMatrix-1,1);
    Almandi_12=zeros(SizeOfMatrix-1,1);
    Almandi_21=zeros(SizeOfMatrix-1,1);
    
    Green_tr_para=zeros(SizeOfMatrix-1,1);
    Almandi_tr_para=zeros(SizeOfMatrix-1,1);
    Green_tr_ver=zeros(SizeOfMatrix-1,1);
    Almandi_tr_ver=zeros(SizeOfMatrix-1,1);
    Green_tr_12=zeros(SizeOfMatrix-1,1);
    Almandi_tr_12=zeros(SizeOfMatrix-1,1);
    Green_tr_21=zeros(SizeOfMatrix-1,1);
    Almandi_tr_21=zeros(SizeOfMatrix-1,1);
    
    for iter=1:SizeOfMatrix-1
        
        Def_vec_tf(iter,:)=(L.'*Def_vec(iter,:).').';
        V_vec_tf(iter,:)=Def_vec_tf(iter,:)./(interval*iter);
        GreenStrainTensor_tf(:,:,iter)=L.'*GreenStrainTensor(:,:,iter)*L;
        AlmansiStrainTensor_tf(:,:,iter)=L.'*AlmansiStrainTensor(:,:,iter)*L;
        StrainTensor_tf(:,:,iter)=L.'*StrainTensor(:,:,iter)*L;
        SpinTensor_tf(:,:,iter)=L.'*SpinTensor(:,:,iter)*L;
        strain_parallel(iter,1)=StrainTensor_tf(1,1,iter);
        strain_vertical(iter,1)=StrainTensor_tf(2,2,iter);
        %         Strain Over time
        strainrate_parallel(iter,1)=StrainTensor_tf(1,1,iter)/TimeForPlot(iter);
        strainrate_vertical(iter,1)=StrainTensor_tf(2,2,iter)/TimeForPlot(iter);
        
        Green_para(iter,1)=GreenStrainTensor(1,1,iter);
        Green_ver(iter,1)=GreenStrainTensor(2,2,iter);
        Green_12(iter,1)=GreenStrainTensor(1,2,iter);
        Green_21(iter,1)=GreenStrainTensor(2,1,iter);
        Almandi_para(iter,1)=AlmansiStrainTensor(1,1,iter);
        Almandi_ver(iter,1)=AlmansiStrainTensor(2,2,iter);
        Almandi_12(iter,1)=AlmansiStrainTensor(1,2,iter);
        Almandi_21(iter,1)=AlmansiStrainTensor(2,1,iter);
        %         Strain Transformed Over time
        Green_tr_para(iter,1)=GreenStrainTensor_tf(1,1,iter);
        Green_tr_ver(iter,1)=GreenStrainTensor_tf(2,2,iter);
        Green_tr_12(iter,1)=GreenStrainTensor_tf(1,2,iter);
        Green_tr_21(iter,1)=GreenStrainTensor_tf(2,1,iter);
        Almandi_tr_para(iter,1)=AlmansiStrainTensor_tf(1,1,iter);
        Almandi_tr_ver(iter,1)=AlmansiStrainTensor_tf(2,2,iter);
        Almandi_tr_12(iter,1)=AlmansiStrainTensor_tf(1,2,iter);
        Almandi_tr_21(iter,1)=AlmansiStrainTensor_tf(2,1,iter);
    end

    
    savematfile_trans=strcat(savefile_trans,'\',list_input_transform(j_transform).name);
    save(savematfile_trans);
end

messagedialog
function messagedialog
    d = dialog('Position',[300 300 250 150],'Name','Complete!');

    txt = uicontrol('Parent',d,...
               'Style','text',...
               'Position',[20 80 210 40],...
               'String','Variables were saved in "MATLAB-Results-Tensor_transformed".');

    btn = uicontrol('Parent',d,...
               'Position',[85 20 70 25],...
               'String','Close',...
               'Callback','delete(gcf)');
end


