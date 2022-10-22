% Initialization script for Bouncing Ball example.

% Initial conditions
x0 = [1; 0];
          
% Physical variables
parameters = struct();
parameters.gamma = -9.81; % Acceleration due to gravity.
parameters.lambda = 0.9;  % Coefficient of restitution.

% Simulation horizon
T = 10;
J = 30;                                                       
                                                                        
% Solver tolerances
RelTol = 1e-6;
MaxStep = 1e-2;