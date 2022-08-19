function [NormPara_] = func_fit_FRAPCurve(x_data,y_data)
%FUNC_FIT この関数の概要をここに記述
%   詳細説明をここに記述
x0= [0.3 0.0001];
lb=[0   , 10^(-5)];
ub=[1.0 , 10^(-2)];
A=[];
b=[];
Aeq=[];
beq=[];
nonlcon =[];
options = optimset('fmincon');
options.Algorithm=('interior-point');
options.TolX=10^-13;
options.MaxIter=10000;
NormPara_=fmincon(@LeastSquare,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);
    function Q=LeastSquare(x)
        

        sum=0.0;
        for k=1:length(x_data)          %time
          
                    sum=sum+( y_data(k,1)-first_order_lag(x_data(k,1),x))^2;
%                      sum=sum+( RE(j,i,k)-400)^2;
               
        end
        Q=sum;
    end
end

