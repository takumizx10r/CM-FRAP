function [MAX ,MIN,f] = func_make_rectangle_strainTransformed_field_ver2(inputimage, iter, RAB_Frame,  Vector,pixelsize, time)
%FUNC_MAKE_RECTANGLE_STRAIN_FIELD この関数の概要をここに記述
%   詳細説明をここに記述
% 
% 
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
im_info=imfinfo(inputimage);
im_size=im_info(iter+RAB_Frame-1).Height;
load spine
colormap(ax1,map);
hold on
axis off
ax1.FontName='Arial';
ax1.FontSize=16;
sz=size(Vector);
MAXABS=max(abs(Vector(:,1)));
% MAX=max(Vector(:,1));
% MIN= min(Vector(:,1));
MAX=MAXABS;
MIN= -MAXABS;

for pp=1:sz(1)
%     color
    Index=round( (Vector(pp,1)-MIN)/(MAX-MIN)*255 + 1 );
    R=CM(Index,1);
    G=CM(Index,2);
    B=CM(Index,3);
    
    pgx(1:4,1)=Vector(pp,2:5).';
    pgy(1:4,1)=Vector(pp,6:9).';
    p=patch(pgx,pgy,[R G B]);
    p.FaceAlpha=0.8;
    p.EdgeColor=[R G B];
    p.LineWidth=0.5;
    p.EdgeAlpha=0.8;
end

plot ([80/1024*im_size;80/1024*im_size],[80/1024*im_size;80/1024*im_size+10/pixelsize], ...
    '-w',[80/1024*im_size;80/1024*im_size+10/pixelsize],[80/1024*im_size;80/1024*im_size],'-w','LineWidth',2);
text(80/1024*im_size/2,130.0/1024*im_size,strcat('\fontsize{16} \fontname{Arial}10 ',char(181),'m'), 'HorizontalAlignment','center','Rotation',90, 'Color','white', 'FontWeight','normal');
text(130.0/1024*im_size,80.0/2/1024*im_size,strcat('\fontsize{16} \fontname{Arial}10 ',char(181),'m'), 'HorizontalAlignment','center', 'Color', 'white', 'FontWeight','normal');
time_str=strcat(sprintf('%d (s)',time));
text(900.0/1024*im_size , 80.0/1024*im_size/2,time_str,'FontName','Arial','FontSize',20, 'HorizontalAlignment','center', 'Color','white', 'FontWeight','normal');
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
ylabel(strcat('Strain \fontname{Times New Roman}\it',char(949),'_{\rm\mid\mid}'));
axtoolbar('Visible','off');
f=gcf;

end

