%% Example: Bouncing Ball implemented using HybridSystem
% In this example, we create and solve a bouncing ball hybrid system 
% using the |HybridSystem| class. 
% 
% For a full description of this example, find the following page in the  
% HyEQ Toolbox Help:
%   Hybrid Equations MATLAB Library > Creating and Simulating Hybrid Systems

%% Create a BouncingBall object.
sys = hybrid.examples.BouncingBall();

% Modify the values of properties
sys.gamma = 3.72; % Acceleration due to gravity.
sys.lambda = 0.8; % Coefficient of restitution.

%% Check that C and D are correct.
% Check a point above above ground.
x_ball_above_ground = [1; 0];
sys.assertInC(x_ball_above_ground);    
sys.assertNotInD(x_ball_above_ground);

% Check a point at the ground (and stationary).
x_ball_at_ground = [0; 0];
sys.assertInC(x_ball_at_ground); 
sys.assertInD(x_ball_at_ground);

% Check a point below the ground (and moving downward).
x_ball_below_ground = [-1; -1];
sys.assertNotInC(x_ball_below_ground); 
sys.assertInD(x_ball_below_ground);

%% Compute a solution

% Initial condition
x0 = [10, 0];
% Time spans
tspan = [0, 20];
jspan = [0, 30];

% Specify solver options.
config = HybridSolverConfig('AbsTol', 1e-3, 'RelTol', 1e-7);

% Compute solution
sol = sys.solve(x0, tspan, jspan, config);

%% Plot the solution
figure(1)
clf
hpb = HybridPlotBuilder();
hpb.title('Bouncing Ball')...
    .subplots('on')...
    .plotFlows(sol)

%% Compute and plot the total energy of the bouncing ball along the solution.
figure(2)
clf
energy_fnc = @(x) sys.gamma*x(1) + 0.5*x(2)^2;
plotFlows(sol.transform(energy_fnc))
title('Total Energy of Bouncing Ball')
ylabel('Energy')