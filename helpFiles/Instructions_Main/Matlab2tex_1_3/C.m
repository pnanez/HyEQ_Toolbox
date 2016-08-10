function v = C(x, u)
% flow set
if (x(1) >= u(1))  % flow condition
    v = 1;  % report flow
else
    v = 0;   % do not report flow
end