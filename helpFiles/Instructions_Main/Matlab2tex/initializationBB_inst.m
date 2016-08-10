% initialization for bouncing ball example
clear all
% initial conditions
x0 = [1;0];
% simulation horizon
T = 10;
J = 20;
% rule for jumps
% rule = 1 -> priority for jumps
% rule = 2 -> priority for flows
% rule = 3 -> no priority, random selection when simultaneous conditions
rule = 1;
%configuration of solver
RelTol = 1e-8;
