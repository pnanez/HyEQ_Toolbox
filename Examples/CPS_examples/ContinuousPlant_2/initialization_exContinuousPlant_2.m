% Initialization for Continuous Plant Example
                                                                
% Initial conditions                                                    
x0 = [0; 0; 0];   

% Parameters
minU = -1;
maxU = 1;
maxX = 5;

% Simulation horizon                                                    
T = 10;                                                                 
J = 20;                                                                 
                                                                        
% Set the behavior of the simulation in the intersection of C and D.                                                     
% rule = 1 -> priority for jumps                                        
% rule = 2 -> priority for flows                                        
% rule = 3 -> no priority, random selection
rule = 1;                                                               
                                                                        
% Solver tolerances
RelTol = 1e-6;
MaxStep = 1e-3;