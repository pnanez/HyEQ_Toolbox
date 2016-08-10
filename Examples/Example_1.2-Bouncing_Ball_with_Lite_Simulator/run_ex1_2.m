%--------------------------------------------------------------------------
% Matlab M-file Project: HyEQ Toolbox @  Hybrid Systems Laboratory (HSL), 
% https://hybrid.soe.ucsc.edu/software
% http://hybridsimulator.wordpress.com/
% Filename: run_ex1_2.m
%--------------------------------------------------------------------------
% Project: Simulation of a hybrid system (bouncing ball)
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%   See also HYEQSOLVER, PLOTARC, PLOTARC3, PLOTFLOWS, PLOTHARC,
%   PLOTHARCCOLOR, PLOTHARCCOLOR3D, PLOTHYBRIDARC, PLOTJUMPS.
%   Copyright @ Hybrid Systems Laboratory (HSL),
%   Revision: 0.0.0.3 Date: 05/20/2015 3:42:00

% initial conditions
x1_0 = 1;
x2_0 = 0;
x0 = [x1_0,x2_0];

% simulation horizon
TSPAN=[0 10];
JSPAN = [0 20];

% rule for jumps
% rule = 1 -> priority for jumps
% rule = 2 -> priority for flows
rule = 1;

options = odeset('RelTol',1e-6,'MaxStep',.1);

% simulate
[t,j,x] = HyEQsolver( @f_ex1_2,@g_ex1_2,@C_ex1_2,@D_ex1_2,...
    x0,TSPAN,JSPAN,rule,options,'ode23t');

% plot solution
figure(1) % position
clf
subplot(2,1,1), plotHarc(t,j,x(:,1));
grid on
ylabel('x_1 position')
subplot(2,1,2), plotHarc(t,j,x(:,2));
grid on
ylabel('x_2 velocity')

% plot phase plane
figure(2) % position
clf
plotHarcColor(x(:,1),j,x(:,2),t);
xlabel('x_1')
ylabel('x_2')
grid on

% plot hybrid arc
figure(3)
plotHybridArc(t,j,x)
xlabel('j')
ylabel('t')
zlabel('x1')

