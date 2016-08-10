%--------------------------------------------------------------------------
% Matlab M-file Project: HyEQ Toolbox @  Hybrid Systems Laboratory (HSL), 
% https://hybrid.soe.ucsc.edu/software
% http://hybridsimulator.wordpress.com/
% Filename: initialization_exADC.m
%--------------------------------------------------------------------------
% Project: Simulation of a hybrid system (Analog-to-digital converter)
% Description: initialization ADC
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%   See also PLOTARC, PLOTARC3, PLOTFLOWS, PLOTHARC, PLOTHARCCOLOR,
%   PLOTHARCCOLOR3D, PLOTHYBRIDARC, PLOTJUMPS.
%   Copyright @ Hybrid Systems Laboratory (HSL),
%   Revision: 0.0.0.3 Date: 05/20/2015 3:42:00


% clear all                                                               
clc                                                                       
% initial conditions (bouncing ball)
x0bb = [1;0];   
% initial conditions (ACD)
tau0 = 0;
x0ADC = [x0bb;tau0];             

% Constants (ACD)

Ts = 0.1;

% physical variables (bouncing ball)
global gamma lambda
gamma = -9.81;  % gravity constant
lambda = 0.8;   % restitution coefficent

% simulation horizon                                                    
T = 10;                                                                 
J = 100;                                                                 
                                                                        
% rule for jumps                                                        
% rule = 1 -> priority for jumps                                        
% rule = 2 -> priority for flows                                        
% rule = 3 -> no priority, random selection when simultaneous conditions
rule = 1;                                                               
                                                                        
%solver tolerances
RelTol = 1e-6;
MaxStep = 1e-3;