function [] = func_make_histgram(P,savename,time)
%UNTITLED4 この関数の概要をここに記述
%   詳細説明をここに記述
figure
edges=[0:0.1:1.0];
h=histogram(P,edges);
h.FaceColor='k';
xlim([0.0 1.0]);
ax=gca;
ax.FontSize=18;
ax.FontName='Arial';
axtoolbar('Visible','off');
xlabel('\rm\fontname{Arial}Orientation index \fontname{Times New Roman}\itR');
ylabel('Frequency');
xtickformat('%.1f');
tit=title(strcat('\fontsize{16} \fontname{Times New Roman}\itt=\fontname{Arial}\rm',sprintf('%d',time) , ' (s)'));
tit.FontSize=14;
exportgraphics(gcf,savename,'Resolution',600,'BackgroundColor','white','ContentType','vector');
close
end

