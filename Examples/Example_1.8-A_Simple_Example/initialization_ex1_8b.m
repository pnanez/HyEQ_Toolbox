% Initialization for Example 1.8 (flows enforced)                                                       
                                                                        
% Initial conditions                                                    
x0 = 1;                                                             
                                                                                                                                   
% Simulation horizon                                                    
T = 10;                                                                 
J = 20;                                                                 
                                             
% Rule for intersection of jump and flow sets.                                                     
% rule = 1 -> priority for jumps                                        
% rule = 2 -> priority for flows                                        
% rule = 3 -> no priority, random selection when simultaneous conditions
rule = 2;                                                               
                                                          
% Solver tolerances
RelTol = 1e-8;
MaxStep = 1e-3;