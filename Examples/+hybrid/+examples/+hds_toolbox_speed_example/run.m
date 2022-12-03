
time = 1000;
j_lim = 5000;

States_init = zeros(100, 1);

% simulation horizon
TSPAN = [0 time];
JSPAN = [0 j_lim];

% rule for jumps
rule = 1;

options = odeset('RelTol',1e-7,'MaxStep', 0.01);

f = @hybrid.examples.hds_toolbox_speed_example.f;
g = @hybrid.examples.hds_toolbox_speed_example.g;
C = @hybrid.examples.hds_toolbox_speed_example.C;
D = @hybrid.examples.hds_toolbox_speed_example.D;
%%
tic
HyEQsolver_old_fast( f, g, C, D,...
    States_init, TSPAN, JSPAN, rule, options, 'ode45');   
tictocktime = toc;
fprintf('Simulation time for my old script: %.2f seconds.\n', tictocktime)
%%
tic
options.prealloc_size = 1; % No preallocation.
options.max_prealloc_size = 1;
options.prealloc_growth_factor = 2;
HyEQsolver(f, g, C, D,...
    States_init, TSPAN, JSPAN, rule, options, 'ode45');   
tictocktime = toc;
fprintf('Simulation time for current implementation: %.2f seconds.\n', tictocktime)
%%
tic
options.prealloc_size = 1e3;
options.max_prealloc_size = 1e6;
options.prealloc_growth_factor = 2;
[t, j, x] = HyEQsolver(f, g, C, D,...
    States_init, TSPAN, JSPAN, rule, options, 'ode45'); 
tictocktime = toc;
fprintf('Simulation time for new, accelerated implementation: %.2f seconds.\n', tictocktime)

