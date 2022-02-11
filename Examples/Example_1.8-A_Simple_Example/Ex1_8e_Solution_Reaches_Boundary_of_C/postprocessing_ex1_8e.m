% Project: Simple Example
% Description: postprocessing for Simple Example (boundary of C)

% Construct a HybridArc object from (t, j, x) computed by Simulink so that we
% can use the plotting tools associated with HybridArcs, namely
% HybridPlotBuilder.
sol = HybridArc(t, j, x);

%% Plot solution
figure(1)
clf
subplot(2,1,1)
HybridPlotBuilder().plotFlows(sol)
grid on

subplot(2,1,2)
HybridPlotBuilder().plotJumps(sol)

ylabel('x')
xlim([-0.5, 0.5])
ylim([0.4, 1.1])

%%
figure(2)
clf
plotHybrid(sol)  