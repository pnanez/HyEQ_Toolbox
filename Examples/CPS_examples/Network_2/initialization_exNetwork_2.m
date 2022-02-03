%--------------------------------------------------------------------------
% Matlab M-file Project: HyEQ Toolbox @  Hybrid Systems Laboratory (HSL), 
% https://hybrid.soe.ucsc.edu/software
% http://hybridsimulator.wordpress.com/
% Filename: initialization_exADC.m
%--------------------------------------------------------------------------
% Project: Simulation of a hybrid system (Digital Network)
% Description: initialization ADC
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%   See also plotflows, plotHarc, plotHarcColor, plotHarcColor3D,
%   plotHybridArc, plotjumps.
%   Copyright @ Hybrid Systems Laboratory (HSL),
%   Revision: 0.0.0.3 Date: 05/20/2015 3:42:00

clear all                                                               
clc   

% simulation horizon                                                    
T = 20;                                                                 
J = 20;  
% Constants (NET)
Tnmax = 3;
Tnmin = 0.2;
% random communication events
tk = rand(1,J)*(Tnmax-Tnmin)+Tnmin;
                                                                  
% initial conditions (Linear system)
z0 = [1;0.1;1;0.6]; 
n = length(z0);

% initial conditions (NET)
tau0 = tk(1);
j0 = 0;
y0 = [0;j0;tau0];             


zhat0 = [0;0;0;0;0];


% System
A = [0  0  1  0;
     0  0  0  1;
    -2  1 -1  0;
     2 -2  0 -2];
B = [0 0 1 0]';
M = [1 0 0 0];
% Estimator
L = [1; -0.9433; -0.6773;1.6274];
% P = [0.1180 0.2460 0.1889 0.1491;
%      0.2460 1.1788 1.0392 0.9646;
%      0.1889 1.0392 0.9407 0.8778;
%      0.1491 0.9646 0.8778 0.8328];

parameters = [A,B,M',L];


                                                                        
% rule for jumps                                                        
% rule = 1 -> priority for jumps                                        
% rule = 2 -> priority for flows                                        
% rule = 3 -> no priority, random selection when simultaneous conditions
rule = 1;                                                               
                                                                        
%solver tolerances
RelTol = 1e-6;
MaxStep = 1e-3;