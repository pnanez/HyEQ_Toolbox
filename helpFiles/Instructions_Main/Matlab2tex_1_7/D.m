function v  = D(tau, u)
% jump set
if (u >= 1) || (tau >= 1) % jump condition
    v = 1;  % report jump
else
    v = 0;  % do not report jump
end
