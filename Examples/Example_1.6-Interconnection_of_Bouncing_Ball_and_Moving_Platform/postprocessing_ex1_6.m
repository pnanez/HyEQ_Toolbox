%--------------------------------------------------------------------------
% Matlab M-file Project: HyEQ Toolbox @  Hybrid Systems Laboratory (HSL), 
% https://hybrid.soe.ucsc.edu/software
% http://hybridsimulator.wordpress.com/
% Filename: postprocessing_ex1_6.m
%--------------------------------------------------------------------------
% Project: Simulation of a bouncing ball and moving platform 
% Description: postprocessing for the interconnection of bouncing ball and
% moving platform example
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%   See also HYEQSOLVER, PLOTARC, PLOTARC3, PLOTFLOWS, PLOTHARC,
%   PLOTHARCCOLOR, PLOTHARCCOLOR3D, PLOTHYBRIDARC, PLOTJUMPS.
%   Copyright @ Hybrid Systems Laboratory (HSL),
%   Revision: 0.0.0.3 Date: 05/20/2015 3:42:00

% for the interconnection of a example 

xi1 = x1(:,1);                        
xi2 = x1(:,2);                                                 
eta1 = x2(:,1);                       
eta2 = x2(:,2);                                              
                                                                     
% Individual plots                    
figure(1) % H1 Flows and Jumps        
clf                                   
subplot(2,1,1),plotflows(t1,j1,xi1)   
grid on                               
ylabel('\xi_1')                       
                                      
subplot(2,1,2),plotjumps(t1,j1,xi1)   
grid on                               
ylabel('\xi_1')                       
                                      
figure(2) % H1 Velocity               
clf                                   
subplot(2,1,1),plotflows(t1,j1,xi2)   
grid on                               
ylabel('\xi_2')                       
                                      
subplot(2,1,2),plotjumps(t1,j1,xi2)   
grid on                               
ylabel('\xi_2')                       
                                      
figure(3) % H2 Flows and Jumps        
clf                                   
subplot(2,1,1),plotflows(t2,j2,eta1)  
grid on                               
ylabel('\eta_1')                      
                                      
subplot(2,1,2),plotjumps(t2,j2,eta1)  
grid on                               
ylabel('\eta_1')                      
                                      
figure(4) % H2 Velocity               
clf                                   
subplot(2,1,1),plotflows(t2,j2,eta2)  
grid on                               
ylabel('\eta_2')                      
                                      
subplot(2,1,2),plotjumps(t2,j2,eta2)  
grid on                               
ylabel('\eta_2')                      
                                      
figure(5) % H1 and H2, Flows and Jumps
clf                                   
subplot(2,1,1),plotflows(t1,j1,xi1)   
hold on                               
subplot(2,1,1),plotflows(t2,j2,eta1)  
                                      
grid on                               
ylabel('\xi_1, \eta_1')               
                                      
subplot(2,1,2),plotflows(t1,j1,xi2)   
hold on                               
subplot(2,1,2),plotflows(t2,j2,eta2)  
                                      
grid on                               
ylabel('\xi_2, \eta_2')     

%% Plot the same figures using plotHarc
% Individual plots                    
figure(6) % H1 Flows and Jumps        
clf                                   
subplot(2,1,1),plotHarc(t1,j1,xi1);   
grid on                               
ylabel('\xi_1')                       
                                                                            
subplot(2,1,2),plotHarc(t1,j1,xi2);   
grid on                               
ylabel('\xi_2')                       
                                      
figure(7) % H2 Flows and Jumps        
clf                                   
subplot(2,1,1),plotHarc(t2,j2,eta1);  
grid on                               
ylabel('\eta_1')                      
subplot(2,1,2),plotHarc(t2,j2,eta2);  
grid on                               
ylabel('\eta_2')                      
                                      
figure(8) % H1 and H2, Flows and Jumps
clf                                   
subplot(2,1,1),plotHarc(t1,j1,[xi1,eta1]);   
grid on                               
ylabel('\xi_1, \eta_1')               
                                      
subplot(2,1,2),plotHarc(t1,j1,[xi2,eta2]);   
grid on                               
ylabel('\xi_2, \eta_2')     

