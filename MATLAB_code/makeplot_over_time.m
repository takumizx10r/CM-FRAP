clear
close all

waitfor(msgbox(['Select TIFF file of whole cell image that was converted' ...
    ' from original LSM image. File sould be under tifimage-chX folder.']));











[inputimage, ABSPATH_mkAMA]=uigetfile(strcat(pwd,'\.tif'));

tiff_info = imfinfo(inputimage);
[im_filepath, im_filename, im_extension]=fileparts(inputimage);
imageindex=im_filename;
resolution=tiff_info(1).XResolution; %um

inputdire=strcat(ABSPATH_mkAMA,'\MATLAB-Results-Tensor');

list_input_SMA=dir(strcat(inputdire,'\*.mat'));
addpath (ABSPATH_mkAMA);

SMArange=1;

list = {'PNG','TIFF','PDF','EPS'};
[indx,tf] = listdlg('PromptString',{'Select output file type'},'ListString',list,'SelectionMode','single');
list_extension={'.png','.tif','.pdf','.eps'};






















% imagelist=dir(strcat(ABSPATH_TENSOR,'\tensor-coordinates\',imageindex,'*'));
mkdir(strcat(ABSPATH_mkAMA,'\StrainOverTime\'));
mkdir(strcat(ABSPATH_mkAMA,'\StrainRateOverTime\'));
mkdir(strcat(ABSPATH_mkAMA,'\DisplacementOverTime\'));
mkdir(strcat(ABSPATH_mkAMA,'\FlowOverTime\'));
mkdir(strcat(ABSPATH_mkAMA,'\RecoveryCurves\'));

% for j_SMA=1:17
for j_SMA=1:length(list_input_SMA)
    load(strcat(list_input_SMA(j_SMA).folder,'\',list_input_SMA(j_SMA).name))

        TimeForPlot=[1:SizeOfMatrix-1];
        TimeForPlot=TimeForPlot*interval;
        

        
        %     Plot strains
        Keepf=find(PrincipalInvariant_Strain(:,1) ~= 0);
        KeepA=PrincipalInvariant_Strain(Keepf,1);
        M = movmean(KeepA,SMArange);
        figure
        hold on
        ax=gca;
        ax.FontSize=18;
        ax.FontName='Arial';
        p1=plot(TimeForPlot(Keepf), M,'-k' );
        p1.Marker='o';
        p1.MarkerEdgeColor='k';
        p1.MarkerFaceColor='b';
        p1.MarkerSize=4;        
        xlim([0 interval*SizeOfMatrix - 1  ])
%         xticks([0:200:1000])
        axtoolbar('Visible','off');
        ax.YAxis.TickLabelFormat='%.2f';
        xlabel('Time\fontname{Times New Roman}\it t \fontname{Arial}\rm(s)');
        ylabel(strcat('Volumetric strain\fontname{Times New Roman} \it',char(949),'_{\rmv}'));
        savename_strain=strcat(ABSPATH_mkAMA,'\StrainOverTime\',filenum,list_extension{indx});
        exportgraphics(gcf,savename_strain,'Resolution',600,'BackgroundColor','none','ContentType','vector');
        hold off

% % % % %        Volume Strain Rate 
        KeepStrainRate=PrincipalInvariant_Strain(:,1)./(TimeForPlot(1,:).' );
        Keepf=find(KeepStrainRate ~= 0);
        AveStrainRate=mean(KeepStrainRate(round(Keepf/2):Keepf));
        KeepA=KeepStrainRate(Keepf);
        M = movmean(KeepA,SMArange);       
        figure
        hold on
        ax=gca;
        ax.FontSize=18;
        ax.FontName='Arial';
        p2=plot(TimeForPlot(Keepf), M,'-k');
        p2.Marker='o';
        p2.MarkerEdgeColor='k';
        p2.MarkerFaceColor='b';
        p2.MarkerSize=4;        
        ax.YAxis.TickLabelFormat='%.1f';
        xlim([0 Inf ])
        axtoolbar('Visible','off');
        xlabel('Time\fontname{Times New Roman}\it t \fontname{Arial}\rm(s)');
        ylabel(strcat('Volumetric strain rate \fontname{Times New Roman}\it',char(949),'_{\rmv}^{\prime} \fontname{Arial}\rm(1/s)'));
        savename_strain=strcat(ABSPATH_mkAMA,'\StrainRateOverTime\',filenum,list_extension{indx});
        exportgraphics(gcf,savename_strain,'Resolution',600,'BackgroundColor','none','ContentType','vector');
        hold off
% % %            Deformation  
        KeepDef=ArrowNorm;
        Keepf=find(KeepDef ~= 0);
%         AveDeformation=mean(KeepDef(Keepf))
        KeepA=ArrowNorm(Keepf);
        M = movmean(KeepA,SMArange);     
        figure
        hold on
        ax=gca;
        ax.FontSize=18;
        ax.FontName='Arial';
        p3=plot(TimeForPlot(Keepf), M,'-k');
%         p2=plot(TimeForPlot(Keepf), fun(DispRate_FitLinear, TimeForPlot(Keepf)),'k' );
%         lgd=legend('\fontname{Times New Roman}|\it\bfu\rm|',....
%             '\fontname{Times New Roman}\itf\rm(\itt\rm)=\itvt');
%         lgd.FontSize=12;
%         lgd.Location='northwest';
        p3.Marker='o';
        p3.MarkerEdgeColor='k';
        p3.MarkerFaceColor='b';
        p3.MarkerSize=4;  
        ax.YAxis.TickLabelFormat='%.1f';
        xlim([0 Inf ])
%         xticks([0:200:1000])
        axtoolbar('Visible','off');
        xlabel('Time\fontname{Times New Roman}\it t \fontname{Arial}\rm(s)');
        ylabel(strcat('Norm of displacement \fontname{Times New Roman}|\it\bfu\rm| \fontname{Arial}\rm(',char(181),'m)'));
        savename_strain=strcat(ABSPATH_mkAMA,'\DisplacementOverTime\',filenum,list_extension{indx});
        exportgraphics(gcf,savename_strain,'Resolution',600,'BackgroundColor','none','ContentType','vector');
        hold off
% % %             Flow Rate
        KeepFlow=ArrowNorm./(TimeForPlot(1,:).' );
        Keepf=find(KeepFlow ~= 0);
        AveFlow=mean(KeepFlow(round(Keepf/2):Keepf));
        KeepA=KeepFlow(Keepf);
        M = movmean(KeepA,SMArange);    
        figure
        hold on
        ax=gca;
        ax.FontSize=16;
        ax.FontName='Arial';
        ax.YAxis.TickLabelFormat='%.1f';
        p4=plot(TimeForPlot(Keepf), M(Keepf),'-k');
        p4.Marker='o';
        p4.MarkerEdgeColor='k';
        p4.MarkerFaceColor='b';
        p4.MarkerSize=4;        
        xlim([0 Inf])
        axtoolbar('Visible','off');
        xlabel('Time\fontname{Times New Roman}\it t \fontname{Arial}\rm(s)');
        ylabel(strcat('Norm of displacement rate \fontname{Times New Roman}|\it\bfv\rm| \fontname{Arial}\rm(',char(181),'m/s)'));
        savename_strain=strcat(ABSPATH_mkAMA,'\FlowOverTime\',filenum,list_extension{indx});
        exportgraphics(gcf,savename_strain,'Resolution',600,'BackgroundColor','none','ContentType','vector');
        hold off

      
% % %%make FRAP curves
        %%make FRAP curves
        figure
        hold on
        ax=gca;
        ax.FontSize=18;
        ax.FontName='Arial';
        p1=plot(time,F,'-b');
        p1.Marker='o';
        p1.MarkerEdgeColor='c';
        p1.MarkerFaceColor='b';
        p1.MarkerSize=4;
        p2=plot(time,first_order_lag(time,FitPara),'-k');
        p2.LineWidth=1;
        xlim([0 Inf])
        ylim([0 1.0])
        ytickformat('%.1f');
        axtoolbar('Visible','off');
        xlabel('Time\fontname{Times New Roman}\it t \fontname{Arial}\rm(s)');
        ylabel('Intensity');
        lgd=legend( {'Experiment','\fontname{Times New Roman}\itF\rm(\itt\rm)=\itF_{\rm0}\rm(1-exp(-\it k\itt\rm))'} );
        lgd.FontSize=16;
        lgd.Location='northwest';
        savename_recovery=strcat(ABSPATH_mkAMA,'\RecoveryCurves\',filenum,list_extension{indx});
        exportgraphics(gcf,savename_recovery,'Resolution',600,'BackgroundColor','none','ContentType','vector');
        hold off
        % % %%%%%
        close all
        j_SMA/length(list_input_SMA)*100
end

messagedialog
function messagedialog
    d = dialog('Position',[300 300 250 250],'Name','Complete!');

    txt = uicontrol('Parent',d,...
               'Style','text',...
               'Position',[20 80 210 140],...
               'String',['Time changes of variables were saved in "StrainOverTime","StrainRateOverTime"' ...
               '"DisplacementOverTime", "FlowOverTime", "RecoveryCurves".']);

    btn = uicontrol('Parent',d,...
               'Position',[85 20 70 25],...
               'String','Close',...
               'Callback','delete(gcf)');

end
