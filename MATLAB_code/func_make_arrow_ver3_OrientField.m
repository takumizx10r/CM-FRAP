function [f] = func_make_arrow_ver3_OrientField(inputimage, frame, RAB_Frame, inputTensor_list,  U_vector,scalefactor,pixelsize, time)
%FUNC_MAKE_ARROW この関数の概要をここに記述
%   詳細説明をここに記述
%%make arrow
% close all
colormap hsv
CM=colormap;
pos1 = [0.05 0.050 0.7 0.8];
pos2 = [0.78 0.050 0.02 0.8];
ax1=subplot('Position',pos1);
ax2=subplot('Position',pos2);

subplot(ax1);
axtoolbar('Visible','off');

imagedata = imread(inputimage,'Index',frame+RAB_Frame-1);  
imagesc(imagedata);
im_info=imfinfo(inputimage);
im_size=im_info(frame+RAB_Frame-1).Height;
load spine
colormap(ax1,map);
hold on
axis off
ax1.FontName='Arial';
ax1.FontSize=16;
sz=size(U_vector);

Arg(1:sz(1),1)=atan2(U_vector(1:sz(1),4),U_vector(1:sz(1),3));
MAX=pi;
MIN=-pi;


for pp=1:sz(1)
%     color
    Index=round( (Arg(pp)-MIN)/(MAX-MIN)*255 + 1 );
    R=CM(Index,1);
    G=CM(Index,2);
    B=CM(Index,3);
    
    q=quiver(U_vector(pp,1),U_vector(pp,2), U_vector(pp,3)/pixelsize,U_vector(pp,4)/pixelsize);
    q.Color=[R G B];
    q.AutoScaleFactor=scalefactor;
    q.LineWidth=0.7;
    q.MaxHeadSize=2;

end

plot ([80/1024*im_size;80/1024*im_size],[80/1024*im_size;80/1024*im_size+10/pixelsize], ...
    '-w',[80/1024*im_size;80/1024*im_size+10/pixelsize],[80/1024*im_size;80/1024*im_size],'-w','LineWidth',2);
text(80.0/2/1024*im_size,130.0/1024*im_size,strcat('\fontsize{16} \fontname{Arial}10 ',char(181),'m'), 'HorizontalAlignment','center','Rotation',90, 'Color','white', 'FontWeight','normal');
text(130.0/1024*im_size,80.0/2/1024*im_size,strcat('\fontsize{16} \fontname{Arial}10 ',char(181),'m'), 'HorizontalAlignment','center', 'Color', 'white', 'FontWeight','normal');
time_str=strcat(sprintf('%d (s)',time));
text(900.0 /1024*im_size, 80.0/2/1024*im_size,time_str,'FontName','Arial','FontSize',20, 'HorizontalAlignment','center', 'Color','white', 'FontWeight','normal');
        
axtoolbar('Visible','off');          
   
hold off

subplot(ax2);
CM2=colormap(ax2, hsv);
x = [0:1];
y = [MIN:(MAX-MIN)/(256-1):MAX];
[X,Y] = meshgrid(x,(y));
imagesc(Y);
ax2.FontName='Arial';
ax2.FontSize=16;
ax2.YAxisLocation = 'right';
ax2.XAxis.Visible='off';
ax2.YTick=[1 256*1/4 256/2 256*3/4 256];
ax2.YTickLabel={'\pi','\pi/2','0','-\pi/2','-\pi'}
ylabel('Angle \fontname{Times New Roman}\it\theta ');
axtoolbar('Visible','off');
f=gcf;

%%%
end

