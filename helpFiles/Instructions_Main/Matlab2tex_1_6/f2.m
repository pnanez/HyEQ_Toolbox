function xdot = f(x, u)
% state
eta1 = x(1);
eta2 = x(2);
%input
y1 = u(1);
v21 = u(2);
v22 = u(3);
% flow map
eta1dot = eta2;
eta2dot = -eta1-2*eta2+v21;
xdot = [eta1dot;eta2dot];
