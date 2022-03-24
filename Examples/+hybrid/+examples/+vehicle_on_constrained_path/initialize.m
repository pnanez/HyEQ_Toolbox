% Initialization script for Example 1.5: A Vehicle on a Track with Boundaries.
                                                                                                                                 
% Initial conditions                                                    
x0 = [0; 0; pi/4; 2];                                                                                               
                                                                        
% Simulation horizon                                                    
T = 15;                                                                 
J = 20;                                                                 
                                                                       
% Set the behavior of the simulation in the intersection of C and D.                                                      
% rule = 1 -> priority for jumps                                        
% rule = 2 -> priority for flows                                        
% rule = 3 -> no priority, random selection when simultaneous conditions
rule = 1;                                                               

% Solver tolerances
RelTol = 1e-8;
MaxStep = 1e-2;