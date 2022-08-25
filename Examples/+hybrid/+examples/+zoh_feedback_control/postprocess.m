% Postprocessing script from Continuous-time Plant example.

sol_plant = HybridArc(ty, jy, y); % Plant state.
sol_ADC   = HybridArc(tzs, jzs, zs); % Digitized output of plant.
sol_ZOH   = HybridArc(tu, ju, u); % ZOH of input to plant.

figure(1)
clf
subplot(2,1,1)
hpb = HybridPlotBuilder();
hpb.color('matlab').title('States and measured states');
hpb.legend('$y_1$', '$y_2$').flowLineWidth(1).plotFlows(sol_plant)
hold on
hpb.legend('$zs_1$', '$zs_2$').plotFlows(sol_ADC.select(1:2))
grid on

subplot(2,1,2)
hpb = HybridPlotBuilder();
hpb.title('Control Signal').color('matlab');
hpb.plotFlows(sol_ZOH.select(1));
grid on

