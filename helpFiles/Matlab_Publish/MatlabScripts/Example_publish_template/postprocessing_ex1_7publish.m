%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Matlab M-file       Project: HyEQ Toolbox  @ Hybrid Dynamics and Control
% Lab, http://www.u.arizona.edu/~sricardo/index.php?n=Main.Software
%
% Filename: postprocessing_ex1_7.m
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%postprocessing for the synchronization of fireflies example

% Individual plots                    
figure(1) % H1 Flows and Jumps        
clf                                   
subplot(2,1,1),plotflows(t1,j1,x)     
grid on                               
ylabel('tau1')                          
                                      
subplot(2,1,2),plotjumps(t1,j1,x)     
grid on                               
ylabel('tau1')                          
                                      
figure(2) % H2 Flows and Jumps        
clf                                   
subplot(2,1,1),plotflows(t2,j2,x3)    
grid on                               
ylabel('tau2')                          
                                      
subplot(2,1,2),plotjumps(t2,j2,x3)    
grid on                               
ylabel('tau2')                          
                                      
                                      
figure(3) % H1 and H2, Flows and Jumps
clf                                   
subplot(2,1,1),plotflows(t1,j1,x)     
hold on                               
subplot(2,1,1),plotflows(t2,j2,x3)    
                                      
grid on                               
ylabel('tau1, tau2')                      
                                      
subplot(2,1,2),plotjumps(t1,j1,x)     
hold on                               
subplot(2,1,2),plotjumps(t2,j2,x3)    
                                      
grid on                               
ylabel('tau1, tau2')              

figure(4) % H1 and H2, Flows and Jumps
clf
plotHarc(t1,j1,[x,x3])
grid on                               
ylabel('tau1, tau2')      
legend('tau1','tau2')