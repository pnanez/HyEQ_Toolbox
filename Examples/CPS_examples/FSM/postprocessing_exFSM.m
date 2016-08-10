%--------------------------------------------------------------------------
% Matlab M-file Project: HyEQ Toolbox @  Hybrid Systems Laboratory (HSL), 
% https://hybrid.soe.ucsc.edu/software
% http://hybridsimulator.wordpress.com/
% Filename: postprocessing_exADC.m
%--------------------------------------------------------------------------
% Project: Simulation of a hybrid system (Finite state machine)
% Description: initialization FSM
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%   See also PLOTARC, PLOTARC3, PLOTFLOWS, PLOTHARC, PLOTHARCCOLOR,
%   PLOTHARCCOLOR3D, PLOTHYBRIDARC, PLOTJUMPS.
%   Copyright @ Hybrid Systems Laboratory (HSL),
%   Revision: 0.0.0.3 Date: 05/20/2015 3:42:00


% plot solution
figure(1) 
clf
subplot(2,1,1),plot(t,vs);
legend('u_1 (input)','u_2 (input)')
grid on
ylabel('input')
ylim([.5,2.5]);
subplot(2,1,2),plotHarc(t,j,x);
legend('q_1 (output)','q_2 (output)')
grid on
ylabel('output')
ylim([.5,2.5]);
 