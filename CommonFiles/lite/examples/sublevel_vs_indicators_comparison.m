sys_sl = SublevelSetsHybridSystem();
sys_ind= ExampleBouncingBallHybridSystem();
sys_sl.bounce_coeff = 1;
sys_ind.bounce_coeff = 1;

x0 = [0.01; 0];
tspan = [0, 300];
jspan = [0, 100];
config_sl = HybridSolverConfig("silent");
config_ind = HybridSolverConfig("silent");
%% Time the two methods
t_sublev = timeit(@() sys_sl.solve(x0, tspan, jspan, config_sl));
t_ind = timeit(@() sys_ind.solve(x0, tspan, jspan, config_ind));

fprintf("The time to compute was %f using indicator functions and %f using sublevel sets. A %.0f%% change.\n",...
    t_ind, t_sublev, 100*(t_sublev - t_ind)/ t_ind) 
%% Profile the methods
profile on
% sys_sl.solve(x0, tspan, jspan, config_sl)
sys_ind.solve(x0, tspan, jspan, config_ind)
p = profile('info');
profile viewer
profile off

%% 
% sol_sl = sys_sl.solve(x0, tspan, jspan, config)
sol_ind = sys_ind.solve(x0, tspan, jspan, config_ind)
%%
figure(1)
clf
% plotflows(sol_sl)
plotflows(sol_ind)