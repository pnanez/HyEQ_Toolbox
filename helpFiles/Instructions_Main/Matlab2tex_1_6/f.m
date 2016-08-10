function xdot = f(x, u)
% state
xi1 = x(1);
xi2 = x(2);
%input
y2 = u(1);
v11 = u(2);
v12 = u(3);
% flow map
%xdot=f(x,u);
xi1dot = xi2;
xi2dot = -0.8-0.1*xi2+v11;
xdot = [xi1dot;xi2dot];
