function [N,Q,D,V,S] = func_NematicOrder_forAllVectors( V_vector)
%UNTITLED2 この関数の概要をここに記述
%   詳細説明をここに記述


N=V_vector;
keep=find(N(:,1)~=0 & N(:,2)~=0);
G=length(keep);
if G~=0
    for i=1:length(N(:,1))
        N(i,1:2)=N(i,1:2)./norm(N(i,1:2));
    end
    Nt=N.';
    
    sum=zeros(2,2);
    % sum2=0.0;
    for i=1:G
        
        sum=sum+N(keep(i),:).*Nt(:,keep(i))-eye(2,2)./3;
        %     sum2=3*cos(atan2(N(i,2),N(i,1)))*cos(atan2(N(i,2),N(i,1)))-1.0
    end
    Q=3/2*sum/G;
    [V, D]=eig(Q);
    S=max(max(D(:,:)));
end
if G==0
    
    Q=[];
    V=[];
    D=[];
    S=max(max(D(:,:)));
end
end
