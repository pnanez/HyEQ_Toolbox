% Initialization script for Example 1.8: Simple Example (Outside C and D)                                                           
                                                                        
% initial conditions                                                    
x0 = 1;                                                                                                                      
                                                                        
% simulation horizon                                                    
T = 10;                                                                 
J = 20;                                                                 
                                                                        
% Set the behavior of the simulation in the intersection of C and D.                                                
% rule = 1 -> priority for jumps                                        
% rule = 2 -> priority for flows                                        
% rule = 3 -> no priority, random selection when simultaneous conditions
rule = 1;                                                                    

%solver tolerances
RelTol = 1e-8;
MaxStep = 0.001;