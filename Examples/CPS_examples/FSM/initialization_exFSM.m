% Project: Simulation of a hybrid system (Finite state machine)
% Description: initialization FSM                                                                    

% Initial conditions                                                    
x0 = [1;2];             

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