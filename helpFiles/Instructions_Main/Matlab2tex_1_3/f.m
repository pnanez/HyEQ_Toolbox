function xdot = f(x, u, gamma)
% state
x1 = x(1);
x2 = x(2);
% flow map: xdot=f(x,u);
xdot = [x(2); gamma];