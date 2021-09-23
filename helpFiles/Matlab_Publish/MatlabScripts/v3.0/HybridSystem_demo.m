%% How to Implement and Solve a Hybrid System
%% Create a HybridSystem Subclass
% In this tutorial, we walk through how to create and solve a hybrid system 
% using the |HybridSystem| class. To demonstrate, consider the bouncing ball system 
% defined in |ExampleBouncingBallHybridSystem.m|:
% 
% <include>ExampleBouncingBallHybridSystem.m</include>
%% 
% In the first line of file, |"classdef ExampleBouncingBallHybridSystem  < 
% HybridSystem"| specifies that |ExampleBouncingBallHybridSystem| is a
% subclass of the |HybridSystem| class, 
% which means it inherits all the methods and properties of that class. Next, 
% we define several variables in the |properties| block and functions in the |methods| 
% block. Every subclass of |HybridSystem| must define the |flowMap, jumpMap, flowSetIndicator,| 
% and |jumpSetIndicator| functions. The indicator functions should return |1| 
% inside their respective sets and |0| otherwise.
% 
% Notice that the first argument in each of the functions is |this|. The |this|
% arugment provides a reference to the object on which the function was
% called. The object's properties are referenced using |this.gravity| and
% |this.bounce_coeff|.
%% Solve the HybridSystem
% Now that we have an implementation of the |HybridSystem|, we can create an 
% instance of it.

bb_system = ExampleBouncingBallHybridSystem();
%% 
% Values of the properties can be modified using dot indexing on the object:

bb_system.gravity = 3.72;
bb_system.bounce_coeff = 0.8;
%% 
% To compute a solution, pass the initial state and time spans to the 
% |solve| function, which is defined in the |HybridSystem| class (|bb_system| is a 
% |HybridSystem| object because |ExampleBouncingBallHybridSystem| 
% is a subclass of |HybridSystem|).

x0 = [10, 0];
tspan = [0, 30];
jspan = [0, 100];
config = HybridSolverConfig('refine', 12);
sol = bb_system.solve(x0, tspan, jspan, config);
plotFlows(sol);

%% Information About Solution
% The return value of the |solve| method is a |HybridSolution| object and contains 
% various information about the solution.
disp(sol)

%% 
% A description of each HybridSolution property is as follows:
%
% * |t|: The continuous times of the solution.
% * |j|: The discrete times of the solution.
% * |x|: The state vector of the solution.
% * |x0|: The initial state of the solution.
% * |xf|: The final state of the solution.
% * |flow_lengths|: the durations of each interval of flow.
% * |jump_times|: the continuous times when each jump occured.
% * |shortest_flow_length|: the length of the shortest interval of flow.
% * |total_flow_length|: the length of the entire solution in continuous time.
% * |jump_count|: the number of discrete jumps.
% * |termination_cause|: the reason that the solution terminated. 
%
% The possible values for |termination_cause| are 
% 
% * |STATE_IS_INFINITE|
% * |STATE_IS_NAN|
% * |STATE_NOT_IN_C_UNION_D|  
% * |T_REACHED_END_OF_TSPAN| 
% * |J_REACHED_END_OF_JSPAN|
% * |CANCELED|
% * |UNDETERMINED| (Only occurs if the optional arguments C, D, tspan, jspan
% are ommitted)
%

%% Evaluating a Function Along a Solution
% It is frequently desirable to evaluate a function along the
% solution. This functionality is provided by the method |evaluateFunction|
% in |HybridSolution|.
energy_fnc = @(x) bb_system.gravity * x(1) + 0.5*x(2)^2;
enregy = sol.evaluateFunction(energy_fnc);

%%
% |HybridPlotBuilder| calls |evaluateFunction| if a function handle is
% passed to a plotting function.
HybridPlotBuilder().plot(sol, energy_fnc);

%% Configuration Options
% To configure the ODE solver and progress updates, create a
% |HybridSolverConfig| object and pass it to |solve| as follows (if no
% properties are changed on |config|, then this reproduces the default behavior):
config = HybridSolverConfig();
bb_system.solve(x0, tspan, jspan, config);

%%
% By default, the hybrid solver gives precedence to jumps when the solution
% is in the intersection of the flow and jump sets. This can be changed by
% setting the |hybrid_priority| property to one of the enumeration values
% in |HybridPriority|.
config.hybrid_priority = HybridPriority.FLOW;
config.hybrid_priority = HybridPriority.JUMP;

%% 
% The ODE solver and options can be modified in |config|. The functions 
% |RelTol|, |AbsTol|, |MaxStep|, and |Refine| provide convenient ways to set the
% corresponding ODE solver options. Other options can be set using the
% |odeOption| function, but are untested with the hybrid equation solver so they 
% should be used with caution.

config.ode_solver = 'ode23s';
config.RelTol(1e-3);
config.AbsTol(1e-4);
config.Refine(4);
config.odeOption('InitialStep', 0.4);
config.odeOption('MassSingular', 'no');

% Display the options struct.
config.ode_options

%% 
% Computing a hybrid solution can take considerable time, so progress updates are
% displayed. The default behavior is to use the 
% |PopupHybridProgress| class. 
progress = PopupHybridProgress();

%%
% We can configure the |progress| object by setting the values
% of its properties. First, we change the displayed resolution for 
% continuous time (this also effects the frequency of updates).
progress.t_decimal_places = 1; 

%%
% We can also set the maximum refresh rate to 1 second to make the solver
% slightly faster.
progress.min_delay = 1.0;

%%
% Then we pass |progress| to |config.progress| and pass |config| to
% |solve|.
config.progress(progress);
bb_system.solve(x0, tspan, jspan, config);

%% 
% Alternatively, progress updates can be disabled by passing |'silent'| to
% |config.progess()|.
config.progress('silent');

%% 
% If no other solver configurations are desired, then 'silent' can be passed
% directly to |solve| in place of |config|.
bb_system.solve(x0, tspan, jspan, 'silent');