function [f] = func_make_arrow_forDupimage_NormField_ver2(dupimage, iter, RAB_Frame, inputTensor_list,  UVectors,scale,pixelsize, time,KeepCoordinates_t)
%FUNC_MAKE_ARROW この関数の概要をここに記述
%   詳細説明をここに記述
%%make arrow
colormap jet
CM=colormap;
pos1 = [0.05 0.050 0.7 0.8];
pos2 = [0.80 0.050 0.03 0.8];
ax1=subplot('Position',pos1);
ax2=subplot('Position',pos2);

subplot(ax1);
axtoolbar('Visible','off');
imagedata = imread(dupimage,'Index',iter+RAB_Frame-1);
imagesc(imagedata);
szimage=size(imagedata);
load spine
colormap(ax1,map);
hold on
axis off
ax1.FontName='Arial';
ax1.FontSize=18;
sz=size(UVectors);
Norm(1:sz(1),1)=sqrt(UVectors(1:sz(1),3).*UVectors(1:sz(1),3) + UVectors(1:sz(1),4).*UVectors(1:sz(1),4));
MAX=max(Norm);
MIN=min(Norm);



for pp=1:sz(1)
    Index=round( (Norm(pp,1)-MIN)/(MAX-MIN)*255 +1 );
    r=CM(Index,1);
    g=CM(Index,2);
    b=CM(Index,3);
    
    
    
    q=quiver(UVectors(pp,1),UVectors(pp,2), UVectors(pp,3)/pixelsize,UVectors(pp,4)/pixelsize);
%     q=quiver(UVectors(pp,1),UVectors(pp,2), UVectors(pp,3),UVectors(pp,4));
    q.Color=[r g b];
    q.AutoScaleFactor=scale;
    q.LineWidth=2;
    q.MaxHeadSize=2;
    
end
plot ([szimage(2)*0.1;szimage(2)*0.1],[szimage(1)*0.15;szimage(1)*0.15+1/pixelsize],'-w',...
    [szimage(2)*0.1;szimage(2)*0.1+1/pixelsize],[szimage(1)*0.15;szimage(1)*0.15],'-w','LineWidth',2);
p=patch(KeepCoordinates_t(:,1,iter),KeepCoordinates_t(:,2,iter),'y');
% Index=round( (iter)/(length(imfinfo(dupimage)))*255 +1 );
% r=CM(Index,1);
% g=CM(Index,2);
% b=CM(Index,3);
p.FaceColor='none';
p.EdgeColor='y';
p.LineWidth=2;


text(szimage(2)*0.1/2,szimage(1)*0.3,strcat('\fontsize{16} \fontname{Arial}1 ',char(181),'m'), 'HorizontalAlignment','center','Rotation',90, 'Color','white', 'FontWeight','normal');
text(szimage(2)*0.12,szimage(1)*0.18/2,strcat('\fontsize{16} \fontname{Arial}1 ',char(181),'m'), 'HorizontalAlignment','center', 'Color', 'w', 'FontWeight','normal');
time_str=strcat(sprintf('%d (s)',time(iter)));
text(szimage(2)*0.85 , szimage(1)*0.18/2,time_str,'FontName','Arial','FontSize',20, 'HorizontalAlignment','center', 'Color','white', 'FontWeight','normal');
hold off

subplot(ax2);
CM2=colormap(ax2, jet);
x = [0:1];
y = [MIN:(MAX-MIN)/(256-1):MAX];
[X,Y] = meshgrid(x,flip(y));
imagesc(Y);
ax2.FontName='Arial';
ax2.FontSize=18;
ax2.YAxisLocation = 'right';
ax2.XAxis.Visible='off';
ax2.YTick=[1 256/2 256];
ax2.YTickLabel={sprintf('%.2f',MAX) sprintf('%.2f',(MAX+MIN)/2) sprintf('%.2f',MIN)};
ylabel(strcat('Norm of displacement \fontname{Times New Roman}|\it\bfu\rm| \fontname{Arial}\rm(',char(181),'m)'));
axtoolbar('Visible','off');
f=gcf;

%%%
end

