% Initialization script for the simulation of a bouncing ball and moving platform 
                                                         
% Initial conditions                                                    
x1_0 = [1; 0];                                                          
x2_0 = [0; 0];                                                                                                           
                                                                        
% Simulation horizon                                                    
T = 25;                                                                 
J = 40;                                                                 

% Set the behavior of the simulation in the intersection of C and D.                                                      
% rule = 1 -> priority for jumps                                        
% rule = 2 -> priority for flows                                        
% rule = 3 -> no priority, random selection
rule = 1;                     
    
% Solver tolerances
RelTol = 1e-8;
MaxStep = 0.01;                                                  