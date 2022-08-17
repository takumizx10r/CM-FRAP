clear
close all

waitfor(msgbox(['Select TIFF file of whole cell image that was converted' ...
    ' from original LSM image. File sould be under tifimage-chX folder.']));




[inputimage, ABSPATH_mkdupimage]=uigetfile(strcat(pwd,'\.tif'));


tiff_info = imfinfo(inputimage);
[im_filepath, im_filename, im_extension]=fileparts(inputimage);
imageindex=im_filename;
resolution=tiff_info(1).XResolution; %um
addpath(ABSPATH_mkdupimage);
list = {'PNG','TIFF','PDF','EPS'};
[indx,tf] = listdlg('PromptString',{'Select output file type'},'ListString',list,'SelectionMode','single');
list_extension={'.png','.tif','.pdf','.eps'};

prompt = {'Make figures every X frame:'};
dlgtitle = 'Input';
dims = [1 35];
definput = {num2str(round( length(tiff_info)/10)-1 )};
answer = inputdlg(prompt,dlgtitle,dims,definput);
OUTITER=str2num(answer{1}); 
scale=1.0;

inputdire=strcat(ABSPATH_mkdupimage,'\MATLAB-Results-Flow');
inputdupimage=strcat(ABSPATH_mkdupimage,'\duplicated\');
list_matfile=dir(strcat(inputdire,'\*.mat'));
% mkdir(strcat(ABSPATH_mkdupimage,'\duplicated_arrow_movie\'));

% j_matfile=1
for j_matfile=1:length(list_matfile)
    [keepdre, keepname, keepex]=fileparts(strcat(list_matfile(j_matfile).folder,'\',list_matfile(j_matfile).name));
    name='duplicated_deformVecArrows_matimage';
    mkdir(strcat(ABSPATH_mkdupimage,'\',name,'\'));
    outputdire=strcat(ABSPATH_mkdupimage,'\',name,'\',keepname,'\');
    mkdir(outputdire);
    
    load(strcat(list_matfile(j_matfile).folder,'\',list_matfile(j_matfile).name))
    [PathOfTensor, NameOfTensor, ExtOfTensor]=fileparts(strcat(list_matfile(j_matfile).folder,'\',list_matfile(j_matfile).name));
    dupimage=strcat(inputdupimage,'\',NameOfTensor,'.tif');
    % list_coordinate=dir(strcat(ABSPATH_mkdupimage,'\tensor-coordinates\',keepname,'\*txt'));
    sz=size(DeformationVectorList);
    f=1;
    time = (([1:sz(3)]-1)*interval).';
    list_coordinate=dir(strcat(ABSPATH_mkdupimage,'\tensor-coordinates\',keepname,'\*txt'));

    for iter=1:OUTITER:sz(3)
        UVectors(:,1:2)=PositionList(1:4,1:2,iter);
        UVectors(:,3:4)=DeformationVectorList(1:sz(1),1:sz(2),iter);
        KeepCoordinates_t(:,1:2,iter)=PositionList(1:4,1:2,iter);

%         time=(iter-1)*interval;
        fig1=func_make_arrow_forDupimage_NormField_ver2(dupimage, iter,  RAB_Frame, 0, UVectors,scale,pixelsize,time,KeepCoordinates_t);
%         myMovie1(f)  =   getframe(fig1);
        SAVENAME1=strcat(outputdire,sprintf('%03d',iter-1),list_extension{indx});
        exportgraphics(fig1,SAVENAME1,'Resolution',600,'BackgroundColor','none','ContentType','vector');
        close
        fig2=func_make_arrow_forDupimage_NormField_orient_ver2(dupimage, iter,  RAB_Frame, 0, UVectors,scale,pixelsize,time,KeepCoordinates_t);
%         myMovie2(f)  =   getframe(fig2);
        SAVENAME2=strcat(outputdire,sprintf('%03d_orient',iter-1),list_extension{indx});
        exportgraphics(fig2,SAVENAME2,'Resolution',600,'BackgroundColor','none','ContentType','vector');
        close
        f=f+1;

    end
    

end


messagedialog
function messagedialog
    d = dialog('Position',[300 300 250 150],'Name','Complete!');

    txt = uicontrol('Parent',d,...
               'Style','text',...
               'Position',[20 80 210 40],...
               'String',['Figures were saved in "duplicated_deformVecArrows_matimage".']);

    btn = uicontrol('Parent',d,...
               'Position',[85 20 70 25],...
               'String','Close',...
               'Callback','delete(gcf)');

end



