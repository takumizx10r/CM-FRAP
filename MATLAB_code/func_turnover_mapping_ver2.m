function [ f ] = func_turnover_mapping_ver2(inputimage, Data, RAB_Frame, inputTensor_list,pixelsize)
%FUNC_TURNOVER_MAPPING この関数の概要をここに記述
%   詳細説明をここに記述]
colormap jet
CM=colormap;
pos1 = [0.05 0.050 0.7 0.8];
pos2 = [0.78 0.050 0.02 0.8];
ax1=subplot('Position',pos1);
ax2=subplot('Position',pos2);

subplot(ax1);
axtoolbar('Visible','off');
frame=1;
imagedata = imread(inputimage,'Index',frame+RAB_Frame-1);  
imagesc(imagedata);
load spine
colormap(ax1,map);
hold on
axis off
ax1.FontName='Arial';
ax1.FontSize=16;
sz=size(Data);

MAX=max(Data(:,2));
MIN=min(Data(:,2));
Cdata=zeros(sz(1),3);
for pp=1:sz(1)
%     color
    Index=round( (Data(pp,2)-MIN)/(MAX-MIN)*255 + 1 );
    R=CM(Index,1);
    G=CM(Index,2);
    B=CM(Index,3);
    Cdata(pp,1:3)=[R G B];
    
%     pgx(1:4,1)=Vector(pp,2:5).';
%     pgy(1:4,1)=Vector(pp,6:9).';
%     p=patch(pgx,pgy,[R G B]);
%     p.FaceAlpha=0.8;
%     p.EdgeColor=[R G B];
%     p.LineWidth=0.5;
%     p.EdgeAlpha=0.8;
end
Xdata=mean(Data(:,3:6),2);
Ydata=mean(Data(:,7:10),2);

scatter(Xdata,Ydata, 25, Cdata, 'filled' )


plot ([80;80],[80;80+10/pixelsize],'-w',[80;80+10/pixelsize],[80;80],'-w','LineWidth',2);
text(80.0/2,130.0,strcat('\fontsize{16} \fontname{Arial}10 ',char(181),'m'), 'HorizontalAlignment','center','Rotation',90, 'Color','white', 'FontWeight','normal');
text(130.0,80.0/2,strcat('\fontsize{16} \fontname{Arial}10 ',char(181),'m'), 'HorizontalAlignment','center', 'Color', 'white', 'FontWeight','normal');
% time_str=strcat(sprintf('%d (s)',time));
% text(900.0 , 80.0/2,time_str,'FontName','Arial','FontSize',14, 'HorizontalAlignment','center', 'Color','white', 'FontWeight','normal');
        
axtoolbar('Visible','off');          
   
hold off

subplot(ax2);
CM2=colormap(ax2, jet);
x = [0:1];
y = [MIN:(MAX-MIN)/(256-1):MAX];
[X,Y] = meshgrid(x,flip(y));
imagesc(Y);
ax2.FontName='Arial';
ax2.FontSize=16;
ax2.YAxisLocation = 'right';
ax2.XAxis.Visible='off';
ax2.YTick=[1 256];
% ax2.YTickLabel={sprintf('%.2f',MAX*10^3), sprintf('%.2f',(MIN+(MAX-MIN)/2)*10^3),sprintf('%.2f',MIN*10^3)}
ax2.YTickLabel={sprintf('%.2f',MAX*10^3),sprintf('%.2f',MIN*10^3)}
ylabel('Turnover rate \fontname{Times New Roman}\itk \rm(\times10^{-3}/s)');
axtoolbar('Visible','off');
f=gcf;

end

