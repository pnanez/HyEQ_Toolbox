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
%   See also PLOTARC, PLOTARC3, PLOTFLOWS, PLOTHARC, PLOTHARCCOLOR,
%   PLOTHARCCOLOR3D, PLOTHYBRIDARC, PLOTJUMPS.
%   Copyright @ Hybrid Systems Laboratory (HSL),
%   Revision: 0.0.0.3 Date: 05/20/2015 3:42:00


% plot solution
figure(1) 
clf
subplot(2,1,1),plot(t,vs,'r');
hold on;
subplot(2,1,1),plotHarc(t,j,x(:,end-1));
legend('input','output')
grid on
ylabel('input Vs. output')
subplot(2,1,2),plotHarc(t,j,x(:,end));
grid on
ylabel('timer')
xlabel('time')


 