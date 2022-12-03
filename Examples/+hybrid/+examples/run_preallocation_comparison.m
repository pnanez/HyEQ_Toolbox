% This script demonstrates the performance gains from using preallocation of
% arrays in HyEQsolver. 

% Define size of x and initial condition.
n = 100;
x0 = zeros(n, 1);

% simulation horizon
time = 1000;
j_lim = 5000;
TSPAN = [0 time];
JSPAN = [0 j_lim];

% Rule: Jump priority.
rule = 1;

% Define ODE solver options.
options = odeset('RelTol',1e-7, 'MaxStep', 0.01);

% Define the data of a hybrid system. The first component is a timer variable
% and the other n-1 components evolve sinusoidally (which is not important). 
f = @(x) [1; cos(x(1) * 10 * pi)*ones(n-1, 1)];
g = @(x) [0; x(2:end)];
C = @(x) 1;
D = @(x) x(1) >= 0.01;

%%
tic
% We can configure the preallocation of arrays by setting the values of
% prealloc_size, prealloc_growth_factor, and max_prealloc_size in 'options'. 

% Initially preallocate 1e3 rows.
options.prealloc_size = 1e3;
% Each time the a new preallocation is done, increase the prellaction size by 2x.
options.prealloc_growth_factor = 2; 
% Allow a maximum of 1e6 rows to be preallocated at a time.
options.max_prealloc_size = 1e6;
[t, j, x] = HyEQsolver(f, g, C, D, x0, TSPAN, JSPAN, rule, options, 'ode45'); 
tictocktime = toc;
fprintf('Simulation time with preallocation: %.2f seconds.\n', tictocktime)

%%
tic
options.prealloc_size = 1; % No preallocation.
options.max_prealloc_size = 1; % No preallocation.
options.prealloc_growth_factor = 1; % No preallocation.
HyEQsolver(f, g, C, D, x0, TSPAN, JSPAN, rule, options, 'ode45');   
tictocktime = toc;
fprintf('Simulation time without preallocation: %.2f seconds.\n', tictocktime)

