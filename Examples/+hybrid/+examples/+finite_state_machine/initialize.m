% Initialization script for the finite state machine.                                                

% Initial conditions                                                    
q0 = [0; 0];             

% Simulation horizon                                                    
T = 10;                                                                 
J = 20;                                                                 
                                                                        
% Rule for jumps                                                        
% rule = 1 -> priority for jumps                                        
% rule = 2 -> priority for flows                                        
% rule = 3 -> no priority, random selection when simultaneous conditions
rule = 1;                                                               
                                                                        
% Solver tolerances
RelTol = 1e-6;
MaxStep = 1e-3;