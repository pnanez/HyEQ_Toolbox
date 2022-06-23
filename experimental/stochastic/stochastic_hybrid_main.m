
flowNoiseSD = @(x, t, j) [0, 0; 0, 0.0];
jumpNoiseSD = @(x, t, j) [0; 0.5*norm(x)^2];

% system = 'ball';
system = 'circle';
switch system
    case 'circle'
        sys = HybridSystemBuilder()...
            .flowMap(@(x) [0, 1; -1, 0]*x)...
            .flowSetIndicator(@(x) 1)...
            .jumpSetIndicator(@(x) 0)...
            .build();
    case 'ball'
        sys = hybrid.examples.BouncingBall();
        sys.bounce_coeff = 0.9;
end
stochastic_sys = StochasticHybridSystem(sys, flowNoiseSD, jumpNoiseSD)

tspan = [0, 10];
jspan = [0, 10];
config = HybridSolverConfig('odeSolver', 'sde45');
sol = stochastic_sys.solve([1; 0], tspan, jspan, config);
plotPhase(sol)

1-norm(sol.x(end, :)')