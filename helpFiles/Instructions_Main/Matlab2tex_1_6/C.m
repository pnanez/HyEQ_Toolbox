function v = C(x, u)
% state
xi1 = x(1);
xi2 = x(2);
%input
y2 = u(1);
v11 = u(2);
v12 = u(3);
if (xi1 >= y2)  % flow condition
    v = 1;  % report flow
else
    v = 0;   % do not report flow
end
