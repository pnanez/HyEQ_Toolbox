function tauplus = g(tau, u)
% jump map
if (1+e)*tau < 1
    tauplus = (1+e)*tau;
elseif (1+e)*tau >= 1
    tauplus = 0;
else
    tauplus = tau;
end
