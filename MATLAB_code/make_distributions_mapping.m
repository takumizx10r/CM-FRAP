% % % % After following calculation
% % % % tensor_verX.m, flow_verX.m, tensor_transform_verX.m



















clear
close all
%

[inputimage, ABSPATH_Flow]=uigetfile(strcat(pwd,'\.tif'));
addpath (ABSPATH_Flow);
cd (ABSPATH_Flow);
tiff_info = imfinfo(inputimage);
[im_filepath, im_filename, im_extension]=fileparts(inputimage);
imageindex=im_filename;
resolution=tiff_info(1).XResolution; %um



TiffimageIndex=imageindex;


scale_displacement=2;
scale_velocity=2;




list = {'PNG','TIFF','PDF','EPS'};
[indx,tf] = listdlg('PromptString',{'Select output file type'},'ListString',list,'SelectionMode','single');
list_extension={'.png','.tif','.pdf','.eps'};











inputImagepath=dir(strcat(ABSPATH_Flow,'\tifimage-ch1\',TiffimageIndex,'*'));
inputimage=strcat(inputImagepath.folder,'\',inputImagepath.name);
inputTensor_list=dir(strcat(ABSPATH_Flow,'\MATLAB-Results-Flow\',TiffimageIndex,'*'));

% [PathOfTensor, NameOfTensor, ExtOfTensor]=fileparts(inputTensor_list(1).name);
inputCorrect=dir(strcat(ABSPATH_Flow,'\rectangle_coordinate_to_correct\',TiffimageIndex,'*.txt'));
input_load_list=dir(strcat(ABSPATH_Flow,'\MATLAB-Results-Flow\',TiffimageIndex,'*.mat'));
load(strcat(input_load_list(1).folder,'\',input_load_list(1).name));

% % % Making Directories
[keepPath, keepName, keepExt]=fileparts(inputimage);

name='mapping_movie';
mkdir(strcat(ABSPATH_Flow,'\',name,'\'));
name='mapping_figure';
mkdir(strcat(ABSPATH_Flow,'\',name,'\'));
outputfigures_path=strcat(ABSPATH_Flow,'\',name,'\',TiffimageIndex);
mkdir(outputfigures_path);







TotalIteration=maxTotalFrame;
prompt = {'Make figures every X frame:'};
dlgtitle = 'Input';
dims = [1 35];
definput = {num2str(round( TotalIteration/10)-1 )};
answer = inputdlg(prompt,dlgtitle,dims,definput);
OUTITER=str2num(answer{1});
frame=1;

list_outlier = {'Volmetric Strain','Transformed Tensors','Displacement Vectors','Turnover','NONE'};
[indx_outlier,tf] = listdlg('PromptString',{'Select that you want to remove outlier'},'ListString',list_outlier);
list_checkoutlier={1,1,1,1,1};


for iter=1:OUTITER:TotalIteration
    % % % % %     %    Strain field  plot

    [keepMovie,StrainV]=func_strain_mapping(inputTensor_list,  inputimage, iter, frame, ...
        ABSPATH_Flow,list_extension{indx},outputfigures_path,indx_outlier);
    if isnan(keepMovie.cdata)==0
        movie_strain(frame)=keepMovie;
        StrainVall(:,:,iter)=StrainV;
    end
    writematrix(StrainVall,strcat(outputfigures_path,'\',sprintf('%03d',iter),'_VolStrain.txt'),'Delimiter','\t')
    clear keepMovie
    % % % % % % % % Transformed strain field para
    [keepMovie,StrainParallel, List_K]=func_strain_transformed_mapping_para(inputTensor_list,  inputimage, iter, frame, ...
        ABSPATH_Flow,list_extension{indx},outputfigures_path,indx_outlier);
    if isnan(keepMovie.cdata)==0
        movie_strain_trf(frame)=keepMovie;
        Strain_Transform_all(:,:,iter)=StrainParallel;
        writematrix(Strain_Transform_all,strcat(outputfigures_path,'\',sprintf('%03d',iter),'_TrStrain_para.txt'),'Delimiter','\t');
    end

    clear keepMovie
    % % % % % % % % Transformed strain field perp
    [keepMovie,StrainPerp, List_K]=func_strain_transformed_mapping_perp(inputTensor_list,  inputimage, iter, frame, ...
        ABSPATH_Flow,list_extension{indx},outputfigures_path,indx_outlier);
    if isnan(keepMovie.cdata)==0
        movie_strain_trf_perp(frame)=keepMovie;
        Strain_Transform_all_perp(:,:,iter)=StrainPerp;
        writematrix(Strain_Transform_all_perp,strcat(outputfigures_path,'\',sprintf('%03d',iter),'_TrStrain_perp.txt'),'Delimiter','\t');

    end
    clear keepMovie
    % % % % % % %    all vectors plot
    [U_vector,V_vector,keep1Movie,keep2Movie]=func_all_vector_ver3(inputTensor_list,  inputimage, iter, frame, ...
        scale_displacement, scale_velocity,ABSPATH_Flow,list_extension{indx},outputfigures_path,indx_outlier);
    if isnan(keep1Movie.cdata)==0
        movie_disprate(frame)=keep1Movie;
    end
    if isnan(keep2Movie.cdata)==0
        movie_disprate_orient(frame)=keep2Movie;
    end
    Vector=V_vector(:,3:4);
    writematrix(U_vector,strcat(outputfigures_path,'\',sprintf('%03d',iter),'_DisplacementVectors.txt'),'Delimiter','\t');

    %    mean field vectors plot
    [U_mean_vector, V_mean_vector]=func_arrow_meanfield_ver2(inputTensor_list,  inputimage, iter, TotalIteration, ...
        scale_displacement, scale_velocity,ABSPATH_Flow,list_extension{indx},outputfigures_path,indx_outlier);
    %    writematrix(U_mean_vector,strcat('TrStrain_perp.txt'),'Delimiter','\t');

    %   All vector transfromed
    [U_vector_tf,V_vector_tf]=func_all_vector_transformed_ver3(inputTensor_list,  inputimage, iter, frame, ...
        scale_displacement, scale_velocity,ABSPATH_Flow,list_extension{indx},outputfigures_path);



    % % % % % % Nematic Order Para
    [N,Q,EigenValues_of_Q,EigenVec_of_Q, NematicOrderPara]=func_NematicOrder_forAllVectors(Vector(Vector(:,1)~=0,1:2));
    Parameters_NPO(frame,1)=(iter-1)*interval;
    Parameters_NPO(frame,2)=NematicOrderPara;
    AllVectors(:,:,iter)=V_vector;
    AllVectors_tf(:,:,iter)=V_vector_tf;
    %     AllMeanVectors(:,:,iter)=V_mean_vector;

    (iter-1)/TotalIteration*100
    frame=frame+1;
end
% Turnover rate

[MF_K_all]=func_turnover_sumData(inputTensor_list,  inputimage, 1, 1, ...
    ABSPATH_Flow,list_extension{indx},outputfigures_path,indx_outlier);
[fig]=func_MF_mapping_ver2(inputimage, MF_K_all, RAB_Frame, inputTensor_list,pixelsize);
SAVENAME=strcat(outputfigures_path,'\MobileFraction',list_extension{indx});
exportgraphics(fig,SAVENAME,'BackgroundColor','none','Resolution',600);
[fig]=func_turnover_mapping_ver2(inputimage, MF_K_all, RAB_Frame, inputTensor_list,pixelsize);
SAVENAME=strcat(outputfigures_path,'\TurnoverRate',list_extension{indx});
exportgraphics(fig,SAVENAME,'BackgroundColor','none','Resolution',600);
close
writematrix(MF_K_all,strcat(outputfigures_path,'\TurnoverRate.txt'),'Delimiter','\t')

v = VideoWriter(strcat(ABSPATH_Flow,'\mapping_movie\',TiffimageIndex,'_strain.mp4'), 'MPEG-4');
v.FrameRate = frame/4;
open(v);
writeVideo(v, movie_strain)
close(v);

v = VideoWriter(strcat(ABSPATH_Flow,'\mapping_movie\',TiffimageIndex,'_displacementVector.mp4'), 'MPEG-4');
v.FrameRate = frame/4;
open(v);
writeVideo(v, movie_disprate)
close(v);

v = VideoWriter(strcat(ABSPATH_Flow,'\mapping_movie\',TiffimageIndex,'_displacementAngle.mp4'), 'MPEG-4');
v.FrameRate = frame/4;
open(v);
writeVideo(v, movie_disprate_orient)
close(v);

v = VideoWriter(strcat(ABSPATH_Flow,'\mapping_movie\',TiffimageIndex,'_strain_transformed.mp4'), 'MPEG-4');
v.FrameRate = frame/4;
open(v);
writeVideo(v, movie_strain_trf)
close(v);

PARA(1,1)=mean(Parameters_NPO(:,2));
PARA(2,1)=std(Parameters_NPO(:,2));
writematrix(Parameters_NPO,strcat(outputfigures_path,'\NematicOrderParameter_overtime.txt'),'Delimiter','\t')

savefile=strcat(ABSPATH_Flow,'\MATLAB-Results-Flow_oneCell');
mkdir(savefile);
savematfile=strcat(savefile,'\',TiffimageIndex);
save(savematfile)

messagedialog
function messagedialog
d = dialog('Position',[300 300 250 250],'Name','Complete!');

txt = uicontrol('Parent',d,...
    'Style','text',...
    'Position',[20 80 210 100],...
    'String',['Distribution and variables were saved in "mapping_figure" and "mapping_movie".' ...
    'Variables were saved in "MATLAB-Results-Flow_oneCell as well".']);

btn = uicontrol('Parent',d,...
    'Position',[85 20 70 25],...
    'String','Close',...
    'Callback','delete(gcf)');

end