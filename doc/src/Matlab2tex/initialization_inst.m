% initial conditions
x1_0 = 1;
x2_0 = 0;
x0 = [x1_0;x2_0];
% simulation horizon
TSPAN=[0,10];
JSPAN = [0,20];
% rule for jumps
% rule = 1 -> priority for jumps
% rule = 2 -> priority for flows
rule = 1;
options = odeset('RelTol',1e-6,'MaxStep',.1);
% simulate
[t,j,x] = HyEQsolver(@f,@g,@C,@D,x0,TSPAN,JSPAN,rule,options);