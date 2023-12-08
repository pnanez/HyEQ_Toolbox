% Initialization script for Mobile Robot Example
                                                                
% Initial conditions                                                    
z0 = [0; 0; 0];   

% Parameters
parameters = struct();
parameters.minU = -1;
parameters.maxU = 1;
parameters.maxX = 5;

% Simulation horizon                                                    
T = 10;                                                                 
J = 20;                                                                                                                          
                                                                        
% Solver tolerances
RelTol = 1e-6;
MaxStep = 1e-3;