% Initialization script for the finite state machine.                                                

% Initial conditions                                                    
q0 = [0; 0];             

% Simulation horizon                                                    
T = 10;                                                                 
J = 20;                                                                                                                              
                                                                        
% Solver tolerances
RelTol = 1e-6;
MaxStep = 1e-3;