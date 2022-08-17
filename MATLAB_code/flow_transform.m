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

inputdire=strcat(ABSPATH_transform,'\MATLAB-Results-Flow');
input_SF_orient=dir(strcat(ABSPATH_transform,'\DominantDirection_SFs\',TiffimageIndex,'*.txt'));
list_input_transform=dir(strcat(inputdire,'\',TiffimageIndex,'*.mat'));
savefile_trans=strcat(ABSPATH_transform,'\MATLAB-Results-Flow_transformed');
mkdir(savefile_trans);

for j_transform=1:length(list_input_transform)
    filename=strcat(input_SF_orient(j_transform).folder,'\', input_SF_orient(j_transform).name);
    [pathkeep, namekeep, extkeep]=fileparts(filename);
    load(strcat(list_input_transform(j_transform).folder,'\',namekeep,'.mat'))
    data=dlmread(filename,'\t',1,0);            %%%data(time,2)=degree of SF at time
    theta_SF= mean( data(1:Pre_frame,2) ) ;
    % transform matrix
    L=[ cosd(abs(theta_SF)),	cosd(90-theta_SF);...
        cosd(90+theta_SF),	  cosd(abs(theta_SF))];
    
    
    
    list=dir(strcat(ABSPATH_transform,'\tensor-coordinates\',namekeep,'\*.txt'));
    
    DeformationVectorList_tf=zeros(4,2,SizeOfMatrix-1);
    PositionList_tf=zeros(4,2,SizeOfMatrix-1);                                    %%%Displacement vector
    for i=1:SizeOfMatrix-1

        input=strcat(ABSPATH_FLOW,'\tensor-coordinates\',namekeep,'\',list(1,1).name);
        DT=interval*i;

        Data=dlmread(input,'\t',1,0);
        tData=Data.';
        firstkeep=  [tData(1,:) tData(2,:) tData(3,:) tData(4,:)].*pixelsize;%%um
       
        input=strcat(ABSPATH_FLOW,'\tensor-coordinates\',namekeep,'\',list(i+1,1).name);
        Data=dlmread(input,'\t',1,0);
        tData=Data.';
        secondkeep= [tData(1,:) tData(2,:) tData(3,:) tData(4,:)].*pixelsize; %%um

        % % %     Calculate Tensor
        %     [ U,E,e,Strain,StrainRate, SpinRate]=function_calculate_tensor(firstkeep, secondkeep, DT);
        [ DeformationVector_tf]=function_calculate_flow(firstkeep, secondkeep, DT);
        for k=1:length(DeformationVector_tf)
            DeformationVectorList_tf(k,:,i)=(L.'*DeformationVector_tf(k,1:2).').';                     %%um
            VelosityVectorList_tf(k,:,i)=DeformationVectorList_tf(k,:,i)./(i*interval);
        end
        
        PositionList_tf(:,:,i)=tData;          %%pixel
        
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
               'String','Variables were saved in "MATLAB-Results-Flow_transformed".');

    btn = uicontrol('Parent',d,...
               'Position',[85 20 70 25],...
               'String','Close',...
               'Callback','delete(gcf)');
end