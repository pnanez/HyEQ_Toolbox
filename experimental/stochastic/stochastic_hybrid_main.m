

system = 'ball';
% system = 'circle';
switch system
    case 'circle'
        sys = HybridSystemBuilder()...
            .flowMap(@(x) [0, 1; -1, 0]*x)...
            .flowSetIndicator(@(x) 1)...
            .jumpSetIndicator(@(x) 0)...
            .build();
        flowNoiseSD = @(x, t, j) 0.1*[-1*x(2), 0; 1*x(1), 0];
        jumpNoiseSD = @(x, t, j) [0; 0.5*norm(x)^2];
    case 'ball'
        sys = hybrid.examples.BouncingBall();
        sys.bounce_coeff = 0.9;
        flowNoiseSD = @(x, t, j) [0.0, 0; 0, 0.6];
        jumpNoiseSD = @(x, t, j) [0; 0];
end
stochastic_sys = StochasticHybridSystem(sys, flowNoiseSD, jumpNoiseSD);

tspan = [0, 10];
jspan = [0, 100];
config = HybridSolverConfig('silent', 'odeSolver', 'sde45', 'MaxStep', 0.01);

figure(1)
clf
hpb = HybridPlotBuilder().color('matlab').subplots('on');
for i=1:1
    sol = stochastic_sys.solve([1; 0], tspan, jspan, config);
    hpb.plotPhase(sol)
    hold on
    drawnow()
end

1-norm(sol.x(end, :)')