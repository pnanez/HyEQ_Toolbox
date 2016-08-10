function v = D(x, u)
% jump set
if (x(1) <= u(1)) && (x(2) <= 0)  % jump condition
    v = 1;  % report jump
else
    v = 0;   % do not report jump
end
