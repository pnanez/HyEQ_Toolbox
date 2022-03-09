% Configure system
ff = FireflySubsystem();
sys = CompositeHybridSystem(ff, ff);
sys.setInput(1, @(x1, x2) x2);
sys.setInput(2, @(x1, x2) x1);

% Solve 
tspan = [0, 7];
jspan = [0, 40];
x0 = {0.5, 0};
sol = sys.solve(x0, tspan, jspan);
ff1_sol = sol(1);
ff2_sol = sol(2);

% Plot
clf
pb = HybridPlotBuilder();
pb.flowColor('b').jumpColor('b').plotFlows(ff1_sol)
hold on
pb.flowColor('k').jumpColor('k').plotFlows(ff2_sol)
pb.legend('Firefly 1', 'Firefly2')
ylim([0, 1])