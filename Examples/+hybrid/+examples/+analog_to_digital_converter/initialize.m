% Initialization script for Analog-to-digital converter example.
                                                             
% Initial conditions                                                    
x0ADC = [0;0];             

% Constants
Ts = pi/8;

% Simulation horizon                                                    
T = 10;                                                                 
J = 20;                                                                 
                                                                        
% Set the behavior of the simulation in the intersection of C and D.                                                     
% rule = 1 -> priority for jumps                                        
% rule = 2 -> priority for flows                                        
% rule = 3 -> no priority, random selection when simultaneous conditions
rule = 1;                                                               
                                                                        
% Solver tolerances
RelTol = 1e-6;
MaxStep = 1e-3;