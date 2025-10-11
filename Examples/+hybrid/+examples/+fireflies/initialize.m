% Initialization script for Synchronization of Fireflies.
                                                         
% Initial conditions                                                    
x1_0 = 0.5;                                                            
x2_0 = 0;                                                             

% Biological coefficient for jump in periodic cycle
e = 0.3;

% simulation horizon                                                    
T = 8;                                                                 
J = 15;                                                                                                                             
                                                                        
% Solver tolerances
RelTol = 1e-8;
MaxStep = 1e-2;