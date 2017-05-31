%--------------------------------------------------------------------------
% Matlab M-file Project: HyEQ Toolbox @  Hybrid Systems Laboratory (HSL), 
% https://hybrid.soe.ucsc.edu/software
% http://hybridsimulator.wordpress.com/
% Filename: postprocessing_exADC.m
%--------------------------------------------------------------------------
% Project: Simulation of a hybrid system (Analog-to-digital converter)
% Description: postprocessing ADC
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%   See also plotflows, plotHarc, plotHarcColor, plotHarcColor3D,
%   plotHybridArc, plotjumps.
%   Copyright @ Hybrid Systems Laboratory (HSL),
%   Revision: 0.0.0.3 Date: 05/20/2015 3:42:00


x = [z,hatz];
t = [tz,thatz];
j = [jz,jhatz];

% plot solution
figure(1) 
clf
subplot(4,1,1),plotarc([tz,thatz],[jz,jhatz],[z(:,1),hatz(:,1)]);
legend('System state x1','Estimation hatx1')
grid on
ylabel('x1 vs hatx1')
xlabel('time')
subplot(4,1,2),plotarc([tz,thatz],[jz,jhatz],[z(:,2),hatz(:,2)]);
legend('System state x2','Estimation hatx2')
grid on
ylabel('x2 vs hatx2')
xlabel('time')
subplot(4,1,3),plotarc([tz,thatz],[jz,jhatz],[z(:,3),hatz(:,3)]);
legend('System state x1','Estimation hatx1')
grid on
ylabel('x3 vs hatx3')
xlabel('time')
subplot(4,1,4),plotarc([tz,thatz],[jz,jhatz],[z(:,4),hatz(:,4)]);
legend('System state x4','Estimation hatx4')
grid on
ylabel('x4 vs hatx4')
xlabel('time')
 