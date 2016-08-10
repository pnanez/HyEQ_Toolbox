function v = D(x, u)
% state
eta1 = x(1);
eta2 = x(2);
%input
y1 = u(1);
v21 = u(2);
v22 = u(3);
% jump set
if (eta1 >= y1) % jump condition
    v = 1;  % report jump
else
    v = 0;   % do not report jump
end
