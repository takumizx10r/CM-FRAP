clear
close all

waitfor(msgbox(['Select TIFF file of whole cell image that was converted' ...
    ' from original LSM image. File sould be under tifimage-chX folder.']));

[inputimage, ABSPATH_FLOW]=uigetfile(strcat(pwd,'\.tif'));

% cd (ABSPATH_FLOW);
tiff_info = imfinfo(inputimage);
[im_filepath, im_filename, im_extension]=fileparts(inputimage);
imageindex=im_filename;
resolution=tiff_info(1).XResolution; %um
maxTotalFrame=size(tiff_info,1);
addpath (ABSPATH_FLOW);


prompt = {'Interval (s):','Num of waiting frames:','Right after bleach frame:'};
dlgtitle = 'Image information';
dims = [1 50];
definput = {'15','2', '3'};
answer = inputdlg(prompt,dlgtitle,dims,definput);
interval=str2num(answer{1}); %sec
Pre_frame=str2num(answer{2});
RAB_Frame=str2num(answer{3});

rangeofkeepf=4;






















pixelsize=1/resolution;
TotalFrame=maxTotalFrame-RAB_Frame+1;


imagelist=dir(strcat(ABSPATH_FLOW,'\tensor-coordinates\',imageindex,'*'));
savefile=strcat(ABSPATH_FLOW,'\MATLAB-Results-Flow');
mkdir(savefile);

for j=1:length(imagelist)

    filenum=imagelist(j,1).name;
    list=dir(strcat(ABSPATH_FLOW,'\tensor-coordinates\',filenum,'\*.txt'));

    filename_rec = strcat(ABSPATH_FLOW,'\Recovery\',filenum,'.txt');
    FRAPData	= dlmread(filename_rec,'\t',1,0);
    I=FRAPData(:,3);
    filename_pre = strcat(ABSPATH_FLOW,'\Prebleach\',filenum,'.txt');
    Pre	= dlmread(filename_pre,'\t',1,0);


    SizeOfMatrix=min(length(list),TotalFrame);
% % % %     Initialization
    DeformationVectorList=zeros(4,2,SizeOfMatrix-1);                                    %%%Displacement vector
    VelosityVectorList=zeros(4,2,SizeOfMatrix-1);                                    %%%Velosity vector
    MeanDeformationVectorList=zeros(1,2,SizeOfMatrix-1);
    MeanVelosityVectorList=zeros(1,2,SizeOfMatrix-1);
    PositionList=zeros(4,2,SizeOfMatrix-1);                                    %%%Displacement vector

    for i=1:SizeOfMatrix-1
        
        input=strcat(ABSPATH_FLOW,'\tensor-coordinates\',filenum,'\',list(1,1).name);
        DT=interval*i;
        
        Data=dlmread(input,'\t',1,0);
        tData=Data.';
        firstkeep=  [tData(1,:) tData(2,:) tData(3,:) tData(4,:)].*pixelsize;%%um
        
        input=strcat(ABSPATH_FLOW,'\tensor-coordinates\',filenum,'\',list(i+1,1).name);
        Data=dlmread(input,'\t',1,0);
        tData=Data.';
        secondkeep= [tData(1,:) tData(2,:) tData(3,:) tData(4,:)].*pixelsize; %%um

        [ DeformationVector]=function_calculate_flow(firstkeep, secondkeep, DT);

% % %         Output parameters
        DeformationVectorList(:,:,i)=DeformationVector;                     %%um
        VelosityVectorList(:,:,i)       =DeformationVector./(i*interval);  %%um/s

        MeanDeformationVectorList(:,:,i)=mean(DeformationVector);                     %%um
        MeanVelosityVectorList(:,:,i)       =mean(DeformationVector./(i*interval));     %%um/s


        PositionList(:,:,i)=tData;          %%pixel
       

    end
    % % % %

    savematfile=strcat(savefile,'\',filenum);
    save(savematfile);
    close all
    j
end

messagedialog
function messagedialog
    d = dialog('Position',[300 300 250 150],'Name','Complete!');

    txt = uicontrol('Parent',d,...
               'Style','text',...
               'Position',[20 80 210 40],...
               'String','Variables were saved in "MATLAB-Results-Flow".');

    btn = uicontrol('Parent',d,...
               'Position',[85 20 70 25],...
               'String','Close',...
               'Callback','delete(gcf)');
end


