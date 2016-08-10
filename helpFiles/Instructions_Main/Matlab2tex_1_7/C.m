function v  = C(tau, u)
% flow set
if ((tau > 0) && (tau < 1)) || ((u > 0) && (u <= 1))  % flow condition
    v = 1;  % report flow
else
    v = 0;  % do not report flow
end
