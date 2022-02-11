% Initialization script for Example 1.2: Bouncing Ball.

% Initial conditions
x0 = [1; 0];
          
% Physical variables
global gamma lambda
gamma = -9.81;  % gravity constant
lambda = 0.8;   % restitution coefficent

% Simulation horizon
T = 10;
J = 20;
                                                                        
% Set the behavior of the simulation in the intersection of C and D.
% rule = 1 -> priority for jumps
% rule = 2 -> priority for flows
% rule = 3 -> no priority, random selection when simultaneous conditions
rule = 1;                                                               
                                                                        
%solver tolerances
RelTol = 1e-6;
MaxStep = 1e-3;