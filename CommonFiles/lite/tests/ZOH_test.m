close all
A = [-1, 0; -2, 0];
B = eye(2);
plant = LinearTimeInvariantPlant(A, eye(2));

K = [0, 2; 0, -1];
% assert(all(real(eig(K)) < 0))

sample_time = 0.5;

kappa = @(x) K * x;
system = SystemWithZOH(plant, kappa, sample_time);

z0 = rand([plant.state_dimension,1]);
v0 = 5;
q0 = 0;
zoh0 = zeros(plant.input_dimension, 1);
tau0 = Inf;

x0 = [z0; zoh0; tau0];
tspan = [0 20];
jspan = [0 300];

sol = system.solve(x0, tspan, jspan);

HybridPlotBuilder().slice(1:4).plotFlows(sol);
% figure()
% HybridPlotBuilder().labels("$u_1$", "$u_2$")...
%     .slice(1:2).plotFlows(sol.subsystem2_sol);
