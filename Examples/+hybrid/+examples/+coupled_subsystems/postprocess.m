% Postprocessing script for Example 1.6: Simulation of a bouncing ball and moving platform.
 
sol1 = HybridArc(t1, j1, x1);
sol2 = HybridArc(t2, j2, x2);

xi1_arc = sol1.slice(1);                   
xi2_arc = sol1.slice(2);               
eta1_arc = sol2.slice(1);            
eta2_arc = sol2.slice(2);                                            
                                                                     
%% Individual plots                    
figure(1) %     
clf       

hpb = HybridPlotBuilder();

sp1 = subplot(2,1,1);
hpb.flowColor('blue')...
    .jumpColor([0 0 0.5]) % dark blue.
hpb.legend('$\xi_1$ (Ball)').plotFlows(xi1_arc) 
hold on
hpb.flowColor('red')...
    .jumpColor([0.7 0 0]) % dark red. 
hpb.legend('$\eta_1$ (Platform)').title('Height').plotFlows(eta1_arc) 
grid on                             
                                      
sp2 = subplot(2,1,2);
hpb.flowColor('blue')...
    .jumpColor([0 0 0.5]) % dark blue.
hpb.legend('$\xi_2$ (Ball)').plotFlows(xi2_arc) 
hold on
hpb.flowColor('red')...
    .jumpColor([0.7 0 0]) % dark red. 
hpb.legend({'$\eta_2$ (Platform)'}, 'Location', 'best').title('Velocity').plotFlows(eta2_arc) 
grid on                                                                       

%% Plot height of ball and platform vs. t.                  
figure(5) % H1 and H2, Flows and Jumps
clf 
hpb = HybridPlotBuilder();
hpb.color('matlab');
hpb.legend('$\xi_1$').plotFlows(xi1_arc)
hold on                               
hpb.legend('$\eta_1$').title('Height').plotFlows(eta1_arc)                           
grid on