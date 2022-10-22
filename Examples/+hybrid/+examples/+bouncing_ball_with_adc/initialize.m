% Initialization script for analog-to-digital converter example 2.)
                                                                  
% Initial conditions (bouncing ball)
x0bb = [1;0]; 

% Initial conditions (ACD)
tau0 = 0;
x0ADC = [x0bb;tau0];             

% Constants (ACD)
Ts = 0.1;

% physical variables (bouncing ball)
parameters = struct();
parameters.gamma = -9.81; % Acceleration due to gravity.
parameters.lambda = 0.8;  % Coefficient of restitution.

% simulation horizon                                                    
T = 10;                                                                 
J = 100;                                                                 
                                                         
%solver tolerances
RelTol = 1e-6;
MaxStep = 1e-3;