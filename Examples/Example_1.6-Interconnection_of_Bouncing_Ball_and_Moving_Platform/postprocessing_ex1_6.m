% Project: Simulation of a bouncing ball and moving platform 
% Description: postprocessing for the interconnection of bouncing ball and
% moving platform example
 
sol1 = HybridArc(t1, j1, x1);
sol2 = HybridArc(t2, j2, x2);

xi1 = x1(:,1);                        
xi2 = x1(:,2);                                                 
eta1 = x2(:,1);                       
eta2 = x2(:,2); 
xi1_arc = sol1.slice(1);                   
xi2_arc = sol1.slice(2);               
eta1_arc = sol2.slice(1);            
eta2_arc = sol2.slice(2);                                            
                                                                     
%% Individual plots                    
figure(1) % H1 Flows and Jumps        
clf       
subplot(2,1,1)
hpb = HybridPlotBuilder();
hpb.label('$\xi_1$').plotFlows(xi1_arc)   
grid on                             
                                      
subplot(2,1,2)
hpb.plotJumps(xi1_arc)   
grid on                       
   
%%
figure(2) % H1 Velocity               
clf                
subplot(2,1,1)
hpb = HybridPlotBuilder();
hpb.label('$\xi_2$').plotFlows(xi2_arc)   
grid on                             
                                      
subplot(2,1,2)
hpb.plotJumps(xi2_arc)   
grid on                       
     
%%
figure(3) % H2 Flows and Jumps        
clf                    

subplot(2,1,1)
hpb = HybridPlotBuilder();
hpb.label('$\eta_1$').plotFlows(eta1_arc)   
grid on                             
                              
subplot(2,1,2)
hpb.plotJumps(eta1_arc)   
grid on                         
           
%%
figure(4) % H2 Velocity               
clf                     
subplot(2,1,1)
hpb = HybridPlotBuilder();
hpb.label('$\eta_2$').plotFlows(eta2_arc)   
grid on                             
                                      
subplot(2,1,2)
hpb.plotJumps(eta2_arc)   
grid on   

%%                      
figure(5) % H1 and H2, Flows and Jumps
clf 
hpb = HybridPlotBuilder();
hpb.color('matlab');
hpb.legend('$\xi_1$').plotFlows(xi1_arc)
hold on                               
hpb.legend('$\eta_1$').plotFlows(eta1_arc)                           
grid on