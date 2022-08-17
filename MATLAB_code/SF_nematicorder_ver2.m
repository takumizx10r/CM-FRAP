clear
close all

waitfor(msgbox(['Select TIFF file of whole cell image that was converted' ...
    ' from original LSM image. File sould be under tifimage-chX folder.']));




[inputimage, ABSPATH_Flow_SF]=uigetfile(strcat(pwd,'\.tif'));

tiff_info = imfinfo(inputimage);
[im_filepath, im_filename, im_extension]=fileparts(inputimage);
imageindex=im_filename;
resolution=tiff_info(1).XResolution; %um
TiffimageIndex=imageindex;
addpath(ABSPATH_Flow_SF);
list = {'PNG','TIFF','PDF','EPS'};
[indx,tf] = listdlg('PromptString',{'Select output file type'},'ListString',list,'SelectionMode','single');
list_extension={'.png','.tif','.pdf','.eps'};

prompt = {'Make figures every X frame:'};
dlgtitle = 'Input';
dims = [1 35];
definput = {num2str(round( length(tiff_info)/10)-1 )};
answer = inputdlg(prompt,dlgtitle,dims,definput);

OUTITER_Histogram=str2num(answer{1}); 
scale_displacement=000;
scale_velocity=12000;














mkdir(strcat(ABSPATH_Flow_SF,'\Histo-angle\'));
inputImagepath=dir(strcat(ABSPATH_Flow_SF,'\tifimage-ch1\',TiffimageIndex,'*'));
inputimage=strcat(inputImagepath.folder,'\',inputImagepath.name);
inputTensor_list=dir(strcat(ABSPATH_Flow_SF,'\MATLAB-Results-Flow\',TiffimageIndex,'*'));

% [PathOfTensor, NameOfTensor, ExtOfTensor]=fileparts(inputTensor_list(1).name);
inputCorrect=dir(strcat(ABSPATH_Flow_SF,'\rectangle_coordinate_to_correct\',TiffimageIndex,'*.txt'));

input_load_list=dir(strcat(ABSPATH_Flow_SF,'\MATLAB-Results-Flow\',TiffimageIndex,'*.mat'));
load(strcat(input_load_list(1).folder,'\',input_load_list(1).name));

input_SF_orient=dir(strcat(ABSPATH_Flow_SF,'\DominantDirection_SFs\',TiffimageIndex,'*.txt'));

Maxiter=SizeOfMatrix-1;
% for iter=1:1
for iter=1:Maxiter
    
    for filei=1:length(input_SF_orient)
        filename=strcat(input_SF_orient(filei).folder,'\', input_SF_orient(filei).name);
        [pathkeep, namekeep, extkeep]=fileparts(filename);
        data=dlmread(filename,'\t',1+RAB_Frame,0);
        load(strcat(ABSPATH_Flow_SF,'\MATLAB-Results-Flow\',namekeep,'.mat'));
        sz_DefVecList=size(DeformationVectorList);
        
        if (iter<=sz_DefVecList(3))

        keepAV=DeformationVectorList(:,:,iter);
        keepAllVector( (4*filei-3):(4*filei), 1:2 )=keepAV(1:4,1:2); % 1:2 Deformation, 3:4 SF
        keepAllVector( (4*filei-3):(4*filei), 3:4 )=[1.0*cosd(data(iter,2)) 1.0*sind(data(iter,2));
            1.0*cosd(data(iter,2)) 1.0*sind(data(iter,2));
            1.0*cosd(data(iter,2)) 1.0*sind(data(iter,2));
            1.0*cosd(data(iter,2)) 1.0*sind(data(iter,2))];
        else
            keepAllVector((4*filei-3):(4*filei), 1:5)=0;
        end                                                       
%         keepSFVector((4*filei-3):(4*filei), 1:2)=[1.0*cosd(data(iter,2)) 1.0*sind(data(iter,2));
%                                                                     1.0*cosd(data(iter,2)) 1.0*sind(data(iter,2));
%                                                                     1.0*cosd(data(iter,2)) 1.0*sind(data(iter,2));
%                                                                     1.0*cosd(data(iter,2)) 1.0*sind(data(iter,2))];
    end
    keepAllVector(:,5)=abs(keepAllVector(:,1).*keepAllVector(:,3) + keepAllVector(:,2).*keepAllVector(:,4)) ./ ...
            (sqrt(keepAllVector(:,1).*keepAllVector(:,1)+keepAllVector(:,2).*keepAllVector(:,2)) .* sqrt(keepAllVector(:,3).*keepAllVector(:,3)+keepAllVector(:,4).*keepAllVector(:,4)) );
    
	P(1:length(keepAllVector),1:5,iter)=keepAllVector(:,:);

% % %     
% % %     % % Nematic Order Para of SFs
% % %     if mean(all(Vector(:,:,iter)))~=0
keepf=find(keepAllVector(:,3)~=0);
% keepVector=keepAllVector(keepf,3:4);
[N,Q,EigenValues_of_Q,EigenVec_of_Q, NematicOrderPara]=func_NematicOrder_forAllVectors(keepAllVector(:,3:4));
% % %         if isempty(NematicOrderPara)==0
NOP_SF(iter,1)=(iter-1)*interval;
NOP_SF(iter,2)=NematicOrderPara;
% % %         end
% % %     end
% % %         %     NematicOrderPara
% % % %     AllVectors(:,:,iter)=V_vector;
% % % %     AllMeanVectors(:,:,iter)=V_mean_vector;

end
PARA_SF(1,1)=mean(NOP_SF(:,2));
PARA_SF(2,1)=std(NOP_SF(:,2));
savefile=strcat(ABSPATH_Flow_SF,'\MATLAB-Results-SF-Flow-Orient-Nematics');
mkdir(savefile);
savefile=strcat(ABSPATH_Flow_SF,'\MATLAB-Results-SF-Flow-Orient-Nematics\SF_nematic\');
mkdir(savefile);
savematfile=strcat(savefile,TiffimageIndex);
save(savematfile)
writematrix(PARA_SF,strcat(savefile,'NematicOrderParameter_SFs_timeAve_',TiffimageIndex,'.txt'),'Delimiter','tab')


% % % Make histgram of angle bet SF and V
for iter=1:OUTITER_Histogram:Maxiter
    keepf=find(keepAllVector(:,3)~=0);

    datahist=P(keepf,5,iter);
    time=(iter-1)*interval;
    savename=strcat(ABSPATH_Flow_SF,'\Histo-angle\',TiffimageIndex,sprintf('-%.3d',(iter-1)*interval),list_extension{indx});
    func_make_histgram(datahist,savename,time)
end


messagedialog
function messagedialog
    d = dialog('Position',[300 300 250 300],'Name','Complete!');

    txt = uicontrol('Parent',d,...
               'Style','text',...
               'Position',[20 80 210 200],...
               'String',['Histogram of angle of vectors was saved in "Histo-angle" and vaariables were' ...
               ' saven in "MATLAB-Results-SF-Flow-Orient-Nematics".']);

    btn = uicontrol('Parent',d,...
               'Position',[85 20 70 25],...
               'String','Close',...
               'Callback','delete(gcf)');

end