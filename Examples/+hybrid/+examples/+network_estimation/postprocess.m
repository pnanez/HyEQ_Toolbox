% Postprocessing script for the estimation over network example

solz = HybridArc(tz, jz, z);
solhatz = HybridArc(thatz, jhatz, hatz);

% Plot solution
f = figure(1);
clf
f.Position = [100 100 740 500]; % Increase width
hpb = HybridPlotBuilder();
hpb.subplots('on').color('matlab');
hpb.legend('System state $x_1$','System state $x_2$',...
           'System state $x_3$','System state $x_4$')...
    .plotFlows(solz) 
hold on
hpb.legend({'Estimation $\hat{x}_1$',...
           'Estimation $\hat{x}_2$','Estimation $\hat{x}_3$',...
           'Estimation $\hat{x}_4$'},'Location', 'eastoutside')...
    .plotFlows(solhatz.select(1:4)) 
