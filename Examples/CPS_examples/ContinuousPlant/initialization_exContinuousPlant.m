%--------------------------------------------------------------------------
% Matlab M-file Project: HyEQ Toolbox @  Hybrid Systems Laboratory (HSL), 
% https://hybrid.soe.ucsc.edu/software
% http://hybridsimulator.wordpress.com/
% Filename: initialization_exContinuousPlant.m
%--------------------------------------------------------------------------
% Project: Simulation of a hybrid system (Continuous plant)
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%   See also PLOTARC, PLOTARC3, PLOTFLOWS, PLOTHARC, PLOTHARCCOLOR,
%   PLOTHARCCOLOR3D, PLOTHYBRIDARC, PLOTJUMPS.
%   Copyright @ Hybrid Systems Laboratory (HSL),
%   Revision: 0.0.0.3 Date: 05/20/2015 3:42:00


clear all                                                               
clc                                                                       
% parameters
b = 2;
m = 4;
Ts = 1/10;
Th = 1/10;
k1 = -10;
k2 = -10;

A = [0 1;
     0 -b/m];
B = [1;
     1/m];
C = [1 0;
     0 1];
K = [k1 k2];

ctes = [A,B,C,K'];

% initial conditions                                                    
x0  = [1;1];
zs0 = [C*x0;0];
u0 = 0;
zh0 = [u0;0];
ZHO = 1; % use the ZOH? 1 = yes, -1 = no;

% simulation horizon                                                    
T = 10;                                                                 
J = 200;                                                                 
                                                                        
% rule for jumps                                                        
% rule = 1 -> priority for jumps                                        
% rule = 2 -> priority for flows                                        
% rule = 3 -> no priority, random selection when simultaneous conditions
rule = 1;                                                               
                                                                        
%solver tolerances
RelTol = 1e-6;
MaxStep = 1e-3;