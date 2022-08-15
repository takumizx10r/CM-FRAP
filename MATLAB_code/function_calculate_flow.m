function [u] = function_calculate_tensor_ver2(firstkeep_, secondkeep_, DT_ )




P1=     firstkeep_(1:2);        
P2=     firstkeep_(3:4);        
P3=     firstkeep_(5:6);        
P4=     firstkeep_(7:8);        
Q1=     secondkeep_(1:2);        
Q2=     secondkeep_(3:4);        
Q3=     secondkeep_(5:6);        
Q4=     secondkeep_(7:8);        


u1=Q1-P1;         %%%displacement
u2=Q2-P2;         %%%displacement
u3=Q3-P3;         %%%displacement
u4=Q4-P4;         %%%displacement

u=[u1; u2; u3; u4];


end

