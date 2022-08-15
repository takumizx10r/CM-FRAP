function [ f] = func_make_arrow_ver3_NormField(inputimage, iter, RAB_Frame, inputTensor_list,  B,scale_displacement,pixelsize, time)
%FUNC_MAKE_ARROW この関数の概要をここに記述
%   詳細説明をここに記述
%%make arrow
% close all
colormap jet
CM=colormap;
pos1 = [0.05 0.050 0.7 0.8];
pos2 = [0.78 0.050 0.02 0.8];
ax1=subplot('Position',pos1);
ax2=subplot('Position',pos2);

subplot(ax1);
axtoolbar('Visible','off');
imagedata = imread(inputimage,'Index',iter+RAB_Frame-1);  
imagesc(imagedata);

load spine
colormap(ax1,map);
hold on
axis off
ax1.FontName='Arial';
ax1.FontSize=16;
sz=size(B);

Norm(1:sz(1),1)=sqrt(B(1:sz(1),3).*B(1:sz(1),3) + B(1:sz(1),4).*B(1:sz(1),4));
MAX=max(Norm);
MIN=min(Norm);


for pp=1:sz(1)
    Index=round( (Norm(pp,1)-MIN)/(MAX-MIN)*255 +1 );
    r=CM(Index,1);
    g=CM(Index,2);
    b=CM(Index,3);

    q=quiver(B(pp,1),B(pp,2), B(pp,3)./pixelsize,B(pp,4)./pixelsize);
%     q=quiver(B(pp,1),B(pp,2), B(pp,3),B(pp,4));
    q.Color=[r g b];
    q.AutoScaleFactor=scale_displacement;
    q.LineWidth=0.7;
    q.MaxHeadSize=2;

end

plot ([80;80],[80;80+10/pixelsize],'-w',[80;80+10/pixelsize],[80;80],'-w','LineWidth',2);
text(80.0/2,130.0,strcat('\fontsize{16} \fontname{Arial}10 ',char(181),'m'), 'HorizontalAlignment','center','Rotation',90, 'Color','white', 'FontWeight','normal');
text(130.0,80.0/2,strcat('\fontsize{16} \fontname{Arial}10 ',char(181),'m'), 'HorizontalAlignment','center', 'Color', 'white', 'FontWeight','normal');
time_str=strcat(sprintf('%d (s)',time));
text(900.0 , 80.0/2,time_str,'FontName','Arial','FontSize',20, 'HorizontalAlignment','center', 'Color','white', 'FontWeight','normal');
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
ax2.YTick=[1 256/2 256];
ax2.YTickLabel={sprintf('%.2f',MAX) sprintf('%.2f',(MAX+MIN)/2) sprintf('%.2f',MIN)};
ylabel(strcat('Norm of displacement vector \fontname{Times New Roman}|\it\bfu\rm| \fontname{Arial}\rm(',char(181),'m)'));
axtoolbar('Visible','off');
f=gcf;

%%%
end

