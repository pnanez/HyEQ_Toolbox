% Initialization script for Continuous-time Plant with ZOH Feedback example.
                                                                 
% Parameters
b = 2;
m = 4;
Ts = 0.3;
k1 = -10;
k2 = -10;

A = [0 1;
     0 -b/m];
B = [0;
     1/m];
C = [1 0;
     0 1];
K = [k1 k2];
parameters = [A,B,C,K'];

% Initial conditions                                                    
x0  = [1; 1];
zs0 = [C*x0; 0];
u0  = 0;
zh0 = [u0; 0];
useZHO = 1; % Enable the ZOH? 1 = yes, -1 = no;

% Simulation horizon                                                    
T = 10;                                                                 
J = 200;    

% Set the behavior of the simulation in the intersection of C and D.                                                   
% rule = 1 -> priority for jumps                                        
% rule = 2 -> priority for flows                                        
% rule = 3 -> no priority, random selection when in C \cap D.
rule = 1;                                                               
                                                                        
% Solver tolerances
RelTol = 1e-6;
MaxStep = 1e-3;