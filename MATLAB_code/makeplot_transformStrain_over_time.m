% % After tensor_transform_verXX.m
% % plot with xaxis and yaxis correnspond to time and transformed mechanical properties



















clear 
close all

[inputimage, ABSPATH_mkAMA]=uigetfile(strcat(pwd,'\.tif'));

tiff_info = imfinfo(inputimage);
[im_filepath, im_filename, im_extension]=fileparts(inputimage);
imageindex=im_filename;
resolution=tiff_info(1).XResolution; %um
addpath (ABSPATH_mkAMA);


inputdire=strcat(ABSPATH_mkAMA,'\MATLAB-Results-Tensor_transformed');

list_input_SMA=dir(strcat(inputdire,'\*.mat'));

SMArange=1;






list = {'PNG','TIFF','PDF','EPS'};
[indx,tf] = listdlg('PromptString',{'Select output file type'},'ListString',list,'SelectionMode','single');
list_extension={'.png','.tif','.pdf','.eps'};

















% imagelist=dir(strcat(ABSPATH_TENSOR,'\tensor-coordinates\',imageindex,'*'));
mkdir(strcat(ABSPATH_mkAMA,'\StrainOverTime_transformed\'));
mkdir(strcat(ABSPATH_mkAMA,'\StrainRateOverTime_transformed\'));
mkdir(strcat(ABSPATH_mkAMA,'\Green-Almandi-StrainOverTime_transformed\'));
mkdir(strcat(ABSPATH_mkAMA,'\Green-Almandi-StrainOverTime\'));

mkdir(strcat(ABSPATH_mkAMA,'\MATLAB-Results-transform_mkplot_overtime\'));


% j_SMA=1;
for j_SMA=1:length(list_input_SMA)
    load(strcat(list_input_SMA(j_SMA).folder,'\',list_input_SMA(j_SMA).name))
% % %     Plot strains
        [Vs,Ds]=eig(StrainTensor_tf(:,:,iter));
        TimeForPlot=[1:SizeOfMatrix-1];
        TimeForPlot=TimeForPlot*interval;
% % % Intialize of Error matrix
        Error_Green_Almansi_tr=zeros(SizeOfMatrix-1,3);
        Error_Green_Almansi=zeros(SizeOfMatrix-1,5);
        Error_ver_para=zeros(SizeOfMatrix-1,3);
%         
% % %         Plot parallel to SF
        figure         
        hold on
        ax=gca;
        ax.FontSize=18;
        ax.FontName='Arial';
        p1=plot(TimeForPlot, strain_parallel,'-ko' );
        p1.Marker='o';
        p1.MarkerEdgeColor='k';
        p1.MarkerFaceColor='b';
        p1.MarkerSize=4;        
        xlim([0 interval*SizeOfMatrix - 1  ])
%         xticks([0:200:1000])
        axtoolbar('Visible','off');
        ax.YAxis.TickLabelFormat='%.2f';
        xlabel('Time\fontname{Times New Roman}\it t \fontname{Arial}\rm(sec)');
        ylabel(strcat('Strain \fontname{Times New Roman}\it',char(949),'_{\rm\mid\mid}'));
        savename_strain=strcat(ABSPATH_mkAMA,'\StrainOverTime_transformed\',filenum,'-parallel',list_extension{indx});
        exportgraphics(gcf,savename_strain,'Resolution',600,'BackgroundColor','none','ContentType','vector');
        hold off

% %%Plot strain rate parallel to SF
        figure
        hold on
        ax=gca;
        ax.FontSize=18;
        ax.FontName='Arial';
        p1=plot(TimeForPlot, strainrate_parallel,'-ko' );
        p1.Marker='o';
        p1.MarkerEdgeColor='k';
        p1.MarkerFaceColor='g';
        p1.MarkerSize=4;  
        xlim([0 interval*SizeOfMatrix - 1  ])
%         xticks([0:200:1000])
        axtoolbar('Visible','off');
        ax.YAxis.TickLabelFormat='%.2f';
        xlabel('Time\fontname{Times New Roman}\it t \fontname{Arial}\rm(s)');
        ylabel(strcat('Strain rate \fontname{Times New Roman}\it',char(949),'_{\rm\mid\mid}^{\prime} \fontname{Arial}\rm(1/s)'));
        savename_strain=strcat(ABSPATH_mkAMA,'\StrainRateOverTime_transformed\',filenum,'-parallel',list_extension{indx});
        exportgraphics(gcf,savename_strain,'Resolution',600,'BackgroundColor','none','ContentType','vector');
        hold off

% %%Plot strain rate vertical to SF
        figure
        hold on
        ax=gca;
        ax.FontSize=18;
        ax.FontName='Arial';
        p1=plot(TimeForPlot, strainrate_vertical,'-k^' );
        p1.Marker='^';
        p1.MarkerEdgeColor='m';
        p1.MarkerFaceColor='m';
        p1.MarkerSize=4;  
        xlim([0 interval*SizeOfMatrix - 1  ])
%         xticks([0:200:1000])
        axtoolbar('Visible','off');
        ax.YAxis.TickLabelFormat='%.2f';
        xlabel('Time\fontname{Times New Roman}\it t \fontname{Arial}\rm(s)');
        ylabel(strcat('Strain rate \fontname{Times New Roman}\it',char(949),'_{\rm\perp}^{\prime} \fontname{Arial}\rm(1/s)'));
        savename_strain=strcat(ABSPATH_mkAMA,'\StrainRateOverTime_transformed\',filenum,'-vertical',list_extension{indx});
        exportgraphics(gcf,savename_strain,'Resolution',600,'BackgroundColor','none','ContentType','vector');
        hold off
% % % GreenAlmandiTensorPlot parallel to SFs
        figure
        hold on
        ax=gca;
        ax.FontSize=18;
        ax.FontName='Arial';
        p1=plot(TimeForPlot, Green_tr_para,'-go' );
        p1.Marker='o';
        p1.MarkerEdgeColor='g';
        p1.MarkerFaceColor='g';
        p1.MarkerSize=4;
        p2=plot(TimeForPlot, Almandi_tr_para,'-m+' );
        p2.Marker='*';
        p2.MarkerEdgeColor='m';
        p2.MarkerFaceColor='m';
        p2.MarkerSize=5;             
        xlim([0 interval*SizeOfMatrix - 1  ])
%         xticks([0:200:1000])
        axtoolbar('Visible','off');
        ax.YAxis.TickLabelFormat='%.2f';
        xlabel('Time\fontname{Times New Roman}\it t \fontname{Arial}\rm(sec)');
        ylabel(strcat('Strain \fontname{Times New Roman}\itE_{\rm\mid\mid}, \ite_{\rm\mid\mid}'));
        lgd=legend(strcat('\fontname{Times New Roman}\it\itE_{\rm\mid\mid}'),...
            strcat('\fontname{Times New Roman}\ite_{\rm\mid\mid}'));
        lgd.FontSize=16;
        lgd.Location='northwest';
        lgd.NumColumns=1;
        savename_strain=strcat(ABSPATH_mkAMA,'\Green-Almandi-StrainOverTime_transformed\',filenum,'-para',list_extension{indx});
        exportgraphics(gcf,savename_strain,'Resolution',600,'BackgroundColor','none','ContentType','vector');
        hold off
        close all
%%%GreenAlmandiTensorPlot perpendicular to SFs
        figure
        hold on
        ax=gca;
        ax.FontSize=18;
        ax.FontName='Arial';
        p1=plot(TimeForPlot, Green_tr_ver,'-go' );
        p1.Marker='o';
        p1.MarkerEdgeColor='g';
        p1.MarkerFaceColor='g';
        p1.MarkerSize=4;
        p2=plot(TimeForPlot, Almandi_tr_ver,'-m*' );
        p2.Marker='*';
        p2.MarkerEdgeColor='m';
        p2.MarkerFaceColor='m';
        p2.MarkerSize=5;             
        xlim([0 interval*SizeOfMatrix - 1  ])
%         xticks([0:200:1000])
        axtoolbar('Visible','off');
        ax.YAxis.TickLabelFormat='%.2f';
        xlabel('Time\fontname{Times New Roman}\it t \fontname{Arial}\rm(sec)');
        ylabel(strcat('Strain \fontname{Times New Roman}\itE_{\rm\perp}, \ite_{\rm\perp}'));
        lgd=legend(strcat('\fontname{Times New Roman}\it\itE_{\rm\perp}'),...
            strcat('\fontname{Times New Roman}\ite_{\rm\perp}'));
        lgd.FontSize=16;
        lgd.Location='northwest';
        lgd.NumColumns=1;
        savename_strain=strcat(ABSPATH_mkAMA,'\Green-Almandi-StrainOverTime_transformed\',filenum,'-ver',list_extension{indx});
        exportgraphics(gcf,savename_strain,'Resolution',600,'BackgroundColor','none','ContentType','vector');
        hold off
% % %         (Green-Almandi)/Green parallel to SFs
        figure
        Error_Green_Almansi_tr(:,1)=    TimeForPlot.';
        Error_Green_Almansi_tr(:,2)=    abs( (Green_tr_para-Almandi_tr_para)./Green_tr_para);
        Error_Green_Almansi_tr(:,3)=	abs( (Green_tr_ver-Almandi_tr_ver)./Green_tr_ver);
        p1=semilogy(TimeForPlot, abs( (Green_tr_para-Almandi_tr_para)./Green_tr_para), '-ko' );
        p1.Marker='o';
        p1.MarkerEdgeColor='k';
        p1.MarkerFaceColor='c';
        p1.MarkerSize=4;
        hold on
        ax=gca;
        ax.FontSize=18;
        ax.FontName='Arial';
        xlim([0 interval*SizeOfMatrix - 1  ])
%         xticks([0:200:1000])
        axtoolbar('Visible','off');
        ax.YAxis.TickLabelFormat='%.2f';
        xlabel('Time\fontname{Times New Roman}\it t \fontname{Arial}\rm(sec)');
        ylabel(strcat('\fontname{Times New Roman}\rm|(\itE_{\rm\mid\mid} \rm- \ite_{\rm\mid\mid}\rm) / \itE_{\rm\mid\mid}\rm|'));
        savename_strain=strcat(ABSPATH_mkAMA,'\Green-Almandi-StrainOverTime_transformed\',filenum,'-error-para',list_extension{indx});
        exportgraphics(gcf,savename_strain,'Resolution',600,'BackgroundColor','none','ContentType','vector');
        hold off
        close all
% % %         (Green-Almandi)/Green perpendicular to SFs
        figure
        p1=semilogy(TimeForPlot, abs( (Green_tr_ver-Almandi_tr_ver)./Green_tr_ver), '-k^' );
        p1.Marker='^';
        p1.MarkerEdgeColor='k';
        p1.MarkerFaceColor='c';
        p1.MarkerSize=4;
        hold on
        ax=gca;
        ax.FontSize=18;
        ax.FontName='Arial';
        xlim([0 interval*SizeOfMatrix - 1  ])
%         xticks([0:200:1000])
        axtoolbar('Visible','off');
        ax.YAxis.TickLabelFormat='%.2f';
        xlabel('Time\fontname{Times New Roman}\it t \fontname{Arial}\rm(sec)');
        ylabel(strcat('\fontname{Times New Roman}\rm|(\itE_{\rm\perp} \rm- \ite_{\rm\perp}\rm) / \itE_{\rm\perp}\rm|'));
        savename_strain=strcat(ABSPATH_mkAMA,'\Green-Almandi-StrainOverTime_transformed\',filenum,'-error-ver',list_extension{indx});
        exportgraphics(gcf,savename_strain,'Resolution',600,'BackgroundColor','none','ContentType','vector');
        hold off
%%Plot vertical to SF
        figure
        hold on
        ax=gca;
        ax.FontSize=18;
        ax.FontName='Arial';
        p1=plot(TimeForPlot, strain_vertical,'-k^' );
        p1.Marker='^';
        p1.MarkerEdgeColor='k';
        p1.MarkerFaceColor='b';
        p1.MarkerSize=4;
        xlim([0 interval*SizeOfMatrix - 1  ])
%         xticks([0:200:1000])
        axtoolbar('Visible','off');
        ax.YAxis.TickLabelFormat='%.2f';
        xlabel('Time\fontname{Times New Roman}\it t \fontname{Arial}\rm(sec)');
        ylabel(strcat('Strain \fontname{Times New Roman}\it',char(949),'_{\rm\perp}'));
        savename_strain=strcat(ABSPATH_mkAMA,'\StrainOverTime_transformed\',filenum,'-vertical',list_extension{indx});
        exportgraphics(gcf,savename_strain,'Resolution',600,'BackgroundColor','none','ContentType','vector');
        hold off
        close all
        
% % %%Plot vertical/parallel
        figure
        Error_ver_para(:,1)= TimeForPlot.';
        Error_ver_para(:,2)= abs(strain_vertical./strain_parallel);
        p1=semilogy(TimeForPlot, abs(strain_vertical./strain_parallel),'-ko' );
        p1.Marker='o';
        p1.MarkerEdgeColor='k';
        p1.MarkerFaceColor='c';
        p1.MarkerSize=4;
        ax=gca;
        ax.FontSize=18;
        ax.FontName='Arial';
        xlim([0 interval*SizeOfMatrix - 1  ])
%         xticks([0:200:1000])
        axtoolbar('Visible','off');
        ax.YAxis.TickLabelFormat='%.2f';
        xlabel('Time\fontname{Times New Roman}\it t \fontname{Arial}\rm(sec)');
        ylabel(strcat('\fontname{Times New Roman}\rm|\it',char(949),'_{\rm\perp}/ \it',char(949),'_{\rm\mid\mid}\rm|'));
        savename_strain=strcat(ABSPATH_mkAMA,'\StrainOverTime_transformed\',filenum,'-error',list_extension{indx});
        exportgraphics(gcf,savename_strain,'Resolution',600,'BackgroundColor','none','ContentType','vector');
        hold off
        close all
    
% %%Plot E and e not transformed
        figure
        hold on
        p1=plot(TimeForPlot, Green_para,'-go' );
        p3=plot(TimeForPlot, Green_12,'-b*' );
        p4=plot(TimeForPlot, Green_ver,'-k^' );
        ax=gca;
        ax.FontSize=18;
        ax.FontName='Arial';
        xlim([0 interval*SizeOfMatrix - 1  ])
%         xticks([0:200:1000])
        axtoolbar('Visible','off');
        ax.YAxis.TickLabelFormat='%.2f';
        ylim([-0.5 0.5]);
        yticks([-0.5 -0.25 0 0.25 0.5]);
        xlabel('Time\fontname{Times New Roman}\it t \fontname{Arial}\rm(sec)');
        ylabel(strcat("Green's strain \fontname{Times New Roman}\itE_{\rmij}"));
        lgd=legend(strcat('\fontname{Times New Roman}\iti\rm=1, \itj\rm=1'),...
                           strcat('\fontname{Times New Roman}\iti\rm=1, \itj\rm=2'),...
                           strcat('\fontname{Times New Roman}\iti\rm=2, \itj\rm=2'));
        lgd.FontSize=16;
        lgd.Location='southwest';
        lgd.NumColumns=1;
        savename_strain=strcat(ABSPATH_mkAMA,'\Green-Almandi-StrainOverTime\',filenum,'-Green',list_extension{indx});
        exportgraphics(gcf,savename_strain,'Resolution',600,'BackgroundColor','none','ContentType','vector');
        hold off
        
        figure
        hold on
        p5=plot(TimeForPlot, Almandi_para,'-.go' );
%         p6=plot(TimeForPlot, Almandi_21,'-.r+' );
        p7=plot(TimeForPlot, Almandi_12,'-.b*' );
        p8=plot(TimeForPlot, Almandi_ver,'-.k^' );
        ax=gca;
        ax.FontSize=18;
        ax.FontName='Arial';
        xlim([0 interval*SizeOfMatrix - 1  ])
%         xticks([0:200:1000])
        axtoolbar('Visible','off');
        ax.YAxis.TickLabelFormat='%.2f';
        ylim([-0.5 0.5]);
        yticks([-0.5 -0.25 0 0.25 0.5]);
        xlabel('Time\fontname{Times New Roman}\it t \fontname{Arial}\rm(sec)');
        ylabel(strcat("Almansi's strain \fontname{Times New Roman}\ite_{\rmij}"));
        lgd=legend(strcat('\fontname{Times New Roman}\iti\rm=1, \itj\rm=1'),...
                           strcat('\fontname{Times New Roman}\iti\rm=1, \itj\rm=2'),...
                           strcat('\fontname{Times New Roman}\iti\rm=2, \itj\rm=2'));
        lgd.FontSize=16;
        lgd.Location='southwest';
        lgd.NumColumns=1;
        savename_strain=strcat(ABSPATH_mkAMA,'\Green-Almandi-StrainOverTime\',filenum,'-Almansi',list_extension{indx});
        exportgraphics(gcf,savename_strain,'Resolution',600,'BackgroundColor','none','ContentType','vector');
        hold off
% %%Plot error betw E and e not transformed 
        figure
        Error_Green_Almansi(:,1)=	TimeForPlot.';
        Error_Green_Almansi(:,2)=	abs((Green_para-Almandi_para)./Green_para);
        Error_Green_Almansi(:,3)=	abs((Green_21-Almandi_21)./Green_21);
        Error_Green_Almansi(:,4)=	abs((Green_12-Almandi_12)./Green_12);
        Error_Green_Almansi(:,5)=   abs((Green_ver-Almandi_ver)./Green_ver);

        p1=semilogy(TimeForPlot, abs((Green_para-Almandi_para)./Green_para),'-go' ,...
                             TimeForPlot, abs((Green_12-Almandi_12)./Green_12),'-b*' ,...
                             TimeForPlot, abs((Green_ver-Almandi_ver)./Green_ver),'-k^'  );
        hold on
        ax=gca;
        ax.FontSize=18;
        ax.FontName='Arial';
        xlim([0 interval*SizeOfMatrix - 1  ])
%         xticks([0:200:1000])
        axtoolbar('Visible','off');
        ax.YAxis.TickLabelFormat='%.2f';
        xlabel('Time\fontname{Times New Roman}\it t \fontname{Arial}\rm(sec)');
        ylabel(strcat('\fontname{Times New Roman}\rm|(\itE_{\rmij}-\ite_{\rmij}\rm)/\itE_{\rmij}\rm|'));
        lgd=legend(strcat('\fontname{Times New Roman}\iti\rm=1, \itj\rm=1'),...
                           strcat('\fontname{Times New Roman}\iti\rm=1, \itj\rm=2'),...
                           strcat('\fontname{Times New Roman}\iti\rm=2, \itj\rm=2'));
        lgd.FontSize=16;
        lgd.Location='southeast';
        lgd.NumColumns=1;
        savename_strain=strcat(ABSPATH_mkAMA,'\Green-Almandi-StrainOverTime\',filenum,'-error',list_extension{indx});
        exportgraphics(gcf,savename_strain,'Resolution',600,'BackgroundColor','none','ContentType','vector');
        hold off
close all

save(strcat(ABSPATH_mkAMA,'\MATLAB-Results-transform_mkplot_overtime\',list_input_SMA(j_SMA).name));
end
messagedialog
function messagedialog
    d = dialog('Position',[300 300 250 250],'Name','Complete!');

    txt = uicontrol('Parent',d,...
               'Style','text',...
               'Position',[20 80 210 40],...
               'String',['Time changes of variables were saved in "StrainOverTime_transformed","StrainRateOverTime_transformed"' ...
               '"Green-Almandi-StrainOverTime_transformed", "Green-Almandi-StrainOverTime" and' ...
               ' variables were saved in "MATLAB-Results-transform_mkplot_overtime".']);

    btn = uicontrol('Parent',d,...
               'Position',[85 20 70 25],...
               'String','Close',...
               'Callback','delete(gcf)');

end
