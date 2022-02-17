%--------------------------------------------------------------------------
% Matlab M-file Project: HyEQ Toolbox @  Hybrid Systems Laboratory (HSL), 
% https://hybrid.soe.ucsc.edu/software
% http://hybridsimulator.wordpress.com/
% Filename: initialization_ex1_8e.m
%--------------------------------------------------------------------------
% Project: Simple Example
% Description: initialization for Simple Example (boundary of C)
                                                                                                                 
% initial conditions                                                    
x0 = 1;                                                             

% simulation horizon                                                    
T = 10;                                                                 
J = 20;                                                                 
                                                                        
% rule for jumps                                                        
% rule = 1 -> priority for jumps                                        
% rule = 2 -> priority for flows                                        
% rule = 3 -> no priority, random selection when simultaneous conditions
rule = 2;                                                               
                                                                        
%solver tolerances
RelTol = 1e-8;
MaxStep = 0.001;