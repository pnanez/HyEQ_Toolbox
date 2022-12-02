
time = 1000;
j_lim = 50000;

States_init = [0 0]';

% simulation horizon
TSPAN = [0 time];
JSPAN = [0 j_lim];

% rule for jumps
% rule = 1 -> priority for jumps
% rule = 2 -> priority for flows
rule = 1;

options = odeset('RelTol',1e-7,'MaxStep',.01);


%%
disp('Simulation time for my old script:')
tic
[t,j,x] = HyEQsolver_old_fast( @f, @g, @C, @D,...
    States_init, TSPAN, JSPAN, rule, options, 'ode45');   
toc
%%
disp('Simulation time for current implementation:')
tic
[t,j,x] = HyEQsolver( @f, @g, @C, @D,...
    States_init, TSPAN, JSPAN, rule, options, 'ode45');   
toc
%%
disp('Simulation time for my atempted accelaration:')
tic
[t,j,x] = HyEQsolver_new_slow( @f, @g, @C, @D,...
    States_init, TSPAN, JSPAN, rule, options, 'ode45');   
toc

%%
figure 
plot(t, x(:, 1:2), 'b');
xlabel('t')
ylabel('x')
grid on

