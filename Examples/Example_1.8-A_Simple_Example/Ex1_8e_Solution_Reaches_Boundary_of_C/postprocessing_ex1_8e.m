%--------------------------------------------------------------------------
% Matlab M-file Project: HyEQ Toolbox @  Hybrid Systems Laboratory (HSL), 
% https://hybrid.soe.ucsc.edu/software
% http://hybridsimulator.wordpress.com/
% Filename: postprocessing_ex1_8e.m
%--------------------------------------------------------------------------
% Project: Simple Example
% Description: postprocessing for Simple Example (boundary of C)
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%   See also plotflows, plotHarc, plotHarcColor, plotHarcColor3D,
%   plotHybridArc, plotjumps.
%   Copyright @ Hybrid Systems Laboratory (HSL),
%   Revision: 0.0.0.3 Date: 05/20/2015 3:42:00

% plot solution
figure(1)
clf
subplot(2,1,1),plotflows(t,j,x)
grid on
ylabel('x')

subplot(2,1,2),plotjumps(t,j,x)
grid on
ylabel('x')

figure(2)
plotHybridArc(t,j,x)
xlabel('j')
ylabel('t')
zlabel('x')                 