% Initialization script for Bouncing Ball example.

% Initial conditions
x0 = [1; 0];
          
% Physical variables
parameters = struct();
parameters.gravity = -9.81;  % gravity constant
parameters.lambda = 0.9; % restitution coefficent

% Simulation horizon
T = 10;
J = 30;                                                       
                                                                        
% Solver tolerances
RelTol = 1e-6;
MaxStep = 1e-2;