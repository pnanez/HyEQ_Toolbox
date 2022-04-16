% Initialization script for Jump/Flow Behavior in the Intersection of C and D           
                                                                        
% Initial condition   
x0 = 1;                                                                                                                     
                                                                        
% Simulation horizon                                                    
T = 10;                                                                 
J = 20;                                                                 
                                                                        
% The rule for the behavior of simulations in the intersection of C and D 
% is set by clicking one of the blocks in the Simulink model. We define it if it
% has not been set, otherwise. 
if ~exist('rule', 'var')
    rule = 1;
end

% Solver tolerances
RelTol = 1e-8;
MaxStep = 1e-2;