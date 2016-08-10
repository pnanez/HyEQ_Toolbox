function xplus = g(x, u, lambda)
% jump map
xplus = [u(1); -lambda*x(2)];
