function xplus = g_ex1_2MP(x)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Matlab M-file               Author: Torstein Ingebrigtsen B??
%
% Project: Simulation of a hybrid system (bouncing ball)
%
% Description: Jump map
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% state
x1 = x(1);
x2 = x(2);
lambda = 0.8;
xplus = [-x1 ; -lambda*x2];
end