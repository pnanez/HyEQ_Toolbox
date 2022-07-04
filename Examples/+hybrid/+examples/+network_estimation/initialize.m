% Initialization script for example: Estimation over Network

% Simulation horizon                                                    
T = 30;                                                                 
J = 100;  

% Input
input_amplitude = 50;

% Constants (Network)
T_max = 3;  % Max time between communication events.
T_min = 0.2;% Min time between communication events.

% Initial conditions for Linear system.
z0 = [5; 0.1; 1; 0.6]; 
n = length(z0);

% Initial conditions for Network.
ms_0 = 0; % Initial output for Network.
tau_0 = 0;% Initial timer value for Network.         

% Initial condition for Estimator
zhat0 = [-10; 1/2; 0; 0; 0];

% System
parameters = struct();
parameters.A = [ 0  1  0  0;
                -1  0  0  0;
                -2  1 -1  0;
                 2 -2  0 -2];
parameters.B = [0 0 1 0]';
parameters.M = [1 0 0 0];
% Estimator
parameters.L = [1; -0.9433; -0.6773;1.6274];

% Set the behavior of the simulation in the intersection of C and D.                                                     
% rule = 1 -> priority for jumps                                        
% rule = 2 -> priority for flows                                        
% rule = 3 -> no priority, random selection
rule = 1;                                                               
                                                                        
% Solver tolerances
RelTol = 1e-6;
MaxStep = 1e-2;