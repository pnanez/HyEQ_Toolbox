function v = C(x, u)
% state
eta1 = x(1);
eta2 = x(2);
%input
y1 = u(1);
v21 = u(2);
v22 = u(3);
% flow set
if (eta1 <= y1)  % flow condition
    v = 1;  % report flow
else
    v = 0;   % do not report flow
end
