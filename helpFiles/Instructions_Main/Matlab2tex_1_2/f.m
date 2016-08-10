function xdot = f(x)
% state
x1 = x(1);
x2 = x(2);
% differential equations
xdot = [x2 ; -9.81];
end
