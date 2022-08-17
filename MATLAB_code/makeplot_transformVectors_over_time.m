clear
close all

waitfor(msgbox(['Select TIFF file of whole cell image that was converted' ...
    ' from original LSM image. File sould be under tifimage-chX folder.']));

[inputimage, ABSPATH_transform]=uigetfile(strcat(pwd,'\.tif'));

tiff_info = imfinfo(inputimage);
[im_filepath, im_filename, im_extension]=fileparts(inputimage);
imageindex=im_filename;
resolution=tiff_info(1).XResolution; %um
addpath (ABSPATH_transform)
TiffimageIndex=imageindex;
% Pre_frame=1;

list = {'PNG','TIFF','PDF','EPS'};
[indx,tf] = listdlg('PromptString',{'Select output file type'},'ListString',list,'SelectionMode','single');
list_extension={'.png','.tif','.pdf','.eps'};

inputdire=strcat(ABSPATH_transform,'\MATLAB-Results-Tensor');
input_SF_orient=dir(strcat(ABSPATH_transform,'\DominantDirection_SFs\',TiffimageIndex,'*.txt'));
list_input_transform=dir(strcat(inputdire,'\',TiffimageIndex,'*.mat'));
savefile_trans=strcat(ABSPATH_transform,'\MATLAB-Results-Defvector_transformed');
mkdir(savefile_trans);
outputimage=strcat(ABSPATH_transform,'\Displacement_transformed_over_time\');
mkdir(outputimage);

for j_transform=1:length(list_input_transform)
    filename=strcat(input_SF_orient(j_transform).folder,'\', input_SF_orient(j_transform).name);
    data=dlmread(filename,'\t',1,0);            %%%data(time,2)=degree of SF at time
% % %     % transform matrix
    
    [pathkeep, namekeep, extkeep]=fileparts(filename);
    load(strcat(list_input_transform(j_transform).folder,'\',namekeep,'.mat'))
    theta_SF= mean( data(1:Pre_frame,2) ) ;
    L=[ cosd(abs(theta_SF)),	cosd(90-theta_SF);...
        cosd(90+theta_SF),	  cosd(abs(theta_SF))];
    

    Def_vec_tf=zeros(length(Def_vec),2);
              
        for k=1:length(Def_vec)
            Def_vec_tf(k,:)=(L.'*Def_vec(k,1:2).').';                     %%um
%             VelosityVectorList_tf(k,:,i)=Def_vec_tf(k,:,i)./(i*interval);
        end
        
        figure
            hold on
            p1=plot (TimeForPlot.',Def_vec_tf(:,1),'-go');
            p2=plot (TimeForPlot.',Def_vec_tf(:,2),'-mo');
            p1.Marker='o';
            p1.MarkerEdgeColor='g';
            p1.MarkerFaceColor='g';
            p1.MarkerSize=4;
            p2.Marker='^';
            p2.MarkerEdgeColor='m';
            p2.MarkerFaceColor='m';
            p2.MarkerSize=4;
            ax=gca;
            ax.FontSize=18;
            ax.FontName='Arial';
            xlim([0 interval*SizeOfMatrix - 1  ])
            axtoolbar('Visible','off');
            ax.YAxis.TickLabelFormat='%.1f';
            xlabel('Time\fontname{Times New Roman}\it t \fontname{Arial}\rm(sec)');
            ylabel(strcat('Displacement \fontname{Times New Roman}\itu_{\rm\mid\mid}, \itu_{\rm\perp} \fontname{Arial}\rm(',char(181),'m)'));
            lgd=legend('\fontname{Times New Roman}\itu_{\rm\mid\mid}',...
                                '\fontname{Times New Roman}\itu_{\rm\perp}');
            lgd.FontSize=16;
            lgd.Location='northwest';
            lgd.NumColumns=1;
            savename_strain=strcat(outputimage,filenum,list_extension{indx});
            exportgraphics(gcf,savename_strain,'Resolution',600,'BackgroundColor','none','ContentType','vector');
            hold off
        
        savematfile_trans=strcat(savefile_trans,'\',list_input_transform(j_transform).name);
        save(savematfile_trans);
        close all
end

messagedialog
function messagedialog
    d = dialog('Position',[300 300 250 250],'Name','Complete!');

    txt = uicontrol('Parent',d,...
               'Style','text',...
               'Position',[20 80 210 140],...
               'String',['Time changes of variables were saved in "Deformation_transformed" and' ...
               ' variables were saved in "MATLAB-Results-Defvector_transformed".']);

    btn = uicontrol('Parent',d,...
               'Position',[85 20 70 25],...
               'String','Close',...
               'Callback','delete(gcf)');

end
