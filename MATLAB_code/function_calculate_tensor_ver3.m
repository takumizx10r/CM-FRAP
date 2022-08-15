function [u,E,e,Strain,StrainRate, SpinRate] = function_calculate_tensor_ver3(firstkeep_, secondkeep_, DT_ )
%UNTITLED2 この関数の概要をここに記述
%   詳細説明をここに記述

% % Test
% % P=  [10,10];        %LeftBot in image j coordinate
% % PP= [20,20];        %RightTop in image j coordinate
% % Q=  [30,30];
% % QQ= [45,45];
% % % % % % % % 
L1=firstkeep_(5:6)-firstkeep_(1:2);
L2=firstkeep_(7:8)-firstkeep_(3:4);

if abs(L1(1)*L1(2))>=abs(L2(1)*L2(2))
    P=  firstkeep_(1:2);        %LeftBot in image j coordinate
    PP= firstkeep_(5:6);        %RightTop in image j coordinate
    Q=  secondkeep_(1:2);
    QQ= secondkeep_(5:6);
elseif abs(L1(1)*L1(2))<abs(L2(1)*L2(2))
    P=  firstkeep_(3:4);        %LeftBot in image j coordinate
    PP= firstkeep_(7:8);        %RightTop in image j coordinate
    Q=  secondkeep_(3:4);
    QQ= secondkeep_(7:8);
end

turn=[1,1];
P=P.*turn;
PP=PP.*turn;
Q=Q.*turn;
QQ=QQ.*turn;
% keep=P;
% P=P-keep;
% PP=PP-keep;
% Q=Q-keep;
% QQ=QQ-keep;

X=P;
XdX=PP;
x=Q;
xdx=QQ;
u=Q-P;         %%%displacement
udu=QQ-PP;

du=udu-u ;   %%deformation
dx=xdx-x;   %%
dX=XdX-X;
% du=du*pixelsize
% dx=dx*pixelsize
% dX=dX*pixelsize

Flow=du./DT_;

E=zeros(2,2);
e=zeros(2,2);
Strain=zeros(2,2);
StrainRate=zeros(2,2);
SpinRate=zeros(2,2);
for i=1:2
    for j=1:2
        secondorder_E=0.0;
        secondorder_e=0.0;
        for m=1:2
            secondorder_E=secondorder_E+du(m)/dX(i)*du(m)/dX(j);
            secondorder_e=secondorder_e+du(m)/dx(i)*du(m)/dx(j);
        end
        E(i,j)=1.0/2.0*(    du(i)/dX(j) + du(j)/dX(i) +secondorder_E   );
        e(i,j)=1.0/2.0*(    du(i)/dx(j) + du(j)/dx(i) -secondorder_e   );
        Strain(i,j)=1.0/2.0*(    du(i)/dX(j) + du(j)/dX(i)    );
        StrainRate(i,j)=1.0/2.0*(    du(i)/dX(j)/DT_ + du(j)/dX(i)/DT_    );
        SpinRate(i,j)=1.0/2.0*(    du(i)/dX(j)/DT_ - du(j)/dX(i)/DT_    );
    end
end
end

