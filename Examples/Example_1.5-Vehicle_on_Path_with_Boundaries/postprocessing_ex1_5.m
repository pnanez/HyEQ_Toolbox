%--------------------------------------------------------------------------
% Matlab M-file Project: HyEQ Toolbox @  Hybrid Systems Laboratory (HSL), 
% https://hybrid.soe.ucsc.edu/software
% http://hybridsimulator.wordpress.com/
% Filename: postprocessing_ex1_5.m
%--------------------------------------------------------------------------
% Project: Simulation of a vehicle on a track with boundaries
% Description: postprocessing for the vehicle on a track with boundaries
% example
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%   See also HYEQSOLVER, PLOTARC, PLOTARC3, PLOTFLOWS, PLOTHARC,
%   PLOTHARCCOLOR, PLOTHARCCOLOR3D, PLOTHYBRIDARC, PLOTJUMPS.
%   Copyright @ Hybrid Systems Laboratory (HSL),
%   Revision: 0.0.0.3 Date: 05/20/2015 3:42:00

% plot solution                                           
figure(1)                                                 
clf                                                       
subplot(2,1,1),plotflows(t,j,x)                           
grid on                                                   
ylabel('\xi_1')                                               
                                                          
subplot(2,1,2),plotjumps(t,j,x)                           
grid on                                                   
ylabel('\xi_1')  

% plot states
figure(2)
clf
plotHarc(t,j,x);
xlabel('t')
ylabel('\xi_1, \xi_2, \xi_3, q')
legend('\xi_1','\xi_2','\xi_3','q')
grid on


% full trajectory

figure(3)
clf
plotHarcColor(x(:,2),j,x(:,1),t);
xlabel('\xi_2')
ylabel('\xi_1')
colorbar
title('Color bar represents time (t)')
grid on
hold on
                                                          
% plot hybrid arc  
figure(4)
clf
plotHybridArc(t,j,x(:,1))                                      
xlabel('j')                                               
ylabel('t')                                               
zlabel('\xi_1')    
grid on
view(37.5,30)