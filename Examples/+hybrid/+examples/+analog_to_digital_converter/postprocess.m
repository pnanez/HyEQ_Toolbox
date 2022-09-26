% Postprocessing script for Analog-to-digital converter example.

% Create hybrid arc objects.
sol_u = HybridArc(t, 0*t, vs);
sol = HybridArc(t, j, x); %#ok<IJCL> (suppress a warning about 'j')

% Plot solution
clf
subplot(2,1,1)
hpb = HybridPlotBuilder();
hold on
hpb.legend('ADC input')...
    .flowColor('green')...
    .jumpColor('none')...
    .plotFlows(sol_u.select(1));
hpb.legend('ADC output')...
    .color('blue')...
    .plotFlows(sol.select(1));

subplot(2,1,2)
hpb = HybridPlotBuilder();
hpb.legend('ADC timer')......
    .plotFlows(sol.select(2));


 