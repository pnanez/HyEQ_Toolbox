%--------------------------------------------------------------------------
% Matlab M-file Project: HyEQ Toolbox @  Hybrid Systems Laboratory (HSL), 
% https://hybrid.soe.ucsc.edu/software
% http://hybridsimulator.wordpress.com/
% Filename: initialization_ex1_7.m
%--------------------------------------------------------------------------
% Project: Simulation of synchronization of fireflies
% Description: initialization for synchronization of fireflies example
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%   See also HYEQSOLVER, PLOTARC, PLOTARC3, PLOTFLOWS, PLOTHARC,
%   PLOTHARCCOLOR, PLOTHARCCOLOR3D, PLOTHYBRIDARC, PLOTJUMPS.
%   Copyright @ Hybrid Systems Laboratory (HSL),
%   Revision: 0.0.0.3 Date: 05/20/2015 3:42:00

% clear all                                                               
                                                                        
% initial conditions                                                    
x1_0 = [0.5];                                                            
x2_0 = [0];                                                             

%biological coefficient for jump in periodic cycle
e = 0.3;

% simulation horizon                                                    
T = 15;                                                                 
J = 15;                                                                 
                                                                        
% rule for jumps                                                        
% rule = 1 -> priority for jumps                                        
% rule = 2 -> priority for flows                                        
% rule = 3 -> no priority, random selection when simultaneous conditions
rule = 1;                                                               
                                                                        
%solver tolerances
RelTol = 1e-8;
MaxStep = .005;