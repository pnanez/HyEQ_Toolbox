%--------------------------------------------------------------------------
% Matlab M-file Project: HyEQ Toolbox @  Hybrid Systems Laboratory (HSL), 
% https://hybrid.soe.ucsc.edu/software
% http://hybridsimulator.wordpress.com/
% Filename: postprocessing_ex1_8b.m
%--------------------------------------------------------------------------
% Project: Simple Example
% Description: postprocessing for Simple Example (flows enforced)
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%   See also HYEQSOLVER, PLOTARC, PLOTARC3, PLOTFLOWS, PLOTHARC,
%   PLOTHARCCOLOR, PLOTHARCCOLOR3D, PLOTHYBRIDARC, PLOTJUMPS.
%   Copyright @ Hybrid Systems Laboratory (HSL),
%   Revision: 0.0.0.3 Date: 05/20/2015 3:42:00

% plot solution
figure(1)
clf
clear modificatorF modificatorJ
modificatorF{1} = 'b'; % pick the color for the flow
subplot(2,1,1),plotarc(t,j,x,[],[],modificatorF);
grid on
ylabel('x')
xlabel('flows [t]')

modificatorF{1} = 'b--';
subplot(2,1,2),plotarc(j,j,x,[],[],modificatorF);
grid on
ylabel('x')
xlabel('jumps [j]')
               