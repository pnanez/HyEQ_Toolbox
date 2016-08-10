%--------------------------------------------------------------------------
% Matlab M-file Project: HyEQ Toolbox @  Hybrid Systems Laboratory (HSL), 
% https://hybrid.soe.ucsc.edu/software
% http://hybridsimulator.wordpress.com/
% Filename: postprocessing_ex1_7.m
%--------------------------------------------------------------------------
% Project: Simulation of synchronization of fireflies
% Description: postprocessing for synchronization of fireflies example
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%   See also HYEQSOLVER, PLOTARC, PLOTARC3, PLOTFLOWS, PLOTHARC,
%   PLOTHARCCOLOR, PLOTHARCCOLOR3D, PLOTHYBRIDARC, PLOTJUMPS.
%   Copyright @ Hybrid Systems Laboratory (HSL),
%   Revision: 0.0.0.3 Date: 05/20/2015 3:42:00

% Individual plots                    
figure(1) % H1 Flows and Jumps        
clf                                   
subplot(2,1,1),plotflows(t1,j1,x);     
grid on                               
ylabel('tau1')                          
                                      
subplot(2,1,2),plotjumps(t1,j1,x);     
grid on                               
ylabel('tau1')                          
                                      
figure(2) % H2 Flows and Jumps        
clf                                   
subplot(2,1,1),plotflows(t2,j2,x3);    
grid on                               
ylabel('tau2')                          
                                      
subplot(2,1,2),plotjumps(t2,j2,x3);    
grid on                               
ylabel('tau2')                          
                                      
                                      
figure(3) % H1 and H2, Flows and Jumps
clf                                   
subplot(2,1,1),plotflows(t1,j1,x);     
hold on                               
subplot(2,1,1),plotflows(t2,j2,x3) ;   
                                      
grid on                               
ylabel('tau1, tau2')                      
                                      
subplot(2,1,2),plotjumps(t1,j1,x);     
hold on                               
subplot(2,1,2),plotjumps(t2,j2,x3);    
                                      
grid on                               
ylabel('tau1, tau2')              


figure(4) % H1 and H2, Flows and Jumps
clf
plotarc([t1,t2],[j1,j2],[x,x3]);
grid on                               
ylabel('tau1, tau2')      
legend('tau1','tau2')