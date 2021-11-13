%% How to Implement and Solve a Hybrid System
%% Create a HybridSystem Subclass
% In this tutorial, we walk through how to create and solve a hybrid system 
% using the |HybridSystem| class. To demonstrate, consider the bouncing ball system 
% defined in |BouncingBall.m|:
% 
% <include>BouncingBall.m</include>
%% 
% In the first line of file, |"classdef BouncingBall  < 
% HybridSystem"| specifies that |BouncingBall| is a
% subclass of the |HybridSystem| class, 
% which means it inherits all the methods and properties of that class. Next, 
% we define several variables in the |properties| block and functions in the |methods| 
% block. Every subclass of |HybridSystem| must define the |flowMap, jumpMap, flowSetIndicator,| 
% and |jumpSetIndicator| functions. The indicator functions must return |1| 
% inside their respective sets and |0| otherwise.
% 
% Notice that the first argument in each function is |this|. The |this|
% argument provides a reference to the object on which the function was
% called. The object's properties are referenced using |this.gravity| and
% |this.bounce_coeff|.

% Before we can solve a hybrid system, we create an instance of our
% subclass of |HybridSystem|.
bb_system = hybrid.examples.BouncingBall();
%% 
% Values of the properties can be modified using dot indexing on the object:
bb_system.gravity = 3.72;
bb_system.bounce_coeff = 0.8;

%%
% WARNING: For any given values |(x, t, j)|, the
% functions |flowMap|, |jumpMap|, |flowSetIndicator|, and |jumpSetIndicator|
% must always return the same value each time they are called while computing a
% solution. Modifying global variables or object properties within
% |flowMap|, |jumpMap|, etc., will produce unpredictable behavior because the hybrid
% solver sometimes moves backwards in time (e.g., when searching for the time
% when a jump occurs). Therefore, all values that change during a solution must
% be included in the state vector |x|.
% For this reason, we recommend making
% properties immutable and setting the values in the constructor. 
% An example of how to implement this is included here:
 %
 %   classdef MyHybridSystem < HybridSystem
 %      properties(SetAccess=immutable)
 %          my_property % cannot be modified except in the constructor
 %      end
 %      methods
 %          function this = MyHybridSystem(my_property) % Constructor
 %              this.my_property = my_property; % set property value.
 %          end
 %      end
 %   end
 %
% The value of |my_property| is set when a system is constructed:
 % 
 %   sys = MyHybridSystem(3.14); 
 %
 

%% Compute Solutions
% To compute a solution, pass the initial state and time spans to the 
% |solve| function, which is defined in the |HybridSystem| class (|bb_system| is a 
% |HybridSystem| object because |BouncingBall| 
% is a subclass of |HybridSystem|). Optionally, a |HybridSolverConfig| object
% can be passed to the solver to set various configurations (see below).

x0 = [10, 0];
tspan = [0, 30];
jspan = [0, 100];
config = HybridSolverConfig('refine', 12); % Improves plot smoothness.
sol = bb_system.solve(x0, tspan, jspan, config);
plotFlows(sol);

%% Information About Solutions
% The return value of the |solve| method is a |HybridSolution| object that contains 
% information about the solution.
sol

%% 
% A description of each |HybridSolution| property is as follows:
%
% * |t|: The continuous time values of the solution's hybrid time domain.
% * |j|: The discrete time values of the solution's hybrid time domain.
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
% * |UNDETERMINED| 

%% 
% The value |UNDETERMINED| only occurs if the |HybridSolution| object is
% constructed without the optional arguments |C|, |D|, |tspan|, and |jspan|.

%% Evaluating a Function Along a Solution
% It is sometimes useful to evaluate a function along the
% solution. This functionality is provided by the method |evaluateFunction|
% in |HybridSolution|.
energy_fnc = @(x) bb_system.gravity * x(1) + 0.5*x(2)^2;
energy = sol.evaluateFunction(energy_fnc);

%%
% |HybridPlotBuilder| calls |evaluateFunction| internally if a function handle is
% passed to any of its plotting functions.
clf
HybridPlotBuilder().plotFlows(sol, energy_fnc);
title('Total Energy')

%% Solver Configuration Options
% To configure the hybrid solver, create a
% |HybridSolverConfig| object and pass it to |solve| as follows:
config = HybridSolverConfig('silent', 'AbsTol', 1e-3);
bb_system.solve(x0, tspan, jspan, config);

%%
% By default, the hybrid solver gives precedence to jumps when the solution
% is in the intersection of the flow and jump sets. This can be changed by
% setting the |priority| to one of the (case insensitive) strings |'flow'| or
% |'jump'|.
config.priority('flow');
config.priority('jump');

%% 
% The ODE solver function and solver options can be modified in |config|. The functions 
% |RelTol|, |AbsTol|, |MaxStep|, and |Refine| provide convenient ways to set the
% corresponding ODE solver options. Other options can be set using the
% |odeOption| function (not all of the options have be tested with the hybrid
% equation solver so they should be used with caution).

config.odeSolver('ode23s');
config.RelTol(1e-3);
config.AbsTol(1e-4);
config.MaxStep(0.5);
config.Refine(4);
config.odeOption('InitialStep', 0.1);
config.odeOption('MassSingular', 'no');

% Display the options struct.
config.ode_options

%% 
% Computing a hybrid solution can take considerable time, so progress updates are
% displayed. Progress updates can be disabled by passing |'silent'| to
% |config.progess()|.
config.progress('silent');

% To restore the default behavior:
config.progress('popup');

%% 
% For brevity, |'silent'| can be also be passed directly to |solve| in place of
% |config|. 
bb_system.solve(x0, tspan, jspan, 'silent');