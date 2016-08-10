function xplus = g(x, u)
% state
eta1 = x(1);
eta2 = x(2);
%input
y1 = u(1);
v21 = u(2);
v22 = u(3);
% jump map
eta1plus = y1-0.1*abs(eta2);
eta2plus = -0.8*abs(eta2)+v22;
xplus = [eta1plus;eta2plus];
