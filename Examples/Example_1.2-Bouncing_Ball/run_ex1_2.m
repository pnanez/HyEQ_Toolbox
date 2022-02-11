% Example 1.2: Simulation of a bouncing ball

% Create a HybridSystem object from the given data.
sys = HybridSystem(@f_ex1_2, @g_ex1_2, @C_ex1_2, @D_ex1_2);

priority = hybrid.Priority.JUMP;

% Increase the accuracy for the ODE solver and increase the refinement of  
% solutions to make the resulting plots smoother.
config = HybridSolverConfig('RelTol', 1e-6, 'Refine', 12);

% Set the behavior of the simulation in the intersection of C and D.
config.priority('jump'); % 'jump' is the default, so this line is redundant.

% Set the ODE solver.
config.odeSolver('ode23t');

% Initial conditions
x1_0 = 1; % Initial height.
x2_0 = 0; % Initial velocity.
x0 = [x1_0,x2_0];

% Simulation horizon
TSPAN = [0 10]; % Horizon for ordinary time.
JSPAN = [0 20]; % Horizon for discrete time.

% Simulate
sol = sys.solve(x0, TSPAN, JSPAN, config);

% Plot the solution vs. t.
figure(1)
clf
plotFlows(sol)

% Plot the solution in the phase plane.
figure(2)
clf
plotPhase(sol)

% Plot the solution vs. t and j.
figure(3)
clf
plotHybrid(sol)


