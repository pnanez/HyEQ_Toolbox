% Initialization script for example: Estimation over Network

% Simulation horizon                                                    
T = 30;                                                                 
J = 100;  

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
A = [0  1  0  0;
    -1  0  0  0;
    -2  1 -1  0;
     2 -2  0 -2];
B = [0 0 1 0]';
M = [1 0 0 0];
% Estimator
L = [1; -0.9433; -0.6773;1.6274];
% P = [0.1180 0.2460 0.1889 0.1491;
%      0.2460 1.1788 1.0392 0.9646;
%      0.1889 1.0392 0.9407 0.8778;
%      0.1491 0.9646 0.8778 0.8328];

parameters = [A,B,M',L];

% Set the behavior of the simulation in the intersection of C and D.                                                     
% rule = 1 -> priority for jumps                                        
% rule = 2 -> priority for flows                                        
% rule = 3 -> no priority, random selection
rule = 1;                                                               
                                                                        
% Solver tolerances
RelTol = 1e-6;
MaxStep = 1e-2;