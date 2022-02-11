% Postprocessing script for Example 1.7: Synchronization of Fireflies

% Construct HybridArc objects for the trajectory of each subsystem, 
% as computed by Simulink, so that we can use the plotting tools associated
% with HybridArcs, namely HybridPlotBuilder.
sol_1 = HybridArc(t1, j1, x1);
sol_2 = HybridArc(t2, j2, x2);

% Individual plots 
figure(1) % H1 Flows and Jumps        
clf                                   
subplot(2,1,1)   
hpb = HybridPlotBuilder();
hpb.color([0 0.447 0.741]).label('$\tau_1$').title('Firefly 1 (Flows)');
hpb.plotFlows(sol_1)
grid on                         
                                      
subplot(2,1,2)
hpb.title('Firefly 1 (Jumps)');
hpb.plotJumps(sol_1)     
grid on                                 
               
%%
figure(2) % H2 Flows and Jumps        
clf                            
subplot(2,1,1)   
hpb = HybridPlotBuilder();
hpb.color([0.85 0.325 0.098]).label('$\tau_2$').title('Firefly 2 (Flows)');
hpb.plotFlows(sol_2)
grid on                         
                                      
subplot(2,1,2)
hpb.title('Firefly 2 (Jumps)');
hpb.plotJumps(sol_2)     
grid on                                 
                                      
%%                                  
figure(3) % H1 and H2, Flows and Jumps
clf                  
                                
subplot(2,1,1)   
hpb = HybridPlotBuilder();
hpb.color('matlab').title('Fireflies (Flows)');
hpb.legend('Firefly 1 ($\tau_1$)').plotFlows(sol_1)
hold on
hpb.legend('Firefly 2 ($\tau_2$)').plotFlows(sol_2)                        
                                      
subplot(2,1,2)
hpb.color('matlab').title('Fireflies (Jumps)');
hpb.legend('Firefly 1 ($\tau_1$)').plotJumps(sol_1)
hold on
hpb.legend('Firefly 2 ($\tau_2)$').plotJumps(sol_2)   
xlim([0, 7])