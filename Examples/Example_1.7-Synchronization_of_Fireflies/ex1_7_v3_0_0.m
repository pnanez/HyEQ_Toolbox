ff = Firefly();
sys = CompoundHybridSystem([ff, ff]);
sys.kappa_C{1} = @(x1, x2, t, j) x2;
sys.kappa_C{2} = @(x1, x2, t, j) x1;
sys.kappa_D{1} = @(x1, x2, t, j) x2;
sys.kappa_D{2} = @(x1, x2, t, j) x1;

tspan = [0, 30];
jspan = [0, 100];
x1_0 = 0.5;                                                            
x2_0 = 0; 
x0 = {x1_0, x2_0};
sol = sys.solve(x0, tspan, jspan);
HybridPlotBuilder().slice(1).plotflows(sol)
hold on
HybridPlotBuilder().slice(2).flowColor('k').jumpColor('g').plotflows(sol)