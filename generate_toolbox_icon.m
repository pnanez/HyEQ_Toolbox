sys = hybrid.examples.BouncingBall();
sys.lambda = 0.85;
x0 = [3; 4];
tspan = [0 100];
jspan = [0 30];
config = HybridSolverConfig('refine', 32);
sol = sys.solve(x0, tspan, jspan, config);
% plotHybrid(sol.select(1))

plotFlows(sol.select(1))
ylim([0, 4])