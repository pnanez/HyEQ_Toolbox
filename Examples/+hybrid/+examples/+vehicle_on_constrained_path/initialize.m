% Initialization script for a Vehicle on a Track with Boundaries.
                                                                                                                                 
% Initial conditions                                                    
x0 = [0; 0; pi/4; 2];                                                                                               
                                                                        
% Simulation horizon                                                    
T = 15;                                                                 
J = 20;                                                                                                                            

% Solver tolerances
RelTol = 1e-8;
MaxStep = 1e-2;