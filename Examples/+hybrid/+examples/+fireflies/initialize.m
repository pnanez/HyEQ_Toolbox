% Initialization script for Example 1.7: Synchronization of Fireflies.
                                                         
% Initial conditions                                                    
x1_0 = 0.5;                                                            
x2_0 = 0;                                                             

% Biological coefficient for jump in periodic cycle
e = 0.3;

% simulation horizon                                                    
T = 8;                                                                 
J = 15;                                                                 
           
% Set the behavior of the simulation in the intersection of C and D.                                                  
% rule = 1 -> priority for jumps                                        
% rule = 2 -> priority for flows                                        
% rule = 3 -> no priority, random selection when simultaneous conditions
rule = 1;                                                               
                                                                        
% Solver tolerances
RelTol = 1e-8;
MaxStep = 1e-2;