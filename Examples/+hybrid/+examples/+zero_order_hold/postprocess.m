% Postprocessing script for Example 4.3: Analog-to-digital converter (ADC)

sol_zoh = HybridArc(t, j, x); %#ok<IJCL> 
sol_input = HybridArc(t1, j1, x1);

figure(1)
clf
hb = HybridPlotBuilder();
hb.subplots('on');
hold on
hb.legend('ZOH input', 'ZOH input')...
    .color('green')...
    .plotFlows(sol_input);
hb.legend('ZOH output', 'ZOH output')...
    .flowColor('blue')...
    .jumpColor('blue')...
    .plotFlows(sol_zoh.slice(1:2));