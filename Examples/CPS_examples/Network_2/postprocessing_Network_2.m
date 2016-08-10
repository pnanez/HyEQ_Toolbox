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
legend('System state z1','Estimation hatz1')
grid on
ylabel('z1 vs hatz1')
xlabel('time')
subplot(4,1,2),plotarc([tz,thatz],[jz,jhatz],[z(:,2),hatz(:,2)]);
legend('System state z2','Estimation hatz2')
grid on
ylabel('z2 vs hatz2')
xlabel('time')
subplot(4,1,3),plotarc([tz,thatz],[jz,jhatz],[z(:,3),hatz(:,3)]);
legend('System state z1','Estimation hatz1')
grid on
ylabel('z3 vs hatz3')
xlabel('time')
subplot(4,1,4),plotarc([tz,thatz],[jz,jhatz],[z(:,4),hatz(:,4)]);
legend('System state z1','Estimation hatz1')
grid on
ylabel('z1 vs hatz1')
xlabel('time')
 