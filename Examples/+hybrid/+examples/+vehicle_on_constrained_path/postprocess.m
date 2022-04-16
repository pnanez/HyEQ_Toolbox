% Postprocessing script for a vehicle on a track with boundaries.

% Construct a HybridArc object from (t, j, x) computed by Simulink so that we
% can use the plotting tools associated with HybridArcs, namely
% HybridPlotBuilder.
sol = HybridArc(t, j, x); %#ok<IJCL> 

% Plot solution                                           
figure(1)                                                 
clf                                                       
subplot(2,1,1),
hpb = HybridPlotBuilder();
hpb.label('$\xi_1$').title('Flows')...
    .plotFlows(sol.slice(1))                           
grid on        
                                                    
subplot(2,1,2)
hpb = HybridPlotBuilder();
hpb.label('$\xi_1$').title('Jumps')...
    .plotJumps(sol.slice(1))   
grid on
%%
% Plot states
figure(2)
clf
hpb = HybridPlotBuilder();
hpb.color('matlab').legend({'$\xi_1$','$\xi_2$','$\xi_3$'}, 'Location', 'best');
subplot(2, 1, 1)
hpb.plotFlows(sol.slice(1:3));
subplot(2, 1, 2)
hpb.legend('$q$').color('k');
hpb.plotFlows(sol.slice(4));
ylim([0.9, 2.5])
grid on
    
%% Plot trajectory
figure(3)
clf
plotHarcColor(x(:,2), j, x(:,1),t);
xlabel('\xi_2')
ylabel('\xi_1')
colorbar
title('Color bar indicates time (t)')
ax=colorbar;
ylabel(ax,'time t');
grid on
hold on
                                                          
%% Plot hybrid arc  
figure(4)
clf
hpb = HybridPlotBuilder();
hpb.label('$\xi_1$').plotHybrid(sol.slice(1))   
grid on
view(37.5,30)