% Project: Simple Example
% Description: initialization for Simple Example                                                         
                                                                        
% initial conditions                                                    
x0 = 1;                                                                                                                     
                                                                        
% simulation horizon                                                    
T = 10;                                                                 
J = 20;                                                                 
                                                                        
% rule for jumps                                                        
% rule = 1 -> priority for jumps                                        
% rule = 2 -> priority for flows                                        
% rule = 3 -> no priority, random selection when simultaneous conditions
rule = 1;                                                               
                                                                        
%solver tolerances
RelTol = 1e-8;
MaxStep = .001;