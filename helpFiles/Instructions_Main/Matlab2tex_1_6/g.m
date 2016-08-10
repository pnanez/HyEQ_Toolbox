function xplus = g(x, u)
% state
xi1 = x(1);
xi2 = x(2);
%input
y2 = u(1);
v11 = u(2);
v12 = u(3);
%jump map
xi1plus=y2+0.1*xi2^2;
xi2plus=0.8*abs(xi2)+v12;
xplus = [xi1plus;xi2plus];
