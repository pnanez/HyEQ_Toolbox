function xdot = f(x, u, ctes)
%--------------------------------------------------------------------------
% Matlab M-file Project: HyEQ Toolbox @  Hybrid Systems Laboratory (HSL), 
% https://hybrid.soe.ucsc.edu/software
% http://hybridsimulator.wordpress.com/
%--------------------------------------------------------------------------
% Project: Simulation of a hybrid system (plant with constraints in the
% state and the input)
% Description: Flow map
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%   See also PLOTARC, PLOTARC3, PLOTFLOWS, PLOTHARC, PLOTHARCCOLOR,
%   PLOTHARCCOLOR3D, PLOTHYBRIDARC, PLOTJUMPS.
%   Copyright @ Hybrid Systems Laboratory (HSL),
%   Revision: 0.0.0.3 Date: 05/20/2015 3:42:00
%--------------------------------------------------------------------------
% flow map: xdot=f(x,u);

% ctes = [A,B,C,K'];

A = ctes(:,1:2);
B = ctes(:,3);
C = ctes(:,4:5);
K = ctes(:,6)';

xdot = A*x + B*u;
